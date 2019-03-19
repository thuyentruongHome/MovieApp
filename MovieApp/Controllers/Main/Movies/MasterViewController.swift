//
//  MasterViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var movieSegmentControl: UISegmentedControl!
  @IBOutlet weak var popularMovieCollectionView: UICollectionView!
  @IBOutlet weak var mostRatedMovieCollectionView: UICollectionView!
  @IBOutlet weak var myFavMovieCollectionView: UICollectionView!

  public var delegate: MovieSelectionDelegate?
  var notificationToken: NotificationToken?

  private let reuseIdentifier = "movieCell"
  private let itemsPerRow: CGFloat = 3
  private let movieThumbnailRatio: CGFloat = 125 / 185
  private let (interItemSpacing, lineSpacing): (CGFloat, CGFloat) = (4, 4)

  public var isMovieSelected = false
  private var currentMoviesPage = [
    MovieSegment.Popular: 0,
    MovieSegment.MostRated: 0,
    MovieSegment.MyFav: 0
  ]
  private var popularMovies = [Movie]()
  private var mostRatedMovies = [Movie]()
  private var myFavMovies = [Movie]()
  private lazy var favoriteMovies = {
    Movie.getAllLiked()
  }()

  // MARK: - Init
  override func viewDidLoad() {
    super.viewDidLoad()
    movieSegmentControl.sendActions(for: .valueChanged)
  }

  deinit {
    notificationToken?.invalidate()
  }

  // MARK: - Handlers
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    for collectionView in [popularMovieCollectionView, mostRatedMovieCollectionView] {
      guard let collectionViewLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
      collectionViewLayout.prepare()
      collectionViewLayout.invalidateLayout()
    }
  }

  @IBAction func categorySegmentTapped(_ sender: Any) {
    guard let categorySegment = sender as? UISegmentedControl else { return }
    let selectedMovieSegment = MovieSegment(rawValue: categorySegment.selectedSegmentIndex)!
    switch selectedMovieSegment {
    case .Popular:
      popularMovieCollectionView.isHidden = false
      mostRatedMovieCollectionView.isHidden = true
      myFavMovieCollectionView.isHidden = true
    case .MostRated:
      popularMovieCollectionView.isHidden  = true
      mostRatedMovieCollectionView.isHidden = false
      myFavMovieCollectionView.isHidden = true
    case .MyFav:
      popularMovieCollectionView.isHidden  = true
      mostRatedMovieCollectionView.isHidden = true
      myFavMovieCollectionView.isHidden = false
    }

    if currentMoviesPage[selectedMovieSegment] == 0 {
      loadMoviesIn(selectedMovieSegment)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension MasterViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fetchMatchingMovieListOf(collectionView).count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let movie = fetchMatchingMovieListOf(collectionView)[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionCell
    cell.activtyIndicator.startAnimating()
    if let posterPath = movie.posterPath {
      API.MovieService.fetchMovieImage(posterPath: posterPath, completionHandler: { (image) in
        cell.moviePoster.image = image
        cell.activtyIndicator.stopAnimating()
      })
    } else {
      cell.moviePoster.image = Constants.defaultPoster
      cell.activtyIndicator.stopAnimating()
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MasterViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = interItemSpacing * (itemsPerRow - 1)
    let widthPerItem = (collectionView.frame.width - paddingSpace) / itemsPerRow
    let heightPerItem = widthPerItem / movieThumbnailRatio
    return CGSize(width: widthPerItem, height: heightPerItem)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return interItemSpacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return lineSpacing
  }
}

// MARK: - UICollectionViewDelegate
extension MasterViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = fetchMatchingMovieListOf(collectionView)[indexPath.row]
    delegate?.movieSelected(movie)
    isMovieSelected = true

    if let detailViewController = delegate as? MovieDetailViewController {
      splitViewController?.showDetailViewController(detailViewController, sender: nil)
    }
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let movieList = fetchMatchingMovieListOf(collectionView)
    let movieSegment = fetchMatchingMovieSegmentOf(collectionView)
    if collectionView != myFavMovieCollectionView && indexPath.row == movieList.count - 1 {
      loadMoviesIn(movieSegment)
    }
  }
}

extension MasterViewController {
  private func loadMoviesIn(_ movieSegment: MovieSegment) {
    currentMoviesPage[movieSegment]! += 1
    let page = currentMoviesPage[movieSegment]!
    if movieSegment != .MyFav {
      API.MovieService.fetchMovies(page: page, movieSegment: movieSegment) { [weak self] (result, error) in
        guard let self = self else { return }
        if let error = error {
          self.currentMoviesPage[movieSegment]! -= 1
          self.showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
        }
        if let result = result {
          if movieSegment == .Popular {
            self.popularMovies += result.list
            self.popularMovieCollectionView.reloadData()
          } else if movieSegment == .MostRated {
            self.mostRatedMovies += result.list
            self.mostRatedMovieCollectionView.reloadData()
          }
        }
      }
    } else {
      myFavMovies = Array(favoriteMovies)
      setUpRealmNotificationFor(favoriteMovies)
    }
  }

  // Observe Results Notifications
  private func setUpRealmNotificationFor(_ member: Results<Movie>) {
    notificationToken = member.observe( { [weak self] (change) in
      guard let self = self else { return }
      switch change {
      case .initial:
        self.myFavMovieCollectionView.reloadData()
      case .update(_, let deletions, let insertions, _):
        deletions.forEach({ (deletedIndex) in
          self.myFavMovies.remove(at: deletedIndex)
          self.myFavMovieCollectionView.performBatchUpdates({
            self.myFavMovieCollectionView.deleteItems(at: [IndexPath(row: deletedIndex, section: 0)])
          }, completion: nil)
        })

        insertions.forEach({ (insertedIndex) in
          self.myFavMovies.insert(self.favoriteMovies[insertedIndex], at: insertedIndex)
          self.myFavMovieCollectionView.performBatchUpdates({
            self.myFavMovieCollectionView.insertItems(at: [IndexPath(row: insertedIndex, section: 0)])
          }, completion: nil)
        })
      case .error(let error):
        fatalError("\(error)")
      }
    })
  }

  private func fetchMatchingMovieListOf(_ collectionView: UICollectionView) -> [Movie] {
    switch collectionView {
    case popularMovieCollectionView:
      return popularMovies
    case mostRatedMovieCollectionView:
      return mostRatedMovies
    case myFavMovieCollectionView:
      return myFavMovies
    default:
      fatalError()
    }
  }

  private func fetchMatchingMovieSegmentOf(_ collectionView: UICollectionView) -> MovieSegment {
    switch collectionView {
    case popularMovieCollectionView:
      return .Popular
    case mostRatedMovieCollectionView:
      return .MostRated
    case myFavMovieCollectionView:
      return .MyFav
    default:
      fatalError()
    }
  }
}

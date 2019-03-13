//
//  MasterViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var movieSegmentControl: UISegmentedControl!
  @IBOutlet weak var popularMovieCollectionView: UICollectionView!
  @IBOutlet weak var mostRatedMovieCollectionView: UICollectionView!

  public var delegate: MovieSelectionDelegate?

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

  // MARK: - Init
  override func viewDidLoad() {
    super.viewDidLoad()
    movieSegmentControl.sendActions(for: .valueChanged)
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
      mostRatedMovieCollectionView.isHidden = true
      popularMovieCollectionView.isHidden = false
    case .MostRated:
      mostRatedMovieCollectionView.isHidden = false
      popularMovieCollectionView.isHidden = true
    case .MyFav:
      print("Fav Movies")
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
    API.MovieService.fetchMovieImage(posterPath: movie.posterPath, completionHandler: { (image) in
      cell.moviePoster.image = image
      cell.activtyIndicator.stopAnimating()
    })
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
    if indexPath.row == movieList.count - 1 {
      loadMoviesIn(movieSegment)
    }
  }
}

extension MasterViewController {
  private func loadMoviesIn(_ movieSegment: MovieSegment) {
    currentMoviesPage[movieSegment]! += 1
    let page = currentMoviesPage[movieSegment]!
    API.MovieService.fetchMovies(page: page, movieSegment: movieSegment) { [weak self] (result, error) in
      guard let self = self else { return }
      if let error = error {
        self.currentMoviesPage[movieSegment]! -= 1
        self.showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
      }
      if let result = result {
        switch movieSegment {
        case .Popular:
          self.popularMovies += result.list
          self.popularMovieCollectionView.reloadData()
        case .MostRated:
          self.mostRatedMovies += result.list
          self.mostRatedMovieCollectionView.reloadData()
        case .MyFav:
          break
        }
      }
    }
  }

  private func fetchMatchingMovieListOf(_ collectionView: UICollectionView) -> [Movie] {
    switch collectionView {
    case popularMovieCollectionView:
      return popularMovies
    case mostRatedMovieCollectionView:
      return mostRatedMovies
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
    default:
      fatalError()
    }
  }
}

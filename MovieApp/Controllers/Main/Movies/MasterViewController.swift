//
//  MasterViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase
import Alamofire

class MasterViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var movieSegmentControl: UISegmentedControl!
  @IBOutlet weak var popularMovieCollectionView: UICollectionView!
  @IBOutlet weak var mostRatedMovieCollectionView: UICollectionView!
  @IBOutlet weak var myFavMovieCollectionView: UICollectionView!
  @IBOutlet weak var emptyFavMoviesLabel: UILabel!
  @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
  
  // MARK: - Search Properties
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var searchResultView: UIView!
  @IBOutlet weak var blurSupportView: BlurSupportView!
  @IBOutlet weak var searchResultLabel: UILabel!
  @IBOutlet weak var searchResultCollectionView: UICollectionView!
  private var currentTotalPagesInSearch = 0
  
  weak var delegate: MovieSelectionDelegate?
  var notificationToken: NotificationToken?

  private let reuseIdentifier = "movieCell"
  private let itemsPerRow: CGFloat = 3
  private let movieThumbnailRatio: CGFloat = 125 / 185
  private let (interItemSpacing, lineSpacing): (CGFloat, CGFloat) = (4, 4)

  public var isMovieSelected = false
  private var selectedCollectionView: UICollectionView?
  private var selectedIndexPath: IndexPath?
  private var currentMoviesPage = [
    MovieSegment.Popular: 0,
    MovieSegment.MostRated: 0,
    MovieSegment.MyFav: 0,
    MovieSegment.Search: 0
  ]
  private var popularMovies = [Movie]()
  private var mostRatedMovies = [Movie]()
  private var myFavMovies = [Movie]() {
    didSet {
      emptyFavMoviesLabel.isHidden = myFavMovies.count != 0
    }
  }
  private var searchMovies = [Movie]()
  private var searchRequest: DataRequest?

  // MARK: - Init
  override func viewDidLoad() {
    super.viewDidLoad()
    movieSegmentControl.sendActions(for: .valueChanged)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    removeOldSelectedHighlight()
  }

  deinit {
    notificationToken?.invalidate()
  }

  // MARK: - Handlers
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    for collectionView in [popularMovieCollectionView, mostRatedMovieCollectionView, myFavMovieCollectionView, searchResultCollectionView] {
      guard let collectionViewLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
      collectionViewLayout.prepare()
      collectionViewLayout.invalidateLayout()
    }
  }

  @IBAction func categorySegmentTapped(_ sender: Any) {
    guard let categorySegment = sender as? UISegmentedControl else { return }
    searchResultView.isHidden = true
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
    default:
      break
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
    cell.moviePoster.image = nil
    if let posterPath = movie.posterPath {
      cell.request = API.MovieService.fetchMovieImage(posterPath: posterPath, completionHandler: { (image) in
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
    // Returns when Detail page is showing and user selects same movie
    if SplitViewController.isAllVisible(), selectedCollectionView == collectionView, selectedIndexPath == indexPath { return }
    removeOldSelectedHighlight()
    selectedCollectionView = collectionView; selectedIndexPath = indexPath
    let movie = fetchMatchingMovieListOf(collectionView)[indexPath.row]
    delegate?.movieSelected(movie, in: fetchMatchingMovieSegmentOf(collectionView))
    isMovieSelected = true

    if let detailViewController = delegate as? MovieDetailViewController {
      splitViewController?.showDetailViewController(detailViewController, sender: nil)
    }
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let movieList = fetchMatchingMovieListOf(collectionView)
    let movieSegment = fetchMatchingMovieSegmentOf(collectionView)
    switch collectionView {
    case popularMovieCollectionView, mostRatedMovieCollectionView:
      if indexPath.row == movieList.count - 1 {
        loadMoviesIn(movieSegment)
      }
    case searchResultCollectionView:
      if currentTotalPagesInSearch != 0 && indexPath.row == movieList.count - 1 && currentMoviesPage[.Search]! < currentTotalPagesInSearch {
        loadMoviesIn(.Search)
      }
    default:
      break
    }
  }
}

// MARK: - UISearchBarDelegate
extension MasterViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    searchResultView.isHidden ? blurSupportView.visible() : blurSupportView.invisible()
    return true
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    blurSupportView.hidden()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    view.endEditing(true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchResultCollectionView.scrollToTop()
    if searchBar.text?.isEmpty ?? true {
      blurSupportView.visible()
      searchResultView.isHidden = true
    } else {
      blurSupportView.invisible()
      mainActivityIndicator.startAnimating()
      currentMoviesPage[.Search] = 0
      searchMovies = [Movie]()
      searchResultCollectionView.reloadData()
      loadMoviesIn(.Search)
    }
  }
}

// MARK: - UI Handlers
extension MasterViewController {
  private func removeOldSelectedHighlight() {
    if let selectedCollectionView = selectedCollectionView, let selectedIndexPath = selectedIndexPath {
      selectedCollectionView.deselectItem(at: selectedIndexPath, animated: false)
    }
    selectedCollectionView = nil; selectedIndexPath = nil
  }
}

// MARK: - Data Handlers
extension MasterViewController {
  private func loadMoviesIn(_ movieSegment: MovieSegment) {
    currentMoviesPage[movieSegment]! += 1
    let page = currentMoviesPage[movieSegment]!
    switch movieSegment {
    case .MyFav:
      mainActivityIndicator.startAnimating()
      if API.UserService.isLoggedIn() {
        FirebaseDbService.getAllLiked { [weak self] (snapshot) in
          guard let self = self else { return }
          self.myFavMovies = [Movie]()
          for child in snapshot.children {
            if let snapshot = child as? DataSnapshot,
              let movie = Movie(from: snapshot) {
              self.myFavMovies.append(movie)
            }
          }
          self.myFavMovieCollectionView.reloadData()
          self.mainActivityIndicator.stopAnimating()
        }
      } else {
        let realmFavoriteMovies = LocalDbService.getAllLiked()
        myFavMovies = Array(realmFavoriteMovies)
        setUpRealmNotificationFor(realmFavoriteMovies)
      }
    case .Search:
      if let query = searchBar.text {
        searchRequest?.cancel()
        searchRequest = API.MovieService.searchMovies(query: query, page: page) { [weak self] (result, error) in
          guard let self = self else { return }
          self.mainActivityIndicator.stopAnimating()
          self.searchResultView.isHidden = false
          if let error = error {
            self.showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
          }
          if let result = result {
            self.currentTotalPagesInSearch = result.totalPages
            self.searchResultLabel.attributedText = self.buildSearchTextLabelWith(numberOfResults: result.totalResults, query: query)
            self.searchMovies += result.list
            self.searchResultCollectionView.reloadData()
          }
        }
      }
    default:
      API.MovieService.fetchMovies(page: page, movieSegment: movieSegment) { [weak self] (result, error) in
        guard let self = self else { return }
        if let error = error {
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
    }
  }
  
  private func buildSearchTextLabelWith(numberOfResults: Int, query: String) -> NSMutableAttributedString {
    let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(numberOfResults) results for ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
    attributedText.append(NSAttributedString(string: query, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.orange]))
    return attributedText
  }

  // Observe Results Notifications
  private func setUpRealmNotificationFor(_ member: Results<Movie>) {
    notificationToken = member.observe( { [weak self] (change) in
      guard let self = self else { return }
      self.mainActivityIndicator.stopAnimating()
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
          self.myFavMovies.insert(member[insertedIndex], at: insertedIndex)
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
    case searchResultCollectionView:
      return searchMovies
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
    case searchResultCollectionView:
      return .Search
    default:
      fatalError()
    }
  }
}

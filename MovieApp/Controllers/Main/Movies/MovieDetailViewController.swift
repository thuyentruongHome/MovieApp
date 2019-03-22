//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Macintosh on 3/1/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit
import Cosmos
import YoutubePlayer_in_WKWebView

class MovieDetailViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var topTitleBoxHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var topMovieTitle: UILabel!
  @IBOutlet weak var moviePoster: UIImageView!
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var movieReleaseDate: UILabel!
  @IBOutlet weak var movieStar: CosmosView!
  @IBOutlet weak var likeBtn: UIButton!
  @IBOutlet weak var infoMovieSegment: UISegmentedControl!
  @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!

  @IBOutlet weak var movieOverview: UILabel!
  @IBOutlet weak var scrollDetailsSection: UIScrollView!
  @IBOutlet weak var trailerCollectionView: UICollectionView!
  @IBOutlet weak var trailerPlayer: WKYTPlayerView!
  @IBOutlet weak var trailersActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var heightTrailerCollectionConstraint: NSLayoutConstraint!
  @IBOutlet weak var emptyTrailersLabel: UILabel!

  @IBOutlet weak var reviewsSection: UIView!
  @IBOutlet weak var reviewTableView: UITableView!
  @IBOutlet weak var reviewsIndicator: UIActivityIndicatorView!
  @IBOutlet weak var emptyReviewsLabel: UILabel!

  // MARK: - Properties - Trailer Collection View
  private var movieTrailers = [Video]() {
    didSet {
      reloadTrailerCollectionHeight()
    }
  }
  private let trailerReuseIdentifier = "trailerCell"
  private let videoRatio: CGFloat = 16 / 9
  private let itemsPerRow: CGFloat = 2
  private let (interItemSpacing, lineSpacing): (CGFloat, CGFloat) = (10, 10)
  private let trailerNameLabelTopConstraint: CGFloat = 10
  private let trailerNameLabelHeightConstraint: CGFloat = 70
  private let emptyTrailersViewHeight: CGFloat = 80
  var _widthPerTrailerCell: CGFloat?
  var _heightPerTrailerCell: CGFloat?
  func widthPerTrailerCell() -> CGFloat {
    if _widthPerTrailerCell == nil {
      let paddingSpace = interItemSpacing * (itemsPerRow - 1)
      _widthPerTrailerCell = (trailerCollectionView.frame.width - paddingSpace) / itemsPerRow
    }
    return _widthPerTrailerCell!
  }
  func heightPerTrailerCell() -> CGFloat {
    if _heightPerTrailerCell == nil {
      let trailerHeight = widthPerTrailerCell() / videoRatio
      _heightPerTrailerCell = trailerHeight + trailerNameLabelTopConstraint + trailerNameLabelHeightConstraint
    }
    return _heightPerTrailerCell!
  }

  // MARK: - Properties - Review Collection View
  private var movieReviews = [Review]()
  private let reviewReuseIdentifier = "reviewCell"
  private let topTitleBoxHeight: CGFloat = 56
  private let numberOfStar: CGFloat = 10

  var movie: Movie? {
    didSet {
      mainView.isHidden = true
      movie!.title.isEmpty ? loadMovieAndRefreshView() : refreshView()
    }
  }
  var selectedMovieSegment: MovieSegment?

  override func viewDidLoad() {
    super.viewDidLoad()
    configScrollView()
    configDynamicHeightTableView()
  }

  // MARK: - Handlers
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    guard movie != nil else { return }
    coordinator.animateAlongsideTransition(in: nil, animation: nil) { (_) in
      self._widthPerTrailerCell = nil
      self._heightPerTrailerCell = nil
      guard let collectionViewLayout = self.trailerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
      collectionViewLayout.prepare()
      collectionViewLayout.invalidateLayout()
      self.reloadTrailerCollectionHeight()
      self.setUpMovieDetailNavigation()
      self.configCosmosStarSize()
    }
  }

  private func configScrollView() {
    scrollDetailsSection.contentLayoutGuide.bottomAnchor.constraint(equalTo: trailerCollectionView.bottomAnchor).isActive = true
  }

  private func configCosmosStarSize() {
    let availableCosmosStarsSize = view.frame.width * 0.3
    let availableStarSize = availableCosmosStarsSize / numberOfStar
    movieStar.settings.starSize = Double(availableStarSize)
  }
  private func configDynamicHeightTableView() {
    reviewTableView.rowHeight = UITableView.automaticDimension
    reviewTableView.estimatedRowHeight = 300
  }

  @IBAction func infoSegmentTapped(_ segment: UISegmentedControl) {
    switch segment.selectedSegmentIndex {
    case 0: // Details
      scrollDetailsSection.scrollToTop()
      scrollDetailsSection.isHidden = false
      reviewsSection.isHidden = true
      loadDetailsSection()
    case 1: // Reviews
      reviewTableView.scrollToTop()
      reviewsSection.isHidden = false
      scrollDetailsSection.isHidden = true
      loadReviewsSection()
    default:
      break
    }
  }

  private func reloadTrailerCollectionHeight() {
    if movieTrailers.count == 0 {
      heightTrailerCollectionConstraint.constant = emptyTrailersViewHeight
    } else {
      let numberOfVideoRows = ceil(CGFloat(movieTrailers.count) / itemsPerRow)
      heightTrailerCollectionConstraint.constant = numberOfVideoRows * (heightPerTrailerCell() + lineSpacing)
    }
    scrollDetailsSection.layoutIfNeeded()
  }

  func refreshView() {
    setUpMovieDetailNavigation()
    mainView.isHidden = false
    resetUIView()
    configCosmosStarSize()
    loadMovieBaseInfo()
  }
  
  private func setUpMovieDetailNavigation() {
    if SplitViewController.isAllVisible() {
      NotificationCenter.default.post(name: .HiddenMovieDetailNavigation, object: nil)
      topTitleBoxHeightConstraint.constant = topTitleBoxHeight
      topMovieTitle.text = "\(selectedMovieSegment!.text()) • \(movie!.title)"
    } else {
      topTitleBoxHeightConstraint.constant = 0
      NotificationCenter.default.post(name: .DidSelectMovie, object: movie)
    }
  }

  private func resetUIView() {
    movieTrailers.removeAll()
    movieReviews.removeAll()
    trailerCollectionView.reloadData()
    reviewTableView.reloadData()

    reviewTableView.isHidden = false
    emptyReviewsLabel.isHidden = true
    trailerCollectionView.isHidden = false
    emptyTrailersLabel.isHidden = true

    infoMovieSegment.selectedSegmentIndex = 0
    infoMovieSegment.sendActions(for: .valueChanged)
  }

  private func loadMovieBaseInfo() {
    guard let movie = movie else { return }
    if let posterPath = movie.posterPath {
      _ = API.MovieService.fetchMovieImage(posterPath: posterPath, completionHandler: { [weak self] (image) in
        guard let self = self else { return }
        self.moviePoster.image = image
      })
    } else {
      moviePoster.image = Constants.defaultPoster
    }
    
    movieTitle.text = movie.title
    movieReleaseDate.text = movie.formattedReleaseDate()
    movieStar.rating = movie.voteAverage
    
    movie.didLike { [weak self] in self?.likeBtn.isSelected = $0 }
  }

  private func loadDetailsSection() {
    guard let movie = movie else { return }
    movieOverview.text = movie.overview ?? Constants.defaultOverview
    trailersActivityIndicator.startAnimating()
    API.MovieService.fetchVideosOfMovie(movieId: movie.id) { [weak self] (result, error) in
      guard let self = self else { return }
      self.trailersActivityIndicator.stopAnimating()
      if let error = error {
        self.showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
      }
      if let result = result {
        self.movieTrailers = result.list.filter({ (video) -> Bool in
          video.type == Constants.theMovie.trailerType
        })
        if self.movieTrailers.isEmpty {
          self.emptyTrailersLabel.isHidden = false
          self.trailerCollectionView.isHidden = true
        } else {
          self.trailerCollectionView.reloadData()
        }
      }
    }
  }

  @IBAction func likeBtnTapped(_ sender: Any) {
    let button = sender as! UIButton
    button.isSelected = !button.isSelected
    if let movie = movie {
      button.isSelected ? movie.like() : movie.removeLike()
    }
  }
}

// MARK: - MovieSelectionDelegate
extension MovieDetailViewController: MovieSelectionDelegate {
  func movieSelected(_ selectedMovie: Movie, in selectedSegment: MovieSegment) {
    selectedMovieSegment = selectedSegment
    movie = selectedMovie
  }
}

// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieTrailers.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trailerReuseIdentifier, for: indexPath) as! TrailerCollectionCell
    let trailer = movieTrailers[indexPath.row]
    cell.trailerThumbnail.image = nil
    cell.request = API.MovieService.fetchYoutubeThumbnailImage(videoId: trailer.key) { (image) in
      cell.trailerThumbnail.image = image
    }
    cell.trailerName.text = trailer.name
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: widthPerTrailerCell(), height: heightPerTrailerCell())
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return interItemSpacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return lineSpacing
  }
}

// MARK: - UICollectionViewDelegate, WKYTPlayerViewDelegate
extension MovieDetailViewController: UICollectionViewDelegate, WKYTPlayerViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let trailer = movieTrailers[indexPath.row]
    let cell = collectionView.cellForItem(at: indexPath) as! TrailerCollectionCell
    cell.activityIndicator.startAnimating()
    splitViewController?.view.isUserInteractionEnabled = false
    trailerPlayer.delegate = self
    trailerPlayer.load(withVideoId: trailer.key)
  }

  func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
    playerView.webView?.configuration.allowsInlineMediaPlayback = false
    playerView.playVideo()
  }

  func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
    if state == .playing,
      let selectedIndexPath = trailerCollectionView.indexPathsForSelectedItems?.first,
      let selectedCell = trailerCollectionView.cellForItem(at: selectedIndexPath) as? TrailerCollectionCell {
        selectedCell.activityIndicator.stopAnimating()
        splitViewController?.view.isUserInteractionEnabled = true
      }
  }
}

// MARK: - UITableView for Review
extension MovieDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieReviews.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reviewReuseIdentifier, for: indexPath) as! ReviewTableCell
    let review = movieReviews[indexPath.row]
    cell.reviewerLabel.text = review.author
    cell.reviewText.text = review.content
    cell.separatorInset = UIEdgeInsets.zero
    cell.preservesSuperviewLayoutMargins = false
    cell.layoutMargins = UIEdgeInsets.zero
    return cell
  }

  func loadReviewsSection() {
    guard let movie = movie else { return }
    reviewsIndicator.startAnimating()

    API.MovieService.fetchReviewsOfMovie(movieId: movie.id) { [weak self] (reviewsResult, error) in
      guard let self = self else { return }
      self.reviewsIndicator.stopAnimating()
      if let error = error {
        self.showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
      }
      if let reviewsResult = reviewsResult {
        self.movieReviews = reviewsResult.list
        if self.movieReviews.isEmpty {
          self.emptyReviewsLabel.isHidden = false
          self.reviewTableView.isHidden = true
        } else {
          self.reviewTableView.reloadData()
        }
      }
    }
  }
}

// MARK: - Data Handlers
extension MovieDetailViewController {
  private func loadMovieAndRefreshView() {
    guard let movie = movie else { return }
    mainActivityIndicator.startAnimating()
    API.MovieService.fetchMovie(id: movie.id) { [weak self] (updatedMovie, error) in
      guard let self = self else { return }
      self.mainActivityIndicator.stopAnimating()
      if let updatedMovie = updatedMovie {
        self.movie = updatedMovie
      }
      if let error = error {
        self.showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
      }
    }
  }
}

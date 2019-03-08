//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Macintosh on 3/1/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit
import Cosmos
import youtube_ios_player_helper_swift

class MovieDetailViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var moviePoster: UIImageView!
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var movieReleaseDate: UILabel!
  @IBOutlet weak var movieStar: CosmosView!
  @IBOutlet weak var movieOverview: UILabel!
  @IBOutlet weak var scrollDetailsView: UIScrollView!
  @IBOutlet weak var trailerCollectionView: UICollectionView!
  @IBOutlet weak var reviewTableView: UITableView!

  @IBOutlet weak var heightTrailerCollectionConstraint: NSLayoutConstraint!

  private var movieTrailers = [Video]() {
    didSet {
      reloadTrailerCollectionHeight()
    }
  }

  private let videoRatio: CGFloat = 16 / 9
  private let itemsPerRow: CGFloat = 2
  private let (interItemSpacing, lineSpacing): (CGFloat, CGFloat) = (10, 10)
  private let estimatedVideoHeight: CGFloat = 105
  private let reviewReuseIdentifier = "reviewCell"

  var movie: Movie? {
    didSet {
      refreshView()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configScrollView()
    configDynamicHeightTableView()
  }

  // MARK: - Handlers
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animateAlongsideTransition(in: nil, animation: nil) { (_) in
      guard let collectionViewLayout = self.trailerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
      collectionViewLayout.prepare()
      collectionViewLayout.invalidateLayout()
    }
  }

  private func configScrollView() {
    scrollDetailsView.contentLayoutGuide.bottomAnchor.constraint(equalTo: trailerCollectionView.bottomAnchor).isActive = true
  }

  private func configDynamicHeightTableView() {
    reviewTableView.rowHeight = UITableView.automaticDimension
    reviewTableView.estimatedRowHeight = 300
  }

  @IBAction func infoSegmentTapped(_ segment: UISegmentedControl) {
    switch segment.selectedSegmentIndex {
    case 0: // Details
      scrollDetailsView.scrollToTop()
      scrollDetailsView.isHidden = false
      reviewTableView.isHidden = true

    case 1: // Reviews
      reviewTableView.scrollToTop()
      reviewTableView.isHidden = false
      scrollDetailsView.isHidden = true
    default:
      break
    }
  }

  private func reloadTrailerCollectionHeight() {
    let numberOfVideoRows = ceil(CGFloat(movieTrailers.count) / itemsPerRow)
    heightTrailerCollectionConstraint.constant = numberOfVideoRows * estimatedVideoHeight
    scrollDetailsView.layoutIfNeeded()
  }

  func refreshView() {
    guard let movie = movie else { return }
    mainView.isHidden = false
    scrollDetailsView.scrollToTop()
    API.MovieService.fetchMovieImage(posterPath: movie.posterPath, completionHandler: { [weak self] (image) in
      guard let self = self else { return }
      self.moviePoster.image = image
    })
    movieTitle.text = movie.title
    movieReleaseDate.text = movie.formattedReleaseDate()
    movieStar.rating = movie.voteAverage
    movieStar.isHidden = false

    movieOverview.text = movie.overview

    API.MovieService.fetchVideosOfMovie(movieId: movie.id) { [weak self] (result, error) in
      guard let self = self else { return }
      if let error = error {
        self.showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
      }
      if let result = result {
        self.movieTrailers = result.list.filter({ (video) -> Bool in
          video.type == Constants.theMovie.trailerType
        })
        self.trailerCollectionView.reloadData()
      }
    }
  }

  @IBAction func likeBtnTapped(_ sender: Any) {
    let button = sender as! UIButton
    button.isSelected = !button.isSelected
  }
}

extension MovieDetailViewController: MovieSelectionDelegate {
  func movieSelected(_ selectedMovie: Movie) {
    movie = selectedMovie
  }
}

// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieTrailers.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrailerCollectionView
    let trailer = movieTrailers[indexPath.row]
    cell.trailerPlayer.load(videoId: trailer.key)
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = interItemSpacing * (itemsPerRow - 1)
    let widthPerItem = (trailerCollectionView.frame.width - paddingSpace) / itemsPerRow
    let heightPerItem = widthPerItem / videoRatio
    return CGSize(width: widthPerItem, height: heightPerItem)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return interItemSpacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return lineSpacing
  }
}

// MARK: - UITableView for Review
extension MovieDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reviewReuseIdentifier, for: indexPath) as! ReviewTableCell
    cell.reviewerLabel.text = "Tinh Nguyen"
    cell.reviewText.text = "I think so I am! Apply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more "
    cell.separatorInset = UIEdgeInsets.zero
    cell.preservesSuperviewLayoutMargins = false
    cell.layoutMargins = UIEdgeInsets.zero
    return cell
  }
}

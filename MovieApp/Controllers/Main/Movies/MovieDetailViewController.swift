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
  @IBOutlet weak var moviePoster: UIImageView!
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var movieReleaseDate: UILabel!
  @IBOutlet weak var movieStar: CosmosView!
  @IBOutlet weak var movieOverview: UILabel!
  @IBOutlet weak var scrollDetailsView: UIScrollView!
  @IBOutlet weak var trailerCollectionView: UICollectionView!
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

  var movie: Movie? {
    didSet {
      refreshView()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configScrollView()
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

  private func reloadTrailerCollectionHeight() {
    let numberOfVideoRows = ceil(CGFloat(movieTrailers.count) / itemsPerRow)
    heightTrailerCollectionConstraint.constant = numberOfVideoRows * estimatedVideoHeight
    scrollDetailsView.layoutIfNeeded()
  }

  func refreshView() {
    guard let movie = movie else { return }
    scrollDetailsView.contentOffset = CGPoint(x: 0, y: 0)
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

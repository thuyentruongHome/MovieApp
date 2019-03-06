//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Macintosh on 3/1/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit
import Cosmos

class MovieDetailViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var moviePoster: UIImageView!
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var movieReleaseDate: UILabel!
  @IBOutlet weak var movieStar: CosmosView!
  @IBOutlet weak var movieOverview: UILabel!
  @IBOutlet weak var scrollDetailsView: UIScrollView!


  var movie: Movie? {
    didSet {
      refreshView()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configScrollView()
  }

  private func configScrollView() {
    scrollDetailsView.contentLayoutGuide.bottomAnchor.constraint(equalTo: movieOverview.bottomAnchor).isActive = true
  }

  func refreshView() {
    guard let movie = movie else { return }
    API.MovieService.fetchMovieImage(posterPath: movie.posterPath, completionHandler: { [weak self] (image) in
      guard let self = self else { return }
      self.moviePoster.image = image
    })
    movieTitle.text = movie.title
    movieReleaseDate.text = movie.formattedReleaseDate()
    movieStar.rating = movie.voteAverage
    movieStar.isHidden = false

    movieOverview.text = movie.overview
  }
}

extension MovieDetailViewController: MovieSelectionDelegate {
  func movieSelected(_ selectedMovie: Movie) {
    movie = selectedMovie
  }
}

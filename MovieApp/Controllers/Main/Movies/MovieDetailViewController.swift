//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Macintosh on 3/1/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var moviePoster: UIImageView!
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var movieReleaseDate: UILabel!

  var movie: Movie? {
    didSet {
      refreshView()
    }
  }

  func refreshView() {
    guard let movie = movie else { return }
    API.MovieService.fetchMovieImage(posterPath: movie.posterPath, completionHandler: { [weak self] (image) in
      guard let self = self else { return }
      self.moviePoster.image = image
    })
    movieTitle.text = movie.title
    movieReleaseDate.text = movie.formattedReleaseDate()
  }
}

extension MovieDetailViewController: MovieSelectionDelegate {
  func movieSelected(_ selectedMovie: Movie) {
    movie = selectedMovie
  }
}

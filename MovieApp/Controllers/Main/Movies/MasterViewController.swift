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
  private let reuseIdentifier = "MovieCell"
  private let itemsPerRow: CGFloat = 3
  private let movieThumbnailRadio: CGFloat = 125 / 185
  private let (interItemSpacing, lineSpacing): (CGFloat, CGFloat) = (4, 4)

  private var popularMovies = [Movie]()

  @IBOutlet weak var movieCollectionView: UICollectionView!
  @IBOutlet weak var movieSegmentControl: UISegmentedControl!

  // MARK: - Init
  override func viewDidLoad() {
    super.viewDidLoad()

    API.MovieService.fetchPopularMovies { [weak self] (result, error) in
      guard let self = self else { return }
      if let error = error {
        self.showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
      }
      if let result = result {
        self.popularMovies = result.list
        self.movieCollectionView.reloadData()
      }
    }
  }

  // MARK: - Handlers
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard let collectionViewLayout = self.movieCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    collectionViewLayout.prepare()
    collectionViewLayout.invalidateLayout()
  }


  @IBAction func categorySegmentTapped(_ sender: Any) {
    guard let categorySegment = sender as? UISegmentedControl else { return }
    let selectedSegment = MovieSegment(rawValue: categorySegment.selectedSegmentIndex)!
    switch selectedSegment {
    case .Popular:
      print("Popular Movies")
    case .MostRated:
      print("Most Rated Movies")
    case .MyFav:
      print("Fav Movies")
    }
  }
}

// MARK: - UICollectionViewDataSource
extension MasterViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return popularMovies.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionView
    let movie = popularMovies[indexPath.row]
    API.MovieService.fetchMovieImage(posterPath: movie.posterPath, completionHandler: { (image) in
      cell.moviePoster.image = image
    })
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MasterViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = interItemSpacing * (itemsPerRow - 1)
    let widthPerItem = (movieCollectionView.frame.width - paddingSpace) / itemsPerRow
    let heightPerItem = widthPerItem / movieThumbnailRadio
    return CGSize(width: widthPerItem, height: heightPerItem)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return interItemSpacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return lineSpacing
  }
}

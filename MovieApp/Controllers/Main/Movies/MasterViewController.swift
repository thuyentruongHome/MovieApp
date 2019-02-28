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

  @IBOutlet weak var movieCollectionView: UICollectionView!

  // MARK: - Handlers

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard let collectionViewLayout = self.movieCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    collectionViewLayout.prepare()
    collectionViewLayout.invalidateLayout()
  }
}

// MARK: - UICollectionViewDataSource
extension MasterViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    cell.backgroundColor = .black
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

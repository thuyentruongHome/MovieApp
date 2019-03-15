//
//  MovieCollectionView.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var moviePoster: UIImageView!
  @IBOutlet weak var activtyIndicator: UIActivityIndicatorView!

  override var isSelected: Bool {
    didSet {
      if self.isSelected {
        moviePoster.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        moviePoster.alpha = 0.8
        backgroundColor = UIColor(red: 280, green: 50, blue: 50, alpha: 1)
      } else {
        moviePoster.transform = CGAffineTransform.identity
        moviePoster.alpha = 1.0
        backgroundColor = .clear
      }
    }
  }
}

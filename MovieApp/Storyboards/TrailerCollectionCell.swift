//
//  TrailerCollectionView.swift
//  MovieApp
//
//  Created by Macintosh on 3/6/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit
import Alamofire

class TrailerCollectionCell: UICollectionViewCell {

  // MARK: - Properties
  @IBOutlet weak var trailerThumbnail: UIImageView!
  @IBOutlet weak var trailerName: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var request: DataRequest?
  
  // MARK: - Handlers
  override func prepareForReuse() {
    super.prepareForReuse()
    request?.cancel()
  }
}

//
//  MovieSelectionDelegate.swift
//  MovieApp
//
//  Created by Macintosh on 3/1/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

protocol MovieSelectionDelegate: AnyObject {
  func movieSelected(_ selectedMovie: Movie, in selectedSegment: MovieSegment)
}

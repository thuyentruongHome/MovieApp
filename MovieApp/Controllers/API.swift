//
//  API.swift
//  MovieApp
//
//  Created by Macintosh on 2/15/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class API {

  typealias ErrorHandler = (Error?) -> Void
  typealias MoviesResponseHanlder = (MoviesResult?, Error?) -> Void
  typealias ImageResponseHanlder = (UIImage?) -> Void
}

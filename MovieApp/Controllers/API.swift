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
  typealias MoviesResponseHandler = (MoviesResult?, Error?) -> Void
  typealias VideosResponseHandler = (VideosResult?, Error?) -> Void
  typealias ImageResponseHandler = (UIImage?) -> Void
}

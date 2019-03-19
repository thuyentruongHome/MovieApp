//
//  MoviesSegment.swift
//  MovieApp
//
//  Created by Macintosh on 3/1/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation

enum MovieSegment: Int {
  case Popular
  case MostRated
  case MyFav
  case Search

  func apiPath() -> String {
    switch self {
    case .Popular:
      return Constants.theMovie.popularMoviesPath
    case .MostRated:
      return Constants.theMovie.mostRatedMoviesPath
    default:
      return ""
    }
  }
}

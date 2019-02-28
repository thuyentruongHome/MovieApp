//
//  MoviesResult.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation

struct MoviesResult: Decodable {
  let page: Int
  let list: [Movie]

  private enum CodingKeys: String, CodingKey {
    case page
    case list = "results"
  }
}

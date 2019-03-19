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
  let totalResults: Int
  let totalPages: Int

  private enum CodingKeys: String, CodingKey {
    case page
    case list = "results"
    case totalResults = "total_results"
    case totalPages = "total_pages"
  }
}

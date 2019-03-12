//
//  ReviewsResult.swift
//  MovieApp
//
//  Created by Macintosh on 3/8/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation

class ReviewsResult: Decodable {
  let id: Int
  let page: Int
  let list: [Review]

  private enum CodingKeys: String, CodingKey {
    case id, page
    case list = "results"
  }
}

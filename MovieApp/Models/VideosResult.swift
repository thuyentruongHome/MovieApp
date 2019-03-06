//
//  VideosResult.swift
//  MovieApp
//
//  Created by Macintosh on 3/6/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation

class VideosResult: Decodable {
  let id: Int
  let list: [Video]

  private enum CodingKeys: String, CodingKey {
    case id
    case list = "results"
  }
}

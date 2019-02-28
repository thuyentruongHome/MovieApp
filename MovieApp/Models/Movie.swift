//
//  Movie.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation

struct Movie: Decodable {
  let id: Int
  let title: String
  let posterPath: String

  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case posterPath = "poster_path"
  }
}

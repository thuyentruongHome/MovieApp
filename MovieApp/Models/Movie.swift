//
//  Movie.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation

struct Movie: Decodable {

  private let dateFormat = "MMMM yyyy"
  let id: Int
  let title: String
  let posterPath: String
  let releaseDate: Date

  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case posterPath = "poster_path"
    case releaseDate = "release_date"
  }

  func formattedReleaseDate() -> String {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = dateFormat

    return dateFormatterPrint.string(from: releaseDate)
  }
}

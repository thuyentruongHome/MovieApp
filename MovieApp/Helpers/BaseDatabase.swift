//
//  DbProtocol.swift
//  MovieApp
//
//  Created by East Agile on 3/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation

protocol BaseDatabase {
  static func like(_ movie: Movie)
  static func removeLike(_ movieId: Int)
  static func didLike(_ movieId: Int, completionHandler: @escaping API.BooleanResponseHandler)
}

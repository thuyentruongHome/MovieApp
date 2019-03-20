//
//  LocalDbService.swift
//  MovieApp
//
//  Created by East Agile on 3/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import RealmSwift

class LocalDbService: BaseDatabase {
  private static let realm = try! Realm()
  
  static func like(_ movie: Movie) {
    let favoriteMovie = Movie(value: ["id": movie.id, "liked": true])

    if let posterPath = movie.posterPath { favoriteMovie.posterPath = posterPath }
    try! realm.write {
      realm.add(favoriteMovie, update: true)
    }
  }
  
  static func removeLike(_ movieId: Int) {
    guard let favoriteMovie = realm.objects(Movie.self).filter("id = \(movieId)").first else { return }
    try! realm.write {
      favoriteMovie.liked = false
    }
  }
  
  static func didLike(_ movieId: Int, completionHandler: @escaping API.BooleanResponseHandler) {
    completionHandler(
      realm.objects(Movie.self).filter("id = \(movieId) AND liked == TRUE").first != nil
    )
  }
  
  static func getAllLiked() -> Results<Movie> {
    return realm.objects(Movie.self).filter("liked == TRUE").sorted(byKeyPath: "likedAt", ascending: false)
  }
}

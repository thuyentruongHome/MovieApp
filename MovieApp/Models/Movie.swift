//
//  Movie.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Movie: Object, Decodable {

  // MARK: - Properties
  private static let realm = try! Realm()
  private let dateFormat = "MMMM yyyy"

  @objc dynamic var id: Int = 0
  @objc dynamic var title = ""
  @objc dynamic var posterPath: String?
  @objc dynamic var releaseDate: Date?
  @objc dynamic var voteAverage: Double = 0.0
  @objc dynamic var overview: String?
  @objc dynamic var liked = false
  @objc dynamic var likedAt = Date()
  
  override static func primaryKey() -> String? {
    return "id"
  }

  override static func ignoredProperties() -> [String] {
    return ["title", "releaseDate", "voteAverage", "overview"]
  }

  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case voteAverage = "vote_average"
    case overview
  }
  
  required init(from decoder: Decoder) throws {
    super.init()
    let container  = try decoder.container(keyedBy: CodingKeys.self)
    id             = try container.decode(Int.self, forKey: .id)
    title          = try container.decode(String.self, forKey: .title)
    posterPath     = try container.decode(String?.self, forKey: .posterPath)
    let dateString = try container.decode(String?.self, forKey: .releaseDate)
    releaseDate    = self.parseInDate(dateString)
    voteAverage    = try container.decode(Double.self, forKey: .voteAverage)
    overview       = parseInString(try container.decode(String?.self, forKey: .overview))
  }

  // MARK: - Instance Methods
  func formattedReleaseDate() -> String {
    guard let releaseDate = releaseDate else { return "" }
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = dateFormat
    return dateFormatterPrint.string(from: releaseDate)
  }
  
  // MARK: - Realm Handlers
  required init() {
    super.init()
  }

  override init(value: Any) {
    super.init(value: value)
  }

  required init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }

  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }

  static func getAllLiked() -> Results<Movie> {
    return realm.objects(Movie.self).filter("liked == TRUE").sorted(byKeyPath: "likedAt", ascending: false)
  }

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

  static func exists(_ movieId: Int) -> Bool {
    return realm.objects(Movie.self).filter("id = \(movieId) AND liked == TRUE").first != nil
  }
}

extension Movie {
  func parseInDate(_ dateString: String?) -> Date? {
    guard let dateString = dateString else { return nil }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Constants.theMovie.dateFormat
    if let date = dateFormatter.date(from: dateString) {
      return date
    } else {
      return nil
    }
  }

  func parseInString(_ string: String?) -> String? {
    if let string = string, !string.isEmpty {
      return string
    } else {
      return nil
    }
  }
}

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
import FirebaseDatabase

class Movie: Object, Decodable {

  // MARK: - Properties
  private let dateFormat = "MMMM yyyy"
  private var dbService: BaseDatabase.Type {
    get {
      return API.UserService.isLoggedIn() ? FirebaseDbService.self : LocalDbService.self
    }
  }

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
  
  init?(from snapshot: DataSnapshot) {
    super.init()
    guard
      let value = snapshot.value as? [String: AnyObject],
      let id    = Int(snapshot.key) else {
      return nil
    }
    self.id = id
    posterPath = value["poster_path"] as? String
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
  
  func like() {
    dbService.like(self)
  }
  
  func removeLike() {
    dbService.removeLike(id)
  }
  
  func didLike(completionHandler: @escaping API.BooleanResponseHandler) {
    dbService.didLike(id, completionHandler: completionHandler)
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

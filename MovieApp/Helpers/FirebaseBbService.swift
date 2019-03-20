//
//  FirebaseBDService.swift
//  MovieApp
//
//  Created by East Agile on 3/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseDbService: BaseDatabase {
  
  // MARK: - Properties
  private static let databaseReference = Database.database().reference()
  private static let currentUserRef: DatabaseReference = {
    let userUid = API.UserService.currentUser()!.uid
    return databaseReference.child("users").child(userUid)
  }()
  private static var currentFavRef: DatabaseReference {
    return currentUserRef.child("Favorite")
  }
  
  // MARK: - Handlers
  static func like(_ movie: Movie) {
    let movieData: [String: Any] = [ "poster_path": movie.posterPath, "liked": true, "likedAt": -Int(Date().timeIntervalSince1970) ]
    currentUserRef.child("Favorite").child(String(movie.id)).setValue(movieData)
  }
  
  static func removeLike(_ movieId: Int) {
    currentFavRef.child(String(movieId)).removeValue()
  }
  
  static func didLike(_ movieId: Int, completionHandler: @escaping API.BooleanResponseHandler) {
    currentFavRef.child("\(movieId)").observeSingleEvent(of: .value, with: { (snapshot) in
      completionHandler(snapshot.exists())
    })
  }
  
  static func getAllLiked(completionHandler: @escaping API.DataSnapshotResponseHandler) {
    currentFavRef.queryOrdered(byChild: "likedAt").observe(.value) { (snapshot) in
      completionHandler(snapshot)
    }
  }
}

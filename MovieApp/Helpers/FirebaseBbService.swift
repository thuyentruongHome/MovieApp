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
  private static var currentUserRef: DatabaseReference {
    let userUid = API.UserService.currentUser()!.uid
    return databaseReference.child("users").child(userUid)
  }
  private static var currentFavRef: DatabaseReference {
    return currentUserRef.child("Favorite")
  }
  
  // MARK: - Handlers
  static func like(_ movie: Movie) {
    currentFavRef.child(String(movie.id))
                 .setValue(buildMovieData(movie))
  }
  
  static func removeLike(_ movieId: Int) {
    currentFavRef.child(String(movieId))
                 .removeValue()
  }
  
  static func didLike(_ movieId: Int, completionHandler: @escaping API.BooleanResponseHandler) {
    currentFavRef.child("\(movieId)")
                 .observe(.value) { (snapshot) in completionHandler(snapshot.exists()) }
  }
  
  static func observeFavMovies(completionHandler: @escaping API.MoviesSnapshotHandler, addCompletionHandler: @escaping API.MovieSnapshotHandler, removeCompletionHandler: @escaping API.MovieSnapshotHandler) {
    var likedMovies = [Movie]()
    currentFavRef.queryOrdered(byChild: Constants.Firebase.likedAt).observeSingleEvent(of: .value) { (snapshot) in
      for child in snapshot.children {
        if let snapshot = child as? DataSnapshot, let movie = Movie(from: snapshot) {
          likedMovies.append(movie)
        }
      }

      // Register Add/Remove Movie From Fav Movies
      // mockTime is to only fetch Added Movie after initial observing
      let mockTime = likedMovies.count > 0 ? likedMovies[0].firebaseLikedAt : currentTimeInInt()
      currentFavRef.queryOrdered(byChild: Constants.Firebase.likedAt).queryEnding(atValue: mockTime - 1).observe(.childAdded) { (snapshot) in
        if let addedMovie = Movie(from: snapshot) {
          addCompletionHandler(addedMovie)
        }
      }
      
      currentFavRef.observe(.childRemoved) { (snapshot) in
        if let removedMovie = Movie(from: snapshot) {
          removeCompletionHandler(removedMovie)
        }
      }
      completionHandler(likedMovies)
    }
  }
  
  private static func buildMovieData(_ movie: Movie) -> [String: Any] {
    return [
      Constants.Firebase.posterPath: movie.posterPath as Any,
      Constants.Firebase.likedAt:    currentTimeInInt()
    ]
  }
  
  static func currentTimeInInt() -> Int {
    return -Int(Date().timeIntervalSince1970)
  }
}

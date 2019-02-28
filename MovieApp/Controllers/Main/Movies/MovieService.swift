//
//  MovieService.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension API {
  class MovieService {

    private static let theMovieAPI = "https://api.themoviedb.org/3/movie"
    private static let popularMoviesPath = "/popular"
    private static let imageBaseURL = "https://image.tmdb.org/t/p/w342/"
    private static let apiKey = Credential.valueForKey(keyName: "THEMOVIEDB_API_KEY")

    class func fetchPopularMovies(completionHandler: @escaping MoviesResponseHanlder) {

      let url = URL(string: (theMovieAPI + popularMoviesPath))!

      Alamofire.request(url, method: .get, parameters: ["api_key": apiKey]).validate().responseData { (response) in
        switch response.result {
        case .success(let data):
          do {
            let movies = try JSONDecoder().decode(MoviesResult.self, from: data)
            completionHandler(movies, nil)
          } catch let error {
            completionHandler(nil, error)
          }
        case .failure(let error):
          completionHandler(nil, error)
        }
      }
    }

    public class func fetchMovieImage(posterPath: String, completionHandler: @escaping ImageResponseHanlder) {
      let imageUrl = URL(string: (imageBaseURL + posterPath))!
      Alamofire.request(imageUrl, method: .get).responseImage { (response) in
        completionHandler(response.result.value)
      }
    }
  }
}

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

    private static let theMovieAPI = "https://api.themoviedb.org/3"
    private static let popularMoviesPath = "/movie/popular"
    private static let videosMoviePath = "/movie/:movieId/videos"
    private static let imageBaseURL = "https://image.tmdb.org/t/p/w342/"
    private static let apiKey = Credential.valueForKey(keyName: "THEMOVIEDB_API_KEY")

    class func fetchPopularMovies(completionHandler: @escaping MoviesResponseHandler) {

      let url = URL(string: (theMovieAPI + popularMoviesPath))!

      Alamofire.request(url, method: .get, parameters: ["api_key": apiKey]).validate().responseData { (response) in
        switch response.result {
        case .success(let data):
          do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.theMovie.dateFormat
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let movies = try decoder.decode(MoviesResult.self, from: data)
            completionHandler(movies, nil)
          } catch let error {
            completionHandler(nil, error)
          }
        case .failure(let error):
          completionHandler(nil, error)
        }
      }
    }

    public class func fetchMovieImage(posterPath: String, completionHandler: @escaping ImageResponseHandler) {
      let imageUrl = URL(string: (imageBaseURL + posterPath))!
      Alamofire.request(imageUrl, method: .get).responseImage { (response) in
        completionHandler(response.result.value)
      }
    }

    public class func fetchVideosOfMovie(movieId: Int, completionHandler: @escaping VideosResponseHandler) {
      let videosUrl = URL(string: (theMovieAPI + videosMoviePath.replacingOccurrences(of: ":movieId", with: String(movieId))))!
      Alamofire.request(videosUrl, method: .get, parameters: ["api_key": apiKey]).validate().responseData { (response) in
        switch response.result {
        case .success(let data):
          do {
            let videos = try JSONDecoder().decode(VideosResult.self, from: data)
            completionHandler(videos, nil)
          } catch let error {
            completionHandler(nil, error)
          }
        case .failure(let error):
          completionHandler(nil, error)
        }
      }
    }
  }
}

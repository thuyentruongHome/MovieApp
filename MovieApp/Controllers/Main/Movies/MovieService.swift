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
    private static let detailsMovieAPI = theMovieAPI + "/movie/:movieId"
    private static let videosMoviePath = "/movie/:movieId/videos"
    private static let searchMoviesPath = theMovieAPI + "/search/movie"
    private static let reviewsMoviePath = "/movie/:movieId/reviews"
    private static let imageBaseURL = "https://image.tmdb.org/t/p/w342/"
    private static let youtubeThumbnailURL = "https://img.youtube.com/vi/:videoId/hqdefault.jpg"
    private static let apiKey = Credential.valueForKey(keyName: "THEMOVIEDB_API_KEY")

    class func fetchMovies(page: Int = 1, movieSegment: MovieSegment, completionHandler: @escaping MoviesResponseHandler) {
      let url = URL(string: (theMovieAPI + movieSegment.apiPath()))!
      Alamofire.request(url, method: .get, parameters: ["api_key": apiKey, "page": page]).validate().responseData { (response) in
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

    class func fetchMovie(id: Int, completionHandler: @escaping MovieResponseHandler) {
      let url = URL(string: detailsMovieAPI.replacingOccurrences(of: ":movieId", with: String(id)))!
      Alamofire.request(url, method: .get, parameters: ["api_key": apiKey]).validate().responseData { (response) in
        switch response.result {
        case .success(let data):
          do {
            let movies = try JSONDecoder().decode(Movie.self, from: data)
            completionHandler(movies, nil)
          } catch let error {
            completionHandler(nil, error)
          }
        case .failure(let error):
          completionHandler(nil, error)
        }
      }
    }

    public class func fetchMovieImage(posterPath: String, completionHandler: @escaping ImageResponseHandler) -> DataRequest {
      let imageUrl = URL(string: (imageBaseURL + posterPath))!
      return Alamofire.request(imageUrl, method: .get).responseImage { (response) in
        completionHandler(response.result.value)
      }
    }

    public class func fetchYoutubeThumbnailImage(videoId: String, completionHandler: @escaping ImageResponseHandler) -> DataRequest {
      let imageURL = URL(string: youtubeThumbnailURL.replacingOccurrences(of: ":videoId", with: videoId))!
      return Alamofire.request(imageURL, method: .get).responseImage { (response) in
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

    public class func fetchReviewsOfMovie(movieId: Int, completionHandler: @escaping ReviewsResponseHandler) {
      let reviewsURL = URL(string: (theMovieAPI + reviewsMoviePath.replacingOccurrences(of: ":movieId", with: String(movieId))))!
      Alamofire.request(reviewsURL, method: .get, parameters: ["api_key": apiKey]).validate().responseData { (response) in
        switch response.result {
        case .success(let data):
          do {
            let reviewResult = try JSONDecoder().decode(ReviewsResult.self, from: data)
            completionHandler(reviewResult, nil)
          } catch let error {
            completionHandler(nil, error)
          }
        case .failure(let error):
          completionHandler(nil, error)
        }
      }
    }
    
    class func searchMovies(query: String, page: Int = 1, completionHandler: @escaping MoviesResponseHandler) -> DataRequest {
      return Alamofire.request(searchMoviesPath, method: .get, parameters: ["api_key": apiKey, "query": query, "page": page]).validate().responseData { (response) in
        switch response.result {
        case .success(let data):
          do {
            let movies = try JSONDecoder().decode(MoviesResult.self, from: data)
            completionHandler(movies, nil)
          } catch let error {
            completionHandler(nil, error)
          }
        case .failure(let error):
          if error._code != API.cancelledErrorCode { completionHandler(nil, error) }
        }
      }
    }
  }
}

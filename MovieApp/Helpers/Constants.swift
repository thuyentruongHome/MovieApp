//
//  Constants.swift
//  MovieApp
//
//  Created by Macintosh on 2/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

public let hostDomain = "movieapp.com"
public let hostErrorCode = 1

public struct Constants {
  
  public static let defaultPoster = UIImage(named: "default_poster")

  public struct theMovie {
    public static let dateFormat = "yyyy-MM-dd"
    public static let trailerType = "Trailer"
    public static let popularMoviesPath = "/movie/popular"
    public static let mostRatedMoviesPath = "/movie/top_rated"
  }

  public struct Policy {
    public static let minimumPasswordLength = 6
  }

  public struct TitleAlert {
    public static let forgotPassword = "Forgot Password"
    public static let error = "Error"
    public static let incorrectEmail = "Incorrect Email"
    public static let incorrectPassword = "Incorrect Password"
  }

  public struct Message {
    public static let sentForgotPasswordMail = "Your password reset email was sent. Please check your inbox!"
  }

  // MARK: Error Constants
  public struct ErrorMessage {
    public static let requiredEmail = "An email address must be provided."
    public static let requiredPassword = "A password must be provided."
    public static let passwordLimitation = "The password must be 6 characters long or more."
    public static let incorrectEmail = "The email you entered doesn't appear to belong to an account. Please check your email address and try again."
    public static let incorrectPassword = "The password you entered is incorrect. Please try again."
  }
}

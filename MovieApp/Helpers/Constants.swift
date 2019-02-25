//
//  Constants.swift
//  MovieApp
//
//  Created by Macintosh on 2/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation

public let hostDomain = "movieapp.com"
public let hostErrorCode = 1

public struct Constants {

  public struct Policy {
    public static let minimumPasswordLength = 6
  }

  public struct TitleAlert {
    public static let error = "Error"
    public static let incorrectEmail = "Incorrect Email"
    public static let incorrectPassword = "Incorrect Password"
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

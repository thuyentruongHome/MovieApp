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

  // MARK: Error Constants
  public static let errorTitleAlert = "Error"

  public struct ErrorMessage {
    public static let requiredEmail = "An email address must be provided."
    public static let passwordLimitation = "The password must be 6 characters long or more."
  }
}

//
//  AuthenticationScreens.swift
//  MovieAppUITests
//
//  Created by Macintosh on 2/20/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import KIF

extension KIFTestCase {

  func expectToSeeLandingScreen() {
    expectToSee("Sign In", "Sign Up")
    expectToSee("Or Skip")
  }

  func expectToSeeSignUpScreen() {
    expectToSee("Email TextField", "Password TextField")
    expectToSee("Cancel", "Sign Up")
  }
}

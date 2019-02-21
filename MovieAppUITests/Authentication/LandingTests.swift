//
//  LandingTests.swift
//  MovieAppUITests
//
//  Created by Macintosh on 2/19/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import KIF

class LandingTests: KIFTestCase {

  // MARK: - Tests
  func testSignUpButton() {
    tapButton("Sign Up")
    expectToSeeSignUpScreen()
  }
}

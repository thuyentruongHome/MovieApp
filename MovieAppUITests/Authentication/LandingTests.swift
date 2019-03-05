//
//  LandingTests.swift
//  MovieAppUITests
//
//  Created by Macintosh on 2/19/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import KIF

class LandingTests: KIFTestCase {

  override func beforeEach() {
    backToRoot()
  }

  // MARK: - Tests
  func testSignUpButton() {
    tapButton("Sign Up")
    expectToSeeSignUpScreen()
  }

  func testSignInButton() {
    tapButton("Sign In")
    expectToSeeSignInScreen()
  }
}

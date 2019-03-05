//
//  UnloggedUserTests.swift
//  MovieAppUITests
//
//  Created by Macintosh on 2/27/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation

class UnloggedUserTests: BaseUITests {
  override func beforeEach() {
    gotoMainScreen()
    tester().waitForAnimationsToFinish()
    tapButton("Hamburger Menu Icon")
  }

  // MARK: - Tests
  func testScreen() {
    expectToSee("Sign in")
  }

  func testSignInButton() {
    tapButton("Sign in")
    expectToSeeSignInScreen()
  }
}

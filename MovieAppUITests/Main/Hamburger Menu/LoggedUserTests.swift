//
//  HamburgerMenu.swift
//  MovieAppUITests
//
//  Created by Macintosh on 2/27/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import KIF
import Fakery
import Firebase
import Nimble

@testable import MovieApp

class LoggedUserTests: BaseUITests {
  private let email = TestConstants.registeredEmail
  private let userPassword = TestConstants.userPassword

  override func beforeAll() {
    super.beforeAll()
    signUserIn(withEmail: email, password: userPassword)
  }

  override func afterAll() {
    super.afterAll()
    deleteUser(withEmail: email, password: userPassword)
  }

  override func beforeEach() {
    gotoMainScreen()
    tapButton("Hamburger Menu Icon")
    tester().waitForAnimationsToFinish()
  }

  // MARK: - Tests
  func testScreen() {
    expectToSee(email)
    expectToSee("Sign out")
  }

  func testSignOutButton() {
    tapButton("Sign out")
    expectToSeeLandingScreen()
  }
}

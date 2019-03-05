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

class HamburgerMenuTests: BaseUITests {
  override func beforeEach() {
    gotoMainScreen()
    tapButton("Hamburger Menu Icon")
  }

  // MARK: - Tests
  func test() {
    tapButton("Sign Up")
    expectToSeeSignUpScreen()
  }
}

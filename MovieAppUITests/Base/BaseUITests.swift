//
//  BaseUITests.swift
//  MovieAppUITests
//
//  Created by Macintosh on 2/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import KIF
import Firebase

class BaseUITests: KIFTestCase {

  override func beforeAll() {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
  }

  func signUserIn(withEmail email: String, password: String) {
    createUser(withEmail: email, password: password)

    gotoLandingScreen()
    tapButton("Sign In")
    fillIn("Email TextField", with: email)
    fillIn("Password TextField", with: password)
    tapButton("Sign In")
    tester().waitForAnimationsToFinish()
  }

  func logOutAndDeleteUser(withEmail email: String, password: String) {
    deleteUser(withEmail: email, password: password)
    gotoMainScreen()
    tapButton("Hamburger Menu Icon")
    tester().waitForAnimationsToFinish()
    tapButton("Sign out")
  }
}

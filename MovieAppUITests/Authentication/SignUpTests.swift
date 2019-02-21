//
//  SignUpTests.swift
//  MovieAppUITests
//
//  Created by Macintosh on 2/19/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import KIF
import Fakery
import Firebase
import Nimble

class SignUpTests: BaseUITests {

  // MARK: - Properties
  private let userPassword = Faker().lorem.characters(amount: 6)

  // MARK: - Init
  override func beforeEach() {
    backToRoot()
    tapButton("Sign Up")
  }

  // MARK: - Tests
  func testRequiredEmailOrPassword() {
    tapButton("Sign Up")
    expectToSee("An email address must be provided.")
    tapButton("OK")
    fillIn("Email TextField", with: Faker().internet.email())
    tapButton("Sign Up")
    expectToSee("The password must be 6 characters long or more.")
    tapButton("OK")
  }

  func testPasswordLimit() {
    fillIn("Email TextField", with: Faker().internet.email())
    fillIn("Password TextField", with: Faker().lorem.characters(amount: 5))
    tapButton("Sign Up")
    expectToSee("The password must be 6 characters long or more.")
    tapButton("OK")
  }

  func testEmailFormat() {
    fillIn("Email TextField", with: Faker().lorem.word())
    fillIn("Password TextField", with: Faker().lorem.characters(amount: 6))
    tapButton("Sign Up")
    expectToSee("The email address is badly formatted.")
    tapButton("OK")
  }

  func testSignUserUpUnsuccessfully() {
    let email = TestConstants.registeredEmail
    createUser(withEmail: email, password: userPassword)

    fillIn("Email TextField", with: email)
    fillIn("Password TextField", with: Faker().lorem.characters(amount: 6))
    tapButton("Sign Up")
    expectToSee("The email address is already in use by another account.")
    tapButton("OK")

    deleteUser(withEmail: email, password: self.userPassword)
  }

  func testSignUserUpSuccessfully() {
    let email = TestConstants.unRegisteredEmail

    fillIn("Email TextField", with: email)
    fillIn("Password TextField", with: userPassword)
    tapButton("Sign Up")
    // MARK: ToDo: Expect go to Home Page

    deleteUser(withEmail: email, password: userPassword)
  }
}

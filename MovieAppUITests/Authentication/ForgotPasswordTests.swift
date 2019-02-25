//
//  ForgotPasswordTests.swift
//  MovieAppUITests
//
//  Created by Macintosh on 2/25/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import KIF
import Fakery
import Firebase
import Nimble

class ForgotPasswordTests: BaseUITests {

  // MARK: - Properties
  private let userPassword = Faker().lorem.characters(amount: 6)

  override func beforeEach() {
    backToRoot()
    tapButton("Sign In")
    tapButton("forgot your password?")
  }

  // MARK: - Tests
  func testRequiredEmail() {
    tapButton("Submit")
    expectToSee("An email address must be provided.")
    tapButton("OK")
  }

  func testSubmitWithBadlyEmail() {
    fillIn("Email TextField", with: Faker().lorem.word())
    tapButton("Submit")
    expectToSee("Error")
    expectToSee("The email address is badly formatted.")
    tapButton("OK")
  }

  func testSubmitWithIncorrectEmail() {
    fillIn("Email TextField", with: TestConstants.unRegisteredEmail)
    tapButton("Submit")
    expectToSee("Incorrect Email")
    expectToSee("The email you entered doesn't appear to belong to an account. Please check your email address and try again.")
    tapButton("OK")
  }

  func testSubmitSuccessfully() {
    let email = TestConstants.registeredEmail
    createUser(withEmail: email, password: userPassword)

    fillIn("Email TextField", with: TestConstants.registeredEmail)
    tapButton("Submit")
    expectToSee("Forgot Password")
    expectToSee("Your password reset email was sent. Please check your inbox!")
    tapButton("OK")

    deleteUser(withEmail: email, password: userPassword)
  }

  func testCancelButton() {
    tapButton("Cancel")
    expectToSeeSignInScreen()
  }
}



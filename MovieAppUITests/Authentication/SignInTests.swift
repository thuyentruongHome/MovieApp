//
//  SignInTests.swift
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

class SignInTests: BaseUITests {

  // MARK: - Properties
  private let userPassword = Faker().lorem.characters(amount: 6)

  override func beforeEach() {
    gotoLandingScreen()
    tapButton("Sign In")
  }

  // MARK: - Tests
  func testRequiredEmailOrPassword() {
    tapButton("Sign In")
    expectToSee("An email address must be provided.")
    tapButton("OK")
    fillIn("Email TextField", with: Faker().internet.email())
    tapButton("Sign In")
    expectToSee("A password must be provided.")
    tapButton("OK")
  }

  func testSignInWithIncorrectEmail() {
    let email = TestConstants.unRegisteredEmail

    fillIn("Email TextField", with: email)
    fillIn("Password TextField", with: Faker().lorem.characters(amount: 6))
    tapButton("Sign In")
    expectToSee("Incorrect Email")
    expectToSee("The email you entered doesn't appear to belong to an account. Please check your email address and try again.")
    tapButton("OK")
  }

  func testSignInWithIncorrectPassword() {
    let email = TestConstants.registeredEmail
    createUser(withEmail: email, password: userPassword)

    fillIn("Email TextField", with: email)
    fillIn("Password TextField", with: "incorrect-\(userPassword)")
    tapButton("Sign In")
    expectToSee("Incorrect Password")
    expectToSee("The password you entered is incorrect. Please try again.")
    tapButton("OK")

    deleteUser(withEmail: email, password: userPassword)
  }

  func testSignUserInSuccessfully() {
    let email = TestConstants.registeredEmail
    createUser(withEmail: email, password: userPassword)

    fillIn("Email TextField", with: email)
    fillIn("Password TextField", with: userPassword)
    tapButton("Sign In")
    expectToSeeMainScreen()
    deleteUser(withEmail: email, password: userPassword)
  }

  func testCancelButton() {
    tapButton("Cancel")
    expectToSeeLandingScreen()
  }

  func testSwitchToSignUpScreen() {
    tapButton("Sign Up")
    expectToSeeSignUpScreen()
  }

  func testForgotPasswordButton() {
    tapButton("forgot your password?")
    expectToSeeForgotPasswordScreen()
  }
}

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
    expectToSee("Cancel", "Sign Up", "Sign In")
  }

  func expectToSeeSignInScreen() {
    expectToSee("Email TextField", "Password TextField")
    expectToSee("Cancel", "Sign In", "Sign Up")
    expectToSee("forgot your password?")
  }

  func expectToSeeForgotPasswordScreen() {
    expectToSee("Please enter your email so we can send you link to reset password")
    expectToSee("Email TextField")
    expectToSee("Cancel", "Submit")
  }
}

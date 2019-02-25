//
//  UserServiceSpec.swift
//  MovieAppTests
//
//  Created by Macintosh on 2/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import Firebase
import Quick
import Nimble
import Fakery

@testable import MovieApp

class UserServiceSpec: BaseTests {
  override func spec() {
    super.spec()

    var email: String!
    var password: String!

    describe(".signUp") {
      beforeEach {
        email = Faker().internet.email()
        password = Faker().lorem.characters(amount: 6)
      }

      context("with invalid credential") {
        var errorMessage: String!

        afterEach {
          expect {
            try API.UserService.signUp(withEmail: email, password: password, completionHandler: { (_) in })
          }.to(throwError { (error: NSError) in
            expect(error.localizedDescription) == errorMessage
          })
        }

        context("email is empty") {
          beforeEach { email = "" }

          it("throws required email error") {
            errorMessage = "An email address must be provided."
          }
        }

        context("password is empty") {
          beforeEach { password = "" }

          it("throws required password error") {
            errorMessage = "The password must be 6 characters long or more."
          }
        }
      }

      context("email is already registered") {
        beforeEach {
          email = TestConstants.registeredEmail
          self.createUser(withEmail: email, password: password)
        }

        afterEach {
          self.deleteUser(withEmail: email, password: password)
        }

        it("returns error") {
          let expectation = XCTestExpectation(description: "Sign Firebase user up")
          try! API.UserService.signUp(withEmail: email, password: password, completionHandler: { (error) in
            expect(error).toNot(beNil())
            expect(error?.localizedDescription).to(equal("The email address is already in use by another account."))
            expectation.fulfill()
          })
          self.wait(for: [expectation], timeout: 10.0)
        }
      }

      context("sign user up successfully") {
        beforeEach {
          email = TestConstants.unRegisteredEmail
        }

        afterEach {
          self.deleteUser(withEmail: email, password: password)
        }

        it("returns successfully") {
          let expectation = XCTestExpectation(description: "Sign Firebase user up")
          try! API.UserService.signUp(withEmail: email, password: password, completionHandler: { (error) in
            expect(error).to(beNil())
            expectation.fulfill()
          })
          self.wait(for: [expectation], timeout: 50.0)
        }
      }
    }
  }
}

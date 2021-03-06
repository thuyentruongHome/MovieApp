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

    beforeEach {
      email = Faker().internet.email()
      password = Faker().lorem.characters(amount: 6)
    }

    describe(".signUp") {
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

    describe(".signIn") {
      context("with invalid credential") {
        var errorMessage: String!

        afterEach {
          expect {
            try API.UserService.signIn(withEmail: email, password: password, completionHandler: { (_) in })
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
            errorMessage = "A password must be provided."
          }
        }
      }

      context("incorrect email") {
        beforeEach {
          email = TestConstants.unRegisteredEmail
        }

        it("returns user_not_found error") {
          let expectation = XCTestExpectation(description: "Sign Firebase user in")
          try! API.UserService.signIn(withEmail: email, password: password, completionHandler: { (error) in
            expect(error).toNot(beNil())
            expect(error?._code).to(equal(AuthErrorCode.userNotFound.rawValue))
            expect(error?.localizedDescription).to(equal("There is no user record corresponding to this identifier. The user may have been deleted."))
            expectation.fulfill()
          })
          self.wait(for: [expectation], timeout: 10.0)
        }
      }

      context("incorrect password") {
        beforeEach {
          email = TestConstants.registeredEmail
          self.createUser(withEmail: email, password: password)
        }

        afterEach {
          self.deleteUser(withEmail: email, password: password)
        }

        it("returns wrong_password error") {
          let expectation = XCTestExpectation(description: "Sign Firebase user in")
          try! API.UserService.signIn(withEmail: email, password: "incorrect-\(password!)", completionHandler: { (error) in
            expect(error).toNot(beNil())
            expect(error?._code).to(equal(AuthErrorCode.wrongPassword.rawValue))
            expect(error?.localizedDescription).to(equal("The password is invalid or the user does not have a password."))
            expectation.fulfill()
          })
          self.wait(for: [expectation], timeout: 10.0)
        }
      }

      context("sign user in successfully") {
        beforeEach {
          email = TestConstants.registeredEmail
          self.createUser(withEmail: email, password: password)
        }

        afterEach {
          self.deleteUser(withEmail: email, password: password)
        }

        it("returns successfully") {
          let expectation = XCTestExpectation(description: "Sign Firebase user in")
          try! API.UserService.signIn(withEmail: email, password: password, completionHandler: { (error) in
            expect(error).to(beNil())
            expectation.fulfill()
          })
          self.wait(for: [expectation], timeout: 50.0)
        }
      }
    }

    describe(".submitForgotPassword") {
      context("with invalid credential") {
        context("email is empty") {
          beforeEach { email = "" }

          it("throws required email error") {
            expect {
              try API.UserService.submitForgotPassword(withEmail: email, completionHandler: { (_) in })
            }.to(throwError { (error: NSError) in
              expect(error.localizedDescription) == "An email address must be provided."
            })
          }
        }

        context("email is badly formatted") {
          beforeEach { email = Faker().lorem.word() }

          it("throws badly formatted email error") {
            let expectation = XCTestExpectation(description: "Send Firebase password reset")
            try! API.UserService.submitForgotPassword(withEmail: email, completionHandler: { (error) in
              expect(error).toNot(beNil())
              expect(error?._code).to(equal(AuthErrorCode.invalidEmail.rawValue))
              expect(error?.localizedDescription).to(equal("The email address is badly formatted."))
              expectation.fulfill()
            })
            self.wait(for: [expectation], timeout: 10.0)
          }
        }
      }

      context("incorrect email") {
        beforeEach {
          email = TestConstants.unRegisteredEmail
        }

        it("returns user_not_found error") {
          let expectation = XCTestExpectation(description: "Send Firebase password reset")
          try! API.UserService.submitForgotPassword(withEmail: email, completionHandler: { (error) in
            expect(error).toNot(beNil())
            expect(error?._code).to(equal(AuthErrorCode.userNotFound.rawValue))
            expect(error?.localizedDescription).to(equal("There is no user record corresponding to this identifier. The user may have been deleted."))
            expectation.fulfill()
          })
          self.wait(for: [expectation], timeout: 10.0)
        }
      }

      context("sends password reset successfully") {
        beforeEach {
          email = TestConstants.registeredEmail
          self.createUser(withEmail: email, password: password)
        }

        afterEach {
          self.deleteUser(withEmail: email, password: password)
        }

        it("returns successfully") {
          let expectation = XCTestExpectation(description: "Send Firebase password reset")
          try! API.UserService.submitForgotPassword(withEmail: email, completionHandler: { (error) in
            expect(error).to(beNil())
            expectation.fulfill()
          })
          self.wait(for: [expectation], timeout: 50.0)
        }
      }
    }
  }
}

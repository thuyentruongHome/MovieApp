//
//  FirebaseAuthTest.swift
//  ExtensionTests
//
//  Created by Macintosh on 2/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import Firebase
import XCTest
import Nimble

extension XCTestCase {

  public func createUser(withEmail email: String, password: String) {
    let expectation = XCTestExpectation(description: "Create Firebase user")
    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
      expect(error).to(beNil())
      expect(result?.user).toNot(beNil())
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 10.0)
  }

  public func deleteUser(withEmail email: String, password: String) {
    let expectation = XCTestExpectation(description: "Delete Firebase user")
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      expect(error).to(beNil())
      result?.user.delete(completion: { (error) in
        expect(error).to(beNil())
        expectation.fulfill()
      })
    }
    wait(for: [expectation], timeout: 10.0)
  }
}

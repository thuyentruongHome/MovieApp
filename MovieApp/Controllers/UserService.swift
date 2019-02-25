//
//  UserService.swift
//  MovieApp
//
//  Created by Macintosh on 2/15/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit
import Firebase

extension API {
  class UserService {

    class func signUp(withEmail email: String, password: String, completionHandler: @escaping ErrorHandler) throws {
      // Validation
      try validateEmail(email)
      try validatePassword(password)

      Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
        if let error = error {
          print("Failed to sign user up with Firebase: ", error.localizedDescription)
          completionHandler(error)
        } else {
          completionHandler(nil)
        }
      }
    }

    class func signIn(withEmail email: String, password: String, completionHandler: @escaping ErrorHandler) throws {
      // Validation
      try validateEmail(email)
      try validateSignInPassword(password)

      Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
        if let error = error {
          print("Failed to sign user in with Firebase: ", error.localizedDescription)
          completionHandler(error)
        } else {
          completionHandler(nil)
        }
      }
    }

    class func submitForgotPassword(withEmail email: String, completionHandler: @escaping ErrorHandler) throws {
      try validateEmail(email)
      Auth.auth().sendPasswordReset(withEmail: email) { (error) in
        if let error = error {
          completionHandler(error)
        } else {
          completionHandler(nil)
        }
        return
      }
    }

    private class func validateEmail(_ email: String) throws {
      if email.count == 0 {
        throw NSError(domain: hostDomain, code: hostErrorCode, userInfo: [NSLocalizedDescriptionKey: Constants.ErrorMessage.requiredEmail])
      }
    }

    private class func validatePassword(_ password: String) throws {
      if password.count < Constants.Policy.minimumPasswordLength {
        throw NSError(domain: hostDomain, code: hostErrorCode, userInfo: [NSLocalizedDescriptionKey: Constants.ErrorMessage.passwordLimitation])
      }
    }

    private class func validateSignInPassword(_ password: String) throws {
      if password.count == 0 {
        throw NSError(domain: hostDomain, code: hostErrorCode, userInfo: [NSLocalizedDescriptionKey: Constants.ErrorMessage.requiredPassword])
      }
    }
  }
}


//
//  ForgotPasswordViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/25/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  // MARK: - Handlers
  @IBAction func submitForgotPassword(_ sender: Any) {
    activityIndicator.startAnimating()
    let email = emailTextField.text!

    do {
      try API.UserService.submitForgotPassword(withEmail: email) { [weak self] (error) in
        guard let self = self else { return }
        self.activityIndicator.stopAnimating()
        if let error = error {
          guard let authErrorCode = AuthErrorCode(rawValue: error._code) else { return }
          switch authErrorCode {
          case .userNotFound:
            self.showInformedAlert(withTitle: Constants.TitleAlert.incorrectEmail, message: Constants.ErrorMessage.incorrectEmail)
          default:
            self.showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
          }
        } else {
          self.showInformedAlert(withTitle: Constants.TitleAlert.forgotPassword, message: Constants.Message.sentForgotPasswordMail)
          self.navigationController?.popViewController(animated: true)
        }
      }
    } catch let error {
      self.activityIndicator.stopAnimating()
      showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
    }
  }

  @IBAction func cancel(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}

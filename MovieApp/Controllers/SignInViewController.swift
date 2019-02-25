//
//  SignInViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/25/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  // MARK: - Init
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Handlers
  @IBAction func signUserIn(_ sender: Any) {
    activityIndicator.startAnimating()
    let email = emailTextField.text!
    let password = passwordTextField.text!

    do {
      try API.UserService.signIn(withEmail: email, password: password) { [weak self] (error) in
        guard let self = self else { return }
        self.activityIndicator.stopAnimating()

        if let error = error {
          guard let authErrorCode = AuthErrorCode(rawValue: error._code) else { return }
          switch authErrorCode {
          case .userNotFound:
            self.showErrorAlertView(withTitle: Constants.TitleAlert.incorrectEmail, message: Constants.ErrorMessage.incorrectEmail)
          case .wrongPassword:
            self.showErrorAlertView(withTitle: Constants.TitleAlert.incorrectPassword, message: Constants.ErrorMessage.incorrectPassword)
          default:
            self.showErrorAlertView(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
          }
        } else {
          // TODO: Move to Main Screen
        }
      }
    } catch let error {
      self.activityIndicator.stopAnimating()
      showErrorAlertView(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
    }
  }

  @IBAction func cancel(_ sender: Any) {
    navigationController?.popToRootViewController(animated: true)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}

extension SignInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}

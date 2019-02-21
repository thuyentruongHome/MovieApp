//
//  SignUpViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/15/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  // MARK: - Init
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Handlers
  @IBAction func signUserUp(_ sender: Any) {
    activityIndicator.startAnimating()
    let email = emailTextField.text!
    let password = passwordTextField.text!

    do {
      try API.UserService.signUp(withEmail: email, password: password) { (error) in
        self.activityIndicator.stopAnimating()

        if let error = error {
          self.showErrorAlertView(withTitle: Constants.errorTitleAlert, message: error.localizedDescription)
        } else {
          // TODO: Move to Main Screen
        }
      }
    } catch let error {
      self.activityIndicator.stopAnimating()
      showErrorAlertView(withTitle: Constants.errorTitleAlert, message: error.localizedDescription)
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}

extension SignUpViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}

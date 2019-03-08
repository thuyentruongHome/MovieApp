//
//  SignUpViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/15/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, KeyboardObserver {
  var container: UIScrollView {
    return scrollView
  }

  // MARK: - Properties
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var scrollView: UIScrollView!

  // MARK: - Init
  override func viewDidLoad() {
    super.viewDidLoad()
    registerForKeyboardNotifications()
  }

  // MARK: - Handlers
  @IBAction func signUserUp(_ sender: Any) {
    activityIndicator.startAnimating()
    let email = emailTextField.text!
    let password = passwordTextField.text!

    do {
      try API.UserService.signUp(withEmail: email, password: password) { [weak self] (error) in
        guard let self = self else { return }
        self.activityIndicator.stopAnimating()

        if let error = error {
          self.showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
        } else {
          self.gotoMainScreen()
        }
      }
    } catch let error {
      self.activityIndicator.stopAnimating()
      showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
    }
  }

  @IBAction func cancel(_ sender: Any) {
    navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func tapPiece(_ gestureRecognizer: UITapGestureRecognizer) {
    guard gestureRecognizer.view != nil else { return }
    if gestureRecognizer.state == .ended {
      view.endEditing(true)
    }
  }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}

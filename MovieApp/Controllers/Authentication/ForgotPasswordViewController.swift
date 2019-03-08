//
//  ForgotPasswordViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/25/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController, KeyboardObserver {
  var container: UIScrollView {
    return scrollView
  }

  // MARK: - Properties
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var scrollView: UIScrollView!

  // MARK: - Init
  override func viewDidLoad() {
    super.viewDidLoad()
    registerForKeyboardNotifications()
  }

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

  @IBAction func tapPiece(_ gestureRecognizer: UITapGestureRecognizer) {
    guard gestureRecognizer.view != nil else { return }
    if gestureRecognizer.state == .ended {
      view.endEditing(true)
    }
  }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}

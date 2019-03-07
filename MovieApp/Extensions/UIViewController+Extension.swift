//
//  UIViewController+Extension.swift
//  MovieApp
//
//  Created by Macintosh on 2/15/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

extension UIViewController {

  // MARK: - Alert
  func showInformedAlert(withTitle title: String, message: String) {
    let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertView, animated: true, completion: nil)
  }

  // MARK: - Flow Navigation
  func gotoMainScreen() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let initialMainVC = storyboard.instantiateInitialViewController() {
      present(initialMainVC, animated: true, completion: nil)
    }
  }

  func gotoLandingScreen() {
    let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
    if let initialMainVC = storyboard.instantiateInitialViewController() {
      present(initialMainVC, animated: true, completion: nil)
    }
  }

  func gotoSignInScreen() {
    let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
    guard let navigationVC = storyboard.instantiateInitialViewController() as? UINavigationController,
      let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInViewController else { return }
    navigationVC.pushViewController(signInVC, animated: true)
    present(navigationVC, animated: true, completion: nil)
  }
}

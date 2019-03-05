//
//  HamburgerMenuVC.swift
//  MovieApp
//
//  Created by Macintosh on 2/26/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class HamburgerMenuVC: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var signOutBox: UIView!
  @IBOutlet weak var signInBox: UIView!
  @IBOutlet weak var currentUserEmail: UILabel!

  // MARK: - Init
  override func viewDidLoad() {
    super.viewDidLoad()

    if API.UserService.isLoggedIn() {
      currentUserEmail.text = API.UserService.currentUser()?.email
      signOutBox.isHidden = false
      signInBox.isHidden = true
    } else {
      signOutBox.isHidden = true
      signInBox.isHidden = false
    }
  }

  // MARK: - Handlers
  @IBAction func signUserOut(_ sender: Any) {
    do {
      try API.UserService.signOut()
      gotoLandingScreen()
    } catch let error {
      showInformedAlert(withTitle: Constants.TitleAlert.error, message: error.localizedDescription)
    }
  }

  @IBAction func moveToSignIn(_ sender: Any) {
    gotoSignInScreen()
  }
}

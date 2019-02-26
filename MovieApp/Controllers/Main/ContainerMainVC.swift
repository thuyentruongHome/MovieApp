//
//  ContainerMainVC.swift
//  MovieApp
//
//  Created by Macintosh on 2/26/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class ContainerMainVC: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var leadingAnchorMenu: NSLayoutConstraint!
  @IBOutlet weak var menuContainerView: UIView!

  // MARK: - Handlers
  @IBAction func toggleHamburgerMenu(_ sender: Any) {
    guard let hamburgerMenuBtn = sender as? UIButton else { return }
    hamburgerMenuBtn.isSelected = !hamburgerMenuBtn.isSelected
    let leftAnchorConstant = hamburgerMenuBtn.isSelected ? 0 : -self.menuContainerView.frame.width

    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
      self.leadingAnchorMenu.constant = leftAnchorConstant
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
}

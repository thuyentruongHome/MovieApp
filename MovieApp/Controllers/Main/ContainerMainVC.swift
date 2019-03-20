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
  @IBOutlet weak var topLogo: UIButton!
  @IBOutlet weak var movieDetailNavigation: UIView!
  @IBOutlet weak var selectedMovieTitle: UILabel!
  private var splitNavigationController: UINavigationController?

  override func viewDidLoad() {
    super.viewDidLoad()
    observeForMovieDetailNavigation()
  }

// Gets needed Embed Container Controllers
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? SplitViewController {
      splitNavigationController = viewController.viewControllers[0] as? UINavigationController
    }
  }

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

  @IBAction func backToMasterView(_ sender: Any) {
    splitNavigationController?.popToRootViewController(animated: true)
    movieDetailNavigation.isHidden = true
    topLogo.isHidden = false
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}

// MARK: - Setup Movie Detail - Title Navigation
extension ContainerMainVC {
  func observeForMovieDetailNavigation() {
    NotificationCenter.default.addObserver(self, selector: #selector(selectedMovie(_:)), name: .DidSelectMovie, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(hiddenMovieDetailNavigation), name: .HiddenMovieDetailNavigation, object: nil)
  }
  
  @objc private func selectedMovie(_ notification: Notification) {
    if let movie = notification.object as? Movie {
      movieDetailNavigation.isHidden = false
      selectedMovieTitle.text = movie.title
      topLogo.isHidden = true
    }
  }
  
  @objc private func hiddenMovieDetailNavigation() {
    movieDetailNavigation.isHidden = true
    topLogo.isHidden = false
  }
}

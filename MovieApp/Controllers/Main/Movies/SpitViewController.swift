//
//  SpitViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let leftNavController = viewControllers.first as? UINavigationController,
      let masterViewController = leftNavController.topViewController as? MasterViewController,
      let detailViewController = viewControllers.last as? MovieDetailViewController
      else { fatalError() }

    masterViewController.delegate = detailViewController
    delegate = self
    preferredDisplayMode = .allVisible
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    configSplitColumnWidth()
  }

  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    guard let leftNavController = viewControllers.first as? UINavigationController,
      let masterViewController = leftNavController.topViewController as? MasterViewController else { return true }
    return !masterViewController.isMovieSelected
  }
  
  static func isAllVisible() -> Bool {
    return UIScreen.main.traitCollection.horizontalSizeClass == .regular
  }
  
  private func configSplitColumnWidth() {
    if UIScreen.main.traitCollection.verticalSizeClass == .regular {
      maximumPrimaryColumnWidth = UIScreen.main.bounds.width / 2
      minimumPrimaryColumnWidth = UIScreen.main.bounds.width / 2
    } else {
      maximumPrimaryColumnWidth = UIScreen.main.bounds.width * 2 / 5
      minimumPrimaryColumnWidth = UIScreen.main.bounds.width * 3 / 5
    }
  }
}

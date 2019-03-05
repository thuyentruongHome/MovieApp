//
//  SpitViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let leftNavController = viewControllers.first as? UINavigationController,
      let masterViewController = leftNavController.topViewController as? MasterViewController,
      let detailViewController = viewControllers.last as? MovieDetailViewController
      else { fatalError() }

    masterViewController.delegate = detailViewController
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    maximumPrimaryColumnWidth = UIScreen.main.bounds.width / 2
    minimumPrimaryColumnWidth = UIScreen.main.bounds.width / 2
  }
}

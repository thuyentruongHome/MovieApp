//
//  SpitViewController.swift
//  MovieApp
//
//  Created by Macintosh on 2/28/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    maximumPrimaryColumnWidth = UIScreen.main.bounds.width / 2
    minimumPrimaryColumnWidth = UIScreen.main.bounds.width / 2
  }
}

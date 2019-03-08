//
//  UIView+Extension.swift
//  MovieApp
//
//  Created by Macintosh on 3/8/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

extension UIView {
  func scrollToTop() {
    if let view = self as? UITableView {
      view.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    if let view = self as? UIScrollView {
      view.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
  }
}

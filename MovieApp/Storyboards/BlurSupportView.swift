//
//  BlurSupportView.swift
//  MovieApp
//
//  Created by East Agile on 3/19/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

class BlurSupportView: UIView {
  func hidden() {
    isHidden = true
  }
  
  func invisible() {
    alpha = 0.1
    isHidden = false
  }
  
  func visible() {
    alpha = 0.5
    isHidden = false
  }
}


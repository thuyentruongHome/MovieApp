//
//  CommonSteps.swift
//  MovieAppUITests
//
//  Created by Macintosh on 2/19/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import KIF

extension KIFTestCase {

  // MARK: - Actions
  func tapButton(_ buttonName: String) {
    tester().tapView(withAccessibilityLabel: buttonName)
  }

  func fillIn(_ inputField: String, with text: String) {
    tester().enterText(text, intoViewWithAccessibilityLabel: inputField)
  }

  // MARK: - Expectation
  func expectToSee(_ elements: String...) {
    for element in elements {
      tester().waitForView(withAccessibilityLabel: element)
    }
  }

  // MARK: - Navigation
  func gotoLandingScreen() {
    let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
    UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
    tester().waitForAnimationsToFinish()
  }
}

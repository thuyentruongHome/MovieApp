//
//  BaseTests.swift
//  MovieAppTests
//
//  Created by Macintosh on 2/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import Firebase
import Quick
import Nimble

class BaseTests: QuickSpec {
  override func spec() {
    super.spec()

    beforeSuite {
      if FirebaseApp.app() == nil { FirebaseApp.configure() }
    }
  }
}

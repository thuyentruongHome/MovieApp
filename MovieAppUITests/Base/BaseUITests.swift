//
//  BaseUITests.swift
//  MovieAppUITests
//
//  Created by Macintosh on 2/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import KIF
import Firebase

class BaseUITests: KIFTestCase {

  override func beforeAll() {
    if FirebaseApp.app() == nil { FirebaseApp.configure() }
  }
}

//
//  TestConstants.swift
//  ExtensionTests
//
//  Created by Macintosh on 2/21/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import Foundation
import Fakery

struct TestConstants {
  public static let registeredEmail = "registered-movieapp@mail.com"
  public static let unRegisteredEmail = "unregistered-movieapp@mail.com"
  public static let userPassword = Faker().lorem.characters(amount: 6)
}

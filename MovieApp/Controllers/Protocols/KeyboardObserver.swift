//
//  KeyboardObserver.swift
//  MovieApp
//
//  Created by Macintosh on 3/8/19.
//  Copyright © 2019 thuyentruong. All rights reserved.
//

import UIKit

protocol KeyboardObserver {
  func registerForKeyboardNotifications()
  var container: UIScrollView { get }
}

extension KeyboardObserver {
  func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: keyboardWillBeShow(notification:))
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: keyboardWillBeHide(notification:))
  }

  private func keyboardWillBeShow(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
    container.contentInset = contentInset
    container.scrollIndicatorInsets = contentInset
  }

  private func keyboardWillBeHide(notification: Notification) {
    let contentInset = UIEdgeInsets.zero
    container.contentInset = contentInset
    container.scrollIndicatorInsets = contentInset
  }
}

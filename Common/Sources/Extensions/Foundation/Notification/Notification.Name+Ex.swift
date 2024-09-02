//
//  Notification.Name+Ex.swift
//  Common
//
//  Created by 쩡화니 on 8/29/24.
//

import Foundation

public extension Notification.Name {
  static let tokenExpired = Notification.Name("tokenExpiredNotification")
  static let refreshTokenExpired = Notification.Name("refreshTokenExpired")
  static let networkUnstable = Notification.Name("networkUnstable")
  static let networkStable = Notification.Name("networkStable")
}

@objc public extension NSNotification {
  static let tokenExpired = Notification.Name.tokenExpired
  static let refreshTokenExpired = Notification.Name.refreshTokenExpired
  static let networkUnstable = Notification.Name.networkUnstable
  static let networkStable = Notification.Name.networkStable
}

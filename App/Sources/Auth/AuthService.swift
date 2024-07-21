//
//  AuthService.swift
//  App
//
//  Created by 쩡화니 on 7/21/24.
//

import Foundation

protocol AuthServiceType: AnyObject {
  func googleSignIn()
  func googleSignOut()
  func appleSignIn()
  func appleSignOut()
}

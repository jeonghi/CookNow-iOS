//
//  AppDelegate.swift
//  App
//
//  Created by 쩡화니 on 6/1/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    FirebaseApp.configure()
    sleep(1)

    return true
  }
}

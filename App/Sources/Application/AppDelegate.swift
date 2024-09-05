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
    
    AppAppearance.configure()
    FirebaseApp.configure()
    sleep(1)
    
    return true
  }
  
  func application(
    _ application: UIApplication,
    supportedInterfaceOrientationsFor window: UIWindow?
  ) -> UIInterfaceOrientationMask {
    
    // 세로방향 고정
    return UIInterfaceOrientationMask.portrait
  }
}

extension AppDelegate {
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
}

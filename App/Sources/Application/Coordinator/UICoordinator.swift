//
//  UICoordinator.swift
//  App
//
//  Created by 쩡화니 on 8/18/24.
//

import SwiftUI
import Auth

final class UICoordinator: ObservableObject {
  
  // MARK: Dependencies
  @ObservedObject var tokenManager: TokenManager = .shared
  
  // MARK: Properties
  
  @Published var selectedTab: MainTabType = .IngredientsBox
  
  var isLoggedIn: Bool {
    if let token = tokenManager.token,
       !token.isAccessTokenExpired {
      return true
    }
    return false
  }
  
  init() {}
}

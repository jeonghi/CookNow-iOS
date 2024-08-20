//
//  UICoordinator.swift
//  App
//
//  Created by 쩡화니 on 8/18/24.
//

import SwiftUI
import Auth
import Dependencies

final class UICoordinator: ObservableObject {
  
  static let shared: UICoordinator = .init()
  
  // MARK: Dependencies
  @ObservedObject var tokenManager: TokenManager = .shared
  
  var isLoggedIn: Bool {
    if tokenManager.token != nil {
      return true
    }
    return false
  }
  
  private init() {}
}

struct UICoordinatorDependencyKey: DependencyKey {
  static let liveValue: UICoordinator = UICoordinator.shared
}

extension DependencyValues {
  var coordinator: UICoordinator {
    get { self[UICoordinatorDependencyKey.self] }
    set { self[UICoordinatorDependencyKey.self] = newValue }
  }
}

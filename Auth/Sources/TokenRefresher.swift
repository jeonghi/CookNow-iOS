//
//  TokenRefresher.swift
//  Auth
//
//  Created by 쩡화니 on 8/15/24.
//

import Foundation
import Common
import UIKit


public final class TokenRefresher: ObservableObject {
  
  // MARK: Singleton
  public static let shared = TokenRefresher()
  
  // MARK: Dependencies
  private let tokenManager: TokenManagerType = TokenManager.shared
  
  // MARK: Constants
  private let coolTime: TimeInterval = 4.hour // 4시간
  
  // MARK: Variables
  private var updatedAt: Date? = nil

  
  // MARK: Constructor
  private init() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.didBecomeActiveForRefreshToken), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  
  // MARK: Destructor
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func didBecomeActiveForRefreshToken(_ notification: Notification) {
      if (shouldRefreshToken()) {
         
      }
  }
  
  /// 토큰 갱신해야하는지 여부 판단
  private func shouldRefreshToken() -> Bool {
    
    /// 현재 타임 스탬프
    let currentTimeStamp = Date().timeIntervalSince1970
    
    if let updatedAt {
      if (abs(updatedAt.timeIntervalSince1970 - currentTimeStamp) < coolTime) {
        return false
      }
    }
    
    return true
  }
  
  /// 액세스 토큰 유효성 검증 (네트워크 검증)
  private func checkAccessToken(completion: @escaping ((any Error)?) -> Void) {
    
  }
}

extension TokenRefresher {
  
}

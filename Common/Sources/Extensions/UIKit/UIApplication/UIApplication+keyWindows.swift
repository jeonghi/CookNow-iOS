//
//  UIApplication+keyWindows.swift
//  Common
//
//  Created by 쩡화니 on 8/12/24.
//

import UIKit

public extension UIApplication {
  static var keyWindows: [UIWindow] {
    // iOS 13 이상에서는 Scene을 사용하여 윈도우를 가져옵니다.
    if #available(iOS 13.0, *) {
      return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .filter { $0.isKeyWindow }
    } else {
      // iOS 13 미만에서는 기존 방법 사용
      return UIApplication.shared.windows.filter { $0.isKeyWindow }
    }
  }
  
  static var keyWindow: UIWindow? {
    keyWindows.first
  }
  
  static var bottomSafeAreaInsets: CGFloat {
    return keyWindow?.safeAreaInsets.bottom ?? 0
  }
}

//
//  ButtonSize.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/3/24.
//

import Foundation

/// 버튼 사이즈
public struct ButtonSize {
  let width: CGFloat
  let height: CGFloat
  
  public init(width: CGFloat, height: CGFloat) {
    self.width = width
    self.height = height
  }
  
  public init(size: CGFloat) {
    self.width = size
    self.height = size
  }
}

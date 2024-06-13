//
//  StateButtonConfiguration.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/4/24.
//

import Foundation

public struct StateButtonConfiguration {
  let fontConfig: FontAsset?
  let foreground: ColorAsset
  let background: ColorAsset
  let border: ColorAsset
  
  public init(
    fontConfig: FontAsset? = nil,
    foreground: ColorAsset,
    background: ColorAsset,
    border: ColorAsset
  ) {
    self.fontConfig = fontConfig
    self.foreground = foreground
    self.background = background
    self.border = border
  }
}

extension StateButtonConfiguration {
  static let `default` = StateButtonConfiguration(
    foreground: .black,
    background: .white,
    border: .clear
  )
}

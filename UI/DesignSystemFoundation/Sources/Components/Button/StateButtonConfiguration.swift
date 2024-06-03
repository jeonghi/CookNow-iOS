//
//  StateButtonConfiguration.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/4/24.
//

import Foundation

public struct StateButtonConfiguration {
  let fontConfig: FontAsset
  let foreground: ColorAsset
  let background: ColorAsset
  
  public init(
    fontConfig: FontAsset,
    foreground: ColorAsset,
    background: ColorAsset
  ) {
    self.fontConfig = fontConfig
    self.foreground = foreground
    self.background = background
  }
}

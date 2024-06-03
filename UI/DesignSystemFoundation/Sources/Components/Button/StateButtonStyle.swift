//
//  StateButtonStyle.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/3/24.
//

import SwiftUI

public struct StateButtonStyle {
  
  @Environment(\.isEnabled) var isEnabled: Bool
  
  var buttonSize: ButtonSize
  var configurations: [ButtonState: StateButtonConfiguration] = [:]
  
  public init(buttonSize: ButtonSize) {
    self.buttonSize = buttonSize
  }
  
  public func style(
    _ config: StateButtonConfiguration,
    for state: ButtonState
  ) -> StateButtonStyle {
    var newStyle = self
    newStyle.configurations[state] = config
    return newStyle
  }
}

extension StateButtonStyle: ButtonStyle {
  
  public func makeBody(configuration: Configuration) -> some View {
    
    let currentState: ButtonState = {
      if(isEnabled) {
        if(configuration.isPressed) {
          return .pressed
        }else {
          return .normal
        }
      } else {
        return .disabled
      }
    }()
    
    let config = configurations[currentState]
    return configuration.label
      .kerning(0.5)
      .font(config?.fontConfig.toFont())
      .padding(10)
      .foregroundStyle(config?.foreground.toColor() ?? ColorAsset.black.toColor())
      .frame(width: buttonSize.width, height: buttonSize.height)
      .background(config?.background.toColor() ?? ColorAsset.white.toColor())
      .clipShape(RoundedRectangle(cornerRadius: 6))
  }
}

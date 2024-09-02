//
//  StateButtonStyle.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/3/24.
//

import SwiftUI

public extension View {
  func isProgressing(_ isProgressing: Bool) -> some View {
    self
      .environment(\.isProgressing, isProgressing)
  }
}

private struct ProgressKey: EnvironmentKey {
  public static let defaultValue: Bool = false
}

private extension EnvironmentValues {
    var isProgressing: Bool {
        get { self[ProgressKey.self] }
        set { self[ProgressKey.self] = newValue }
    }
}

public struct StateButtonStyle {
  
  @Environment(\.isEnabled) var isEnabled: Bool
  @Environment(\.isProgressing) var isProgressing: Bool
  
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
        // 누른 상태
        if(configuration.isPressed) {
          return .pressed
        }else { // 일반 상태
          return .normal
        }
      } else { // 비활성화 상태
        if(isProgressing) {
          return .progress
        }
        return .disabled
      }
    }()
    
    let config: StateButtonConfiguration = configurations[currentState] ?? .default
    
    return ZStack {
      RoundedRectangle(cornerRadius: 6)
        .fill(config.background.toColor())
        configuration.label
      }
      .kerning(-0.6)
      .font(config.fontConfig?.toFont())
      .foregroundStyle(
        currentState == .progress ? Color.asset(.clear) : config.foreground.toColor()
      )
      .frame(
        height: buttonSize.height
      )
      .frame(maxWidth: buttonSize.width)
      .overlay(
        ZStack {
          RoundedRectangle(cornerRadius: 6)
            .stroke(
              config.border.toColor(),
              lineWidth: 1
            )
          if(currentState == .progress) {
            ProgressView()
              .tint(config.foreground.toColor())
          }
        }
      )
  }
}

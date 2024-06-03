//
//  StateButtonStyle+Constants.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/3/24.
//

import DesignSystemFoundation

public extension StateButtonStyle {
  
  /// Primary
  static func primary(_ buttonSize: ButtonSize) -> StateButtonStyle {
    StateButtonStyle(buttonSize: buttonSize)
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .white,
          background: .primary500
        ),
        for: .normal
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .white,
          background: .primary700
        ),
        for: .pressed
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .white,
          background: .primary200
        ),
        for: .disabled
      )
  }
  
  /// Secondary
  static func secondary(_ buttonSize: ButtonSize) -> StateButtonStyle {
    StateButtonStyle(buttonSize: buttonSize)
      .style(
        StateButtonConfiguration(
          fontConfig: .title1,
          foreground: .primary500,
          background: .clear
        ),
        for: .normal
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .title1,
          foreground: .primary700,
          background: .clear
        ),
        for: .pressed
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .title1,
          foreground: .primary200,
          background: .clear
        ),
        for: .disabled
      )
  }
  
  /// Tertiary
  static func tertiary(_ buttonSize: ButtonSize) -> StateButtonStyle {
    StateButtonStyle(buttonSize: buttonSize)
      .style(
        StateButtonConfiguration(
          fontConfig: .title1,
          foreground: .primary500,
          background: .white
        ),
        for: .normal
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .title1,
          foreground: .primary700,
          background: .white
        ),
        for: .pressed
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .title1,
          foreground: .primary200,
          background: .white
        ),
        for: .disabled
      )
  }
}

#if(DEBUG) && (canImport(SwiftUI))
import SwiftUI
#Preview {
  ScrollView {
    Button(action: {}) {
      Text("Primary btn")
    }.buttonStyle(StateButtonStyle.primary(.default))
      .frame(maxWidth: .infinity)
    Button(action: {}) {
      Text("Primary btn")
    }.buttonStyle(StateButtonStyle.primary(.default))
    Button(action: {}) {
      Text("Primary btn")
    }.buttonStyle(StateButtonStyle.primary(.default))
      .disabled(true)
  }
}
#endif

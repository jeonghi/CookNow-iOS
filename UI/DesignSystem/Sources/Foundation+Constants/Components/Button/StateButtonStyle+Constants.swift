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
          background: .primary500,
          border: .clear
        ),
        for: .normal
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .white,
          background: .primary700,
          border: .clear
        ),
        for: .pressed
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .white,
          background: .primary200,
          border: .clear
        ),
        for: .disabled
      )
      .style(
        StateButtonConfiguration(
          fontConfig: nil,
          foreground: .white,
          background: .primary500,
          border: .clear
        ),
        for: .progress
      )
  }
  
  /// Secondary
  static func secondary(_ buttonSize: ButtonSize) -> StateButtonStyle {
    StateButtonStyle(buttonSize: buttonSize)
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .primary500,
          background: .clear,
          border: .primary500
        ),
        for: .normal
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .primary700,
          background: .clear,
          border: .primary700
        ),
        for: .pressed
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .primary200,
          background: .clear,
          border: .primary200
        ),
        for: .disabled
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .primary500,
          background: .clear,
          border: .primary500
        ),
        for: .progress
      )
  }
  
  /// Tertiary
  static func tertiary(_ buttonSize: ButtonSize) -> StateButtonStyle {
    StateButtonStyle(buttonSize: buttonSize)
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .primary500,
          background: .white,
          border: .gray300
        ),
        for: .normal
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .primary700,
          background: .white,
          border: .gray500
        ),
        for: .pressed
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .primary200,
          background: .white,
          border: .gray100
        ),
        for: .disabled
      )
      .style(
        StateButtonConfiguration(
          fontConfig: .bodyBold,
          foreground: .primary500,
          background: .white,
          border: .gray300
        ),
        for: .progress
      )
  }
}

#if(DEBUG) && (canImport(SwiftUI))
import SwiftUI
#Preview {
  VStack(alignment: .leading) {
    
    // MARK: Primary
    Text("Primary")
    Button(action: {}) {
      Text("Primary btn")
    }.buttonStyle(StateButtonStyle.primary(.default))
      .frame(maxWidth: .infinity)
    
    Button(action: {}) {
      Text("Primary btn")
    }.buttonStyle(StateButtonStyle.primary(.default))
      .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    
    Button(action: {}) {
      Text("Primary btn")
    }.buttonStyle(StateButtonStyle.primary(.default))
      .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
      .isProgressing(true)
    
    
    Text("Secondary")
    Button(action: {}) {
      Text("Secondary btn")
    }.buttonStyle(StateButtonStyle.secondary(.default))
    Button(action: {}) {
      Text("Secondary btn")
    }.buttonStyle(StateButtonStyle.secondary(.default))
      .disabled(true)
    Button(action: {}) {
      Text("Secondary btn")
    }.buttonStyle(StateButtonStyle.secondary(.default))
      .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
      .isProgressing(true)
    
    Text("Tertiary")
    Button(action: {}) {
      Text("Tertiary btn")
    }.buttonStyle(StateButtonStyle.tertiary(.default))
    Button(action: {}) {
      Text("Tertiary btn")
    }.buttonStyle(StateButtonStyle.tertiary(.default))
      .disabled(true)
    Button(action: {}) {
      Text("Tertiary btn")
    }.buttonStyle(StateButtonStyle.tertiary(.default))
      .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
      .isProgressing(true)
  }
  .padding(.horizontal, 20)
}
#endif

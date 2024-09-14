//
//  CNFloattingButton.swift
//  DesignSystem
//
//  Created by 쩡화니 on 9/2/24.
//

import DesignSystemFoundation
import FloatingButton
import SwiftUI

public struct CNFloattingButton {
  let label: String
  let action: (() -> Void)?
  
  public init(label: String, action: (() -> Void)? = nil) {
    self.label = label
    self.action = action
  }
}

public extension View {
  
  /// 플로팅 버튼
  func cnFloattingButton(
    isOpen: Binding<Bool>,
    mainButton: CNFloattingButton,
    subButtons: [CNFloattingButton]
  ) -> some View {
    self
      .simultaneousGesture(TapGesture().onEnded {
        isOpen.wrappedValue = false
      })
      .overlay(alignment: .bottomTrailing) {
        FloatingButton(
          mainButtonView: Button(action: {
            mainButton.action?() // Main button action
          }) {
            Text(mainButton.label) // Main button label
          }
          .buttonStyle(MainButtonStyle())
          
          ,
          buttons: subButtons.map { subButton in
            Button(action: {
              subButton.action?() // Sub button action
            }) {
              Text(subButton.label) // Sub button label
            }
            .buttonStyle(SubButtonStyle())
          },
          isOpen: isOpen
        )
        .straight()
        .direction(.top)
        .spacing(10)
        .padding()
      }
      
  }
}

import SwiftUI

struct MainButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    Circle()
      .fill(Color.asset(.primary900))
      .frame(width: 56, height: 56)
      .shadow(color: .asset(.black.with(alpha: 0.14)), radius: 5, y: 4)
      .overlay {
        configuration.label
          .font(.asset(.subhead2))
      }
      .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
      .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
      .foregroundStyle(Color.asset(.white))
  }
}

struct SubButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    Circle()
      .fill(Color.asset(.primary700))
      .frame(width: 56, height: 56)
      .shadow(color: .asset(.black.with(alpha: 0.14)), radius: 5, y: 4)
      .overlay {
        configuration.label
          .font(.asset(.caption))
      }
      .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
      .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
      .foregroundStyle(Color.asset(.white))
  }
}

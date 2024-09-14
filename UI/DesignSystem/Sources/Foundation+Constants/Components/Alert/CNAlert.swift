//
//  CNAlert.swift
//  DesignSystem
//
//  Created by 쩡화니 on 9/12/24.
//

import DesignSystemFoundation
import Common
import SwiftUI
import PopupView

private enum Metric {
  static var horizontalPadidng: CGFloat = 23.5
  static var verticalInset: CGFloat = 24
  static var horizontalInset: CGFloat = 24
  static var verticalSpacing: CGFloat = 16
  static var descriptionVerticalPadding: CGFloat = 16
  static var buttonSpacing: CGFloat = 10
}

public extension View {
  func cnAlert(
    _ alertState: Binding<CNAlertState?>
  ) -> some View {
    self
      .popup(item: alertState) { state in
        ZStack {
          VStack(spacing: Metric.verticalSpacing) {
            Text(state.title)
              .font(.asset(.subhead3))
              .foregroundStyle(Color.asset(.gray800))
            Text(state.description ?? "")
              .padding(.vertical, Metric.descriptionVerticalPadding)
              .font(.asset(.body2))
              .foregroundStyle(Color.asset(.gray500))
              .multilineTextAlignment(.center)
            HStack(spacing: Metric.buttonSpacing) {
              Button(action: {
                state.secondaryButton.action?()
              }) {
                Text(state.secondaryButton.label)
              }
              .buttonStyle(StateButtonStyle.secondary(.default))
              Button(action: {
                state.primaryButton.action?()
              }) {
                Text(state.primaryButton.label)
              }
              .buttonStyle(StateButtonStyle.primary(.default))
            }
          }
          .padding(.horizontal , Metric.horizontalInset)
          .padding(.vertical, Metric.verticalInset)
        }
        .frame(maxWidth: .infinity)
        .background(
          Color.asset(.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        )
        .padding(.horizontal, Metric.horizontalPadidng)
      } customize: {
        $0
          .animation(.spring())
          .isOpaque(true)
          .type(.toast)
          .position(.center)
          .dragToDismiss(true)
          .closeOnTap(false)
          .closeOnTapOutside(true)
          .backgroundColor(Color.asset(.overlayBackground))
      }
  }
}

public struct CNAlertState: Hashable {
  
  public static func == (lhs: CNAlertState, rhs: CNAlertState) -> Bool {
    lhs.id == rhs.id
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  private let id = UUID()
  
  let title: String
  let description: String?
  let primaryButton: CNAlertButton
  let secondaryButton: CNAlertButton
  
  public init(
    title: String,
    description: String?,
    primaryButton: CNAlertButton,
    secondaryButton: CNAlertButton
  ) {
    self.title = title
    self.description = description
    self.primaryButton = primaryButton
    self.secondaryButton = secondaryButton
  }
}

public struct CNAlertButton {
  
  let label: String
  let action: (() -> Void)?
  
  public init(label: String, action: (() -> Void)?) {
    self.label = label
    self.action = action
  }
}

//
//  CNFloattingButton.swift
//  DesignSystem
//
//  Created by 쩡화니 on 9/2/24.
//

import DesignSystemFoundation
import FloatingButton
import SwiftUI

public struct CNFloattingButton<MainButtonView, SubButtonsView>: View where MainButtonView: View, SubButtonsView: View {
  
  fileprivate var mainButtonView: MainButtonView
  fileprivate var buttons: [SubButtonsView]

  @State private var privateIsOpen: Bool = false
  var isOpenBinding: Binding<Bool>?
  var isOpen: Bool {
      get { isOpenBinding?.wrappedValue ?? privateIsOpen }
  }

  public init(mainButtonView: MainButtonView, buttons: [SubButtonsView]) {
    self.mainButtonView = mainButtonView
    self.buttons = buttons
  }
  
  public init(mainButtonView: MainButtonView, buttons: [SubButtonsView], isOpen: Binding<Bool>) {
    self.mainButtonView = mainButtonView
    self.buttons = buttons
    self.isOpenBinding = isOpen
  }
  
  public var body: some View {
    FloatingButton(mainButtonView: mainButtonView, buttons: buttons, isOpen: isOpenBinding ?? $privateIsOpen)
      .straight()
      .direction(.top)
      .spacing(10)
      .delays(delayDelta: 0.1)
  }
}

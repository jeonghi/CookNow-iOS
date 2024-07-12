//
//  View+onLifeCycle.swift
//  Common
//
//  Created by 쩡화니 on 7/12/24.
//

import SwiftUI

public extension View {
  /// viewDidLoad
  func onLoad(perform action: (() -> Void)? = nil) -> some View {
    modifier(ViewDidLoadModifier(perform: action))
  }
  
  func onLifeCycle(
    onLoad: (() -> Void)? = nil,
    onAppear: (() -> Void)? = nil,
    onDisappear: (() -> Void)? = nil
  ) -> some View {
    modifier(ViewLifeCycleModifier())
  }
}

private struct ViewDidLoadModifier: ViewModifier {
  @State private var didLoad = false
  private let action: (() -> Void)?
  
  init(perform action: (() -> Void)? = nil) {
    self.action = action
  }
  
  func body(content: Content) -> some View {
    content.onAppear {
      if didLoad == false {
        didLoad = true
        action?()
      }
    }
  }
}


private struct ViewLifeCycleModifier: ViewModifier {
  
  private let onLoad: (() -> Void)?
  private let onAppear: (() -> Void)?
  private let onDisappear: (() -> Void)?
  
  init(
    onLoad: (() -> Void)? = nil,
    onAppear: (() -> Void)? = nil,
    onDisappear: (() -> Void)? = nil
  ){
    self.onLoad = onLoad
    self.onAppear = onAppear
    self.onDisappear = onDisappear
  }
  
  func body(content: Content) -> some View {
    content
      .onAppear {
        onAppear?()
      }
      .onDisappear {
        onDisappear?()
      }
      .onLoad {
        onLoad?()
      }
  }
}

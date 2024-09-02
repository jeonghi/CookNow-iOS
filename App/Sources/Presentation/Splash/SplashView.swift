//
//  SplashView.swift
//  App
//
//  Created by 쩡화니 on 8/29/24.
//


import SwiftUI
import ComposableArchitecture
import DesignSystem
import DesignSystemFoundation
import Dependencies
import Common

// MARK: Properties
public struct SplashView: BaseFeatureViewType {
  
  public typealias Core = SplashCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  public struct ViewState: Equatable {
    public init(state: CoreState) {
    }
  }
  
  public init(
    _ store: StoreOf<Core> = .init(
      initialState: Core.State()
    ){
      Core()
    }
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: ViewState.init)
  }
  
  private enum Metric {
    static let logoWidthRatio = 0.4
  }
}

// MARK: Layout
extension SplashView: View {
  
  public var body: some View {
    ZStack {
      Color.asset(.bgMain)
      GeometryReader { geo in
        Image.asset(.onboardingLogo)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: geo.size.width * Metric.logoWidthRatio)
          .position(x: geo.size.width/2, y: geo.size.height/2)
      }
    }
    .ignoresSafeArea(edges: [.all])
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear {
      viewStore.send(.onAppear)
    }
  }
}

// MARK: Componet
extension SplashView {
  
}

#Preview {
  NavigationView {
    SplashView()
      .environment(\.locale, .init(identifier: "ko"))
  }
}


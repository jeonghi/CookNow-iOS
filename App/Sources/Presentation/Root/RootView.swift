//
//  RootView.swift
//  App
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI
import ComposableArchitecture
import Common
import Onboading

// MARK: Properties
struct RootView: BaseFeatureViewType {
  
  typealias Core = RootCore
  let store: StoreOf<Core>
  
  @ObservedObject var viewStore: ViewStore<ViewState, CoreAction>
  
  struct ViewState: Equatable {
    var route: AppRoute
    var isLoading: Bool
    init(state: CoreState) {
      route = state.route
      isLoading = state.isLoading
    }
  }
  
  init(
    _ store: StoreOf<Core> = .init(
      initialState: Core.State()
    ){
      Core()
    }
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: ViewState.init)
  }
}

// MARK: Layout
extension RootView: View {
  
  var body: some View {
    ZStack {
      switch viewStore.route {
      case .splash:
        IfLetStore(splashStore) { store in
          SplashView(store)
        }
      case .onboarding:
        IfLetStore(onboardingStore) { store in
          OnboardingView(store)
        }
      case .mainTab:
        IfLetStore(mainTabStore) { store in
          MainTabView(store)
        }
      }
    }
    .cnLoading(viewStore.isLoading)
    .onAppear {
      viewStore.send(.onAppear)
    }
    .ignoresSafeArea(edges: [.horizontal, .top])
    .kerning(-0.6) // 자간 -0.6
  }
}

// MARK: Componet
extension RootView {
  
  private var onboardingStore: Store<OnboadingCore.State?, OnboadingCore.Action> {
    return store.scope(state: \.onboardingState, action: CoreAction.onboardingAction)
  }
  
  private var mainTabStore: Store<MainTabCore.State?, MainTabCore.Action> {
    return store.scope(state: \.mainTabState, action: CoreAction.mainTabAction)
  }
  
  private var splashStore: Store<SplashCore.State?, SplashCore.Action> {
    return store.scope(state: \.splashState, action: CoreAction.splashAction)
  }
}

#Preview {
  NavigationView {
    RootView()
      .environment(\.locale, .init(identifier: "ko"))
  }
}

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
  @Environment(\.scenePhase) private var scenePhase
  
  struct ViewState: Equatable {
    var route: AppRoute?
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
      if let route = viewStore.route {
        switch route {
        case .onboarding:
          IfLetStore(onboardingStore) { store in
            OnboardingView(store)
          }
        case .mainTab:
          IfLetStore(mainTabStore) { store in
            NavigationWrapper {
              MainTabView(store)
            }
          }
        }
      }
      
      IfLetStore(splashStore) { store in
        SplashView(store)
      }
    }
    .kerning(-0.6) // 자간 -0.6
    .ignoresSafeArea(edges: [.horizontal, .top])
    .cnLoading(viewStore.isLoading)
    .onAppear {
      viewStore.send(.onAppear)
    }
    .onLoad {
      viewStore.send(.onLoad)
    }
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .active {
        viewStore.send(.onSceneActive)
      }
    }
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

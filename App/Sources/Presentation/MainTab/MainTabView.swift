//
//  MainTabView.swift
//  App
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI
import DesignSystem
import DesignSystemFoundation
import IngredientBox
import Setting
import Refrigerator
import Common
import ComposableArchitecture

// MARK: Properties
public struct MainTabView: BaseFeatureViewType {
  
  public typealias Core = MainTabCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  public struct ViewState: Equatable {
    
    var selectedTab: MainTabType
    
    public init(state: CoreState) {
      selectedTab = state.selectedTab
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
    static let tabItemInnerSpacing: CGFloat = 4
    static let tabIconSize: CGFloat = 24
  }
}

extension MainTabView: View {
  public var body: some View {
    TabView(selection: viewStore.binding(get: \.selectedTab, send: CoreAction.selectTab)) {
      ForEach(MainTabType.allCases, id: \.self) { tabType in
        
        
        ZStack {
          switch tabType {
          case .Refrigerator:
            //            NavigationWrapper {
            RefrigeratorHomeView(refrigeratorStore)
              .navigationBarTitleDisplayMode(.inline)
//              .navigationTitle(tabType.title)
//                          .navigationBarTitleDisplayMode(.inline)
            //            }
          case .IngredientsBox:
            //            NavigationWrapper {
            IngredientBoxView(ingredientBoxStore)
              .navigationBarTitleDisplayMode(.inline)
//              .navigationTitle(tabType.title)

            //            }
          case .Setting:
            //            NavigationWrapper {
            SettingView(settingStore)
              .navigationBarTitleDisplayMode(.inline)
//              .navigationTitle(tabType.title)
//              .navigationBarTitleDisplayMode(.inline)
            //            }
          }
        }
        .hideKeyboardWhenTappedAround()
        .tabItem {
          VStack(spacing: Metric.tabItemInnerSpacing) {
            Image.asset(viewStore.selectedTab == tabType ? tabType.selectedIcon : tabType.icon)
              .renderingMode(.original)
              .resizable()
              .frame(width: Metric.tabIconSize, height: Metric.tabIconSize)
            Text(tabType.title)
          }
        }
        .tag(tabType)
      }
    } //: TabView
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text(viewStore.selectedTab.title)
          .font(.asset(.bodyBold3))
      }
    }
    .toolbarTitleDisplayMode(.inline)
    .tint(Color.asset(.primary700))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

private extension MainTabView {
  private var ingredientBoxStore: StoreOf<IngredientBoxCore> {
    return store.scope(state: \.ingredientBoxState, action: CoreAction.ingredientBoxAction)
  }
  
  private var refrigeratorStore: StoreOf<RefrigeratorHomeCore> {
    return store.scope(state: \.refrigeratorState, action: CoreAction.refrigeratorAction)
  }
  
  private var settingStore: StoreOf<SettingCore> {
    return store.scope(state: \.settingState, action: CoreAction.settingAction)
  }
}


@available(iOS 17.0, *)
#Preview {
  NavigationWrapper {
    MainTabView()
  }
}

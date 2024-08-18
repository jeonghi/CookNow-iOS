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

struct MainTabView {
  
  @ObservedObject var coordinator: UICoordinator
  
  private enum Metric {
    static let tabItemInnerSpacing: CGFloat = 4
    static let tabIconSize: CGFloat = 24
  }
  
  init(coordinator: UICoordinator = .init()){
    self.coordinator = coordinator
  }
}

extension MainTabView: View {
  var body: some View {
    TabView(selection: $coordinator.selectedTab) {
      ForEach(MainTabType.allCases, id: \.self) { tabType in
        
        
        ZStack {
          switch tabType {
          case .Refrigerator:
            NavigationWrapper {
              LazyNavigationView(
                RefrigeratorHomeView()
                  .navigationTitle(tabType.title)
                  .navigationBarTitleDisplayMode(.inline)
              )
            }
          case .IngredientsBox:
            
            NavigationWrapper {
              LazyNavigationView(
                IngredientBoxView()
                  .navigationTitle(tabType.title)
                  .toolbar(.hidden, for: .navigationBar)
              )
            }
          case .Setting:
            NavigationWrapper {
              LazyNavigationView(
                SettingView()
                  .navigationTitle(tabType.title)
                  .navigationBarTitleDisplayMode(.inline)
              )
            }
          }
        }
        .hideKeyboardWhenTappedAround()
        .tabItem {
          VStack(spacing: Metric.tabItemInnerSpacing) {
            Image.asset(coordinator.selectedTab == tabType ? tabType.selectedIcon : tabType.icon)
              .renderingMode(.original)
              .resizable()
              .frame(width: Metric.tabIconSize, height: Metric.tabIconSize)
            Text(tabType.title)
          }
        }
        .tag(tabType)
      }
    } //: TabView
    .tint(Color.asset(.primary700))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}


@available(iOS 17.0, *)
#Preview {
  MainTabView()
}

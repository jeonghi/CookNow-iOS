//
//  MainTabView.swift
//  App
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI
import DesignSystem
import DesignSystemFoundation

struct MainTabView {
  @State var selectedTab: MainTabType = .IngredientsBox
  
  private enum Metric {
    static let tabItemInnerSpacing: CGFloat = 4
    static let tabIconSize: CGFloat = 24
  }
}

extension MainTabView: View {
  var body: some View {
    TabView(selection: $selectedTab) {
      ForEach(MainTabType.allCases, id: \.self) { tabType in
        ZStack {
          switch tabType {
          case .IngredientsBox:
            VStack {
              Color.asset(.bg100)
            }
          case .Refrigerator:
            VStack {
              Color.asset(.bg100)
            }
          case .Setting:
            VStack {
              Color.asset(.bg100)
            }
          }
        }
        .tabItem {
          VStack(spacing: Metric.tabItemInnerSpacing) {
            Image.asset(selectedTab == tabType ? tabType.selectedIcon : tabType.icon)
              .renderingMode(.original)
              .resizable()
              .frame(width: Metric.tabIconSize, height: Metric.tabIconSize)
            Text(tabType.title)
          }
          .foregroundStyle(Color.asset(.primary700))
          .tint(Color.asset(.primary700))
        }
        .tag(tabType)
      }
    }
  }
}


@available(iOS 17.0, *)
#Preview {
  MainTabView()
}

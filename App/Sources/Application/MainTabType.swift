//
//  MainTabType.swift
//  App
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI
import DesignSystem
import DesignSystemFoundation
import Onboading

enum MainTabType: CaseIterable {
  case Refrigerator // 냉장고
  case IngredientsBox // 재료함
  case Setting
  
  var icon: ImageAsset {
    switch self {
    case .Refrigerator:
      return .refrigeratorTab
    case .IngredientsBox:
      return .ingredientBoxTab
    case .Setting:
      return .settingTab
    }
  }
  
  var selectedIcon: ImageAsset {
    switch self {
    case .Refrigerator:
      return .refrigeratorSelectedTab
    case .IngredientsBox:
      return .ingredientBoxSelectedTab
    case .Setting:
      return .settingSelectedTab
    }
  }
  
  var title: LocalizedStringKey {
    switch self {
    case .Refrigerator:
      return "RefrigeratorTabTitle"
    case .IngredientsBox:
      return "IngredientsBoxTitle"
    case .Setting:
      return "SettingTitle"
    }
  }
  
  var unselectedColor: ColorAsset {
    return .gray500
  }
  
  var selectedColor: ColorAsset {
    return .primary700
  }
}

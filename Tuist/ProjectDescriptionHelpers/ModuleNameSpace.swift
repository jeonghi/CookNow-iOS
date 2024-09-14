//
//  NameSpace.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/2/24.
//

import Foundation

public enum ModuleNameSpace {}

public extension ModuleNameSpace {
  enum App: String {
    case App = "App"
  }
  
  enum Feature: String {
    case Onboading = "Onboading"
    case IngredientBox = "IngredientBox"
    case Setting = "Setting"
    case Refrigerator = "Refrigerator"
    case IngredientForm = "IngredientForm"
  }
  
  enum Common: String {
    case Common = "Common"
  }
  
  enum UI: String {
    case DesignSystem = "DesignSystem"
    case DesignSystemFoundation = "DesignSystemFoundation"
  }
  
  enum Domain: String {
    case Domain = "Domain"
  }

  enum Core: String {
    case CNNetwork = "CNNetwork"
  }

  enum Auth: String {
    case Auth = "Auth"
  }
}

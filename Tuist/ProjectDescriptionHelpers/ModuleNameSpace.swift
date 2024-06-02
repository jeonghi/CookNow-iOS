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
  }
  
  enum Common: String {
    case Protocols = "Protocols"
  }
  
  enum UI: String {
    case DesignSystem = "DesignSystem"
  }
}

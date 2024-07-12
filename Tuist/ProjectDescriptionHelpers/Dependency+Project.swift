//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/2/24.
//

import ProjectDescription

public extension TargetDependency {
  enum Project {}
  enum ExternalProject {}
}

public extension TargetDependency.Project {
  static let Onboarding = TargetDependency.project(
    target: ModuleNameSpace.Feature.Onboading.rawValue,
    path: .relativeToRoot("Feature/Onboarding"),
    condition: nil
  )
  static let Commmon = TargetDependency.project(
    target: ModuleNameSpace.Common.Common.rawValue,
    path: .relativeToRoot("Common"),
    condition: nil
  )
  static let DesignSystem = TargetDependency.project(
    target: ModuleNameSpace.UI.DesignSystem.rawValue,
    path: .relativeToRoot("UI/DesignSystem"),
    condition: nil
  )
  
  static let DesignSystemFoundation = TargetDependency.project(
    target: ModuleNameSpace.UI.DesignSystemFoundation.rawValue,
    path: .relativeToRoot("UI/DesignSystemFoundation"),
    condition: nil
  )
}

public extension TargetDependency.ExternalProject {
  static let TCA = TargetDependency.external(name: "ComposableArchitecture", condition: nil)
}

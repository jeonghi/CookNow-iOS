//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/2/24.
//

import ProjectDescription

public extension TargetDependency {
  enum Project {}
}

public extension TargetDependency.Project {
  static let onboarding = TargetDependency.project(
    target: ModuleNameSpace.Feature.Onboading.rawValue,
    path: .relativeToRoot("Feature/Onboarding"),
    condition: nil
  )
  static let protocols = TargetDependency.project(
    target: ModuleNameSpace.Common.Protocols.rawValue,
    path: .relativeToRoot("Common/Protocols"),
    condition: nil
  )
  static let designSystem = TargetDependency.project(
    target: ModuleNameSpace.UI.DesignSystem.rawValue,
    path: .relativeToRoot("UI/DesignSystem"),
    condition: nil
  )
}

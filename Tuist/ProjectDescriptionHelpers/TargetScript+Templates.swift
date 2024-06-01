//
//  TargetScript+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/1/24.
//

import ProjectDescription

public extension ProjectDescription.TargetScript {
  static let swiftLint = TargetScript.pre(
    path: Path.relativeToRoot("Scripts/SwiftLintRunScript.sh"),
    name: "SwiftLint",
    basedOnDependencyAnalysis: false
  )
}

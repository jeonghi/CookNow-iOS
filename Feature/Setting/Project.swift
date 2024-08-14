//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 8/14/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFramework(
  name: ModuleNameSpace.Feature.Setting.rawValue,
  dependencies: [
    .Project.Commmon,
    .Project.DesignSystem,
    .Project.Domain,
    .Project.CNNetwork
  ]
)



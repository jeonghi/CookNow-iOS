//
//  Projects.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 8/15/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFramework(
  name: ModuleNameSpace.Feature.Refrigerator.rawValue,
  dependencies: [
    .Project.Commmon,
    .Project.DesignSystem,
    .Project.Domain,
    .ExternalProject.TCA,
    .Project.CNNetwork
  ]
)

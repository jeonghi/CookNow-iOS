//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 7/3/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFramework(
  name: ModuleNameSpace.Feature.IngredientBox.rawValue,
  dependencies: [
    .Project.Commmon,
    .Project.DesignSystem,
    .Project.Domain,
    .ExternalProject.TCA,
    .Project.CNNetwork
  ]
)



//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 9/14/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFramework(
  name: ModuleNameSpace.Feature.IngredientForm.rawValue,
  dependencies: [
    .Project.Commmon,
    .Project.DesignSystem,
    .Project.Domain,
    .ExternalProject.TCA
  ]
)

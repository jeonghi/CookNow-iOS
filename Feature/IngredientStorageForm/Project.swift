//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/16/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFramework(
  name: ModuleNameSpace.Feature.IngredientStorageForm.rawValue,
  dependencies: [
    .Project.Commmon,
    .Project.DesignSystem
  ]
)


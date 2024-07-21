//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/2/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFramework(
  name: ModuleNameSpace.Feature.Onboading.rawValue,
  dependencies: [
    .Project.Commmon,
    .Project.DesignSystem,
    .ExternalProject.TCA,
    .ExternalProject.Google.FirebaseAnalytics,
    .ExternalProject.Google.FirebaseAuth,
    .ExternalProject.Google.GoogleSignIn
  ]
)


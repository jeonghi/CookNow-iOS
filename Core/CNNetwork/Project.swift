//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 7/22/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeLibrary(
  name: ModuleNameSpace.Core.CNNetwork.rawValue,
  dependencies: [
    .ExternalProject.Alamofire,
    .Project.Commmon
  ]
)

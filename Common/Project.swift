//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/2/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeLibrary(
  name: ModuleNameSpace.Common.Common.rawValue,
  dependencies: [
    .external(name: "Then", condition: nil),
    .external(name: "SnapKit", condition: nil)
  ]
)

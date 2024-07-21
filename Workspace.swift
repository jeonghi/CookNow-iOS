//
//  Workspace.swift
//  CookNow_iOSManifests
//
//  Created by 쩡화니 on 6/1/24.
//

import ProjectDescription

let workspace = Workspace.create()

extension Workspace {
  static func create() -> Workspace {
    Workspace(
      name: "CookNow",
      projects: [
        "App",
        "Feature/**",
        "UI/**",
        "Domain/**",
        "Core/**",
        "Auth/**"
      ]
    )
  }
}

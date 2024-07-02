//
//  Options+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 7/2/24.
//

import ProjectDescription

extension ProjectDescription.Project.Options {
  public static var `default` = Self.options(
    automaticSchemesOptions: .disabled,
    defaultKnownRegions: ["en", "ko", "Base"],
    developmentRegion: "Base",
    textSettings: .textSettings(usesTabs: false, indentWidth: 2, tabWidth: 2)
  )
}

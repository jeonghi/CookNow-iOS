//
//  SourceFilesList+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/1/24.
//

import ProjectDescription

extension ProjectDescription.SourceFilesList {
  static let sources: SourceFilesList = "Sources/**"
  static let tests: SourceFilesList = "Tests/**"
}

extension ProjectDescription.ResourceFileElements {
  static let resources: ResourceFileElements = ["Resources/**"]
}

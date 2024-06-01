//
//  Settings+Templates.swift
//  CookNow_iOSManifests
//
//  Created by 쩡화니 on 6/1/24.
//

import Foundation
import ProjectDescription

extension ProjectDescription.Settings {
  public static var projectSettings: Self {
    .settings(
      configurations: BuildEnvironment.allCases.map(\.projectConfiguration)
    )
  }
  
  public static var targetSettings: Self {
    .settings(
      base: [
        "OTHER_LDFLAGS": .string("-ObjC"),
      ],
      configurations: BuildEnvironment.allCases.map(\.targetConfiguration)
    )
  }
}

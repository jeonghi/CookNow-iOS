//
//  Project+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/2/24.
//

import ProjectDescription

public extension Project {
  
  /// App을 만드는 메서드
  static func makeApp(
    name appName: String,
    dependencies: [TargetDependency] = []
  ) -> Project {
    Project(
      name: appName,
      settings: .projectSettings,
      targets: [
        .target(
          name: appName,
          destinations: .iOS,
          product: .app,
          bundleId: "\(Environment.bundleId)",
          infoPlist: .extendingDefault(with: [
            "UILaunchStoryboardName": "Launch Screen.storyboard"
          ]),
          sources: .sources,
          resources: .resources,
    //      scripts: [.swiftLint],
          dependencies: dependencies,
          settings: .targetSettings
        )
      ],
      schemes: Scheme.allSchemes(for: [appName], executable: appName)
    )
  }
  
  /// Framework를 만드는 메서드
  static func makeFramework(
    name moduleName: String,
    dependencies: [TargetDependency] = []
  ) -> Project {
    Project(
      name: moduleName,
      settings: .projectSettings,
      targets: [
        .target(
          name: moduleName,
          destinations: .iOS,
          product: Environment.forPreview ? Product.framework : Product.staticFramework,
          bundleId: "\(Environment.bundleId)",
          infoPlist: .default,
          sources: ["Sources/**"],
          resources: ["Resources/**"],
          dependencies: dependencies,
          settings: .targetSettings
        )
      ],
      schemes: Scheme.allSchemes(for: [moduleName], executable: moduleName)
    )
  }
  
  /// Library를 만드는 메서드
  static func makeLibrary(
    name moduleName: String,
    dependencies: [TargetDependency] = []
  ) -> Project {
    Project(
      name: moduleName,
      settings: .projectSettings,
      targets: [
        .target(
          name: moduleName,
          destinations: .iOS,
          product: .staticLibrary,
          bundleId: "\(Environment.bundleId)",
          infoPlist: .default,
          sources: ["Sources/**"],
          dependencies: dependencies,
          settings: .targetSettings
        )
      ],
      schemes: Scheme.allSchemes(for: [moduleName], executable: moduleName)
    )
  }
}

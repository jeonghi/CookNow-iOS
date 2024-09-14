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
    infoPlist: InfoPlist? = nil,
    entitlements: Entitlements? = nil,
    dependencies: [TargetDependency] = []
  ) -> Project {
    Project(
      name: appName,
      options: .default,
      settings: .projectSettings,
      targets: [
        .target(
          name: appName,
          destinations: Environment.destinations,
          product: .app,
          bundleId: "\(Environment.bundleId)",
          deploymentTargets: Environment.deploymentTargets,
          infoPlist: infoPlist ?? .extendingDefault(with: [
            "UILaunchStoryboardName": "Launch Screen.storyboard"
          ]),
          sources: .sources,
          resources: .resources,
    //      scripts: [.swiftLint],
          entitlements: entitlements,
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
      options: .default,
      settings: .projectSettings,
      targets: [
        .target(
          name: moduleName,
          destinations: Environment.destinations,
          product: Environment.forPreview ? Product.framework : Product.staticFramework,
          bundleId: "\(Environment.bundleId).app.\(moduleName)",
          deploymentTargets: Environment.deploymentTargets,
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
      options: .default,
      settings: .projectSettings,
      targets: [
        .target(
          name: moduleName,
          destinations: Environment.destinations,
          product: .staticLibrary,
          bundleId: "\(Environment.bundleId).app.\(moduleName)",
          deploymentTargets: Environment.deploymentTargets,
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

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeApp(
  name: ModuleNameSpace.App.App.rawValue,
  infoPlist: .file(path: .relativeToRoot("SupportingFiles/App-Info.plist")),
  entitlements: .file(path: .relativeToRoot("SupportingFiles/App.entitlements")),
  dependencies: [
    .Project.DesignSystem,
    .Project.Onboarding
  ]
)

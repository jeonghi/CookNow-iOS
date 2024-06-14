import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeApp(
  name: ModuleNameSpace.App.App.rawValue,
  dependencies: [
    .Project.DesignSystem,
  ]
)

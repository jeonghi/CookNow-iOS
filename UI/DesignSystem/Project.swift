import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFramework(
  name: ModuleNameSpace.UI.DesignSystem.rawValue,
  dependencies: [
    .Project.DesignSystemFoundation,
    .external(name: "FloatingButton", condition: nil),
    .external(name: "FSCalendar", condition: nil)
  ]
)

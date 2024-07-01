import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFramework(
  name: ModuleNameSpace.UI.DesignSystem.rawValue,
  dependencies: [
    .Project.DesignSystemFoundation,
    .Project.Commmon,
    .external(name: "FloatingButton", condition: nil),
    .external(name: "FSCalendar", condition: nil),
    .external(name: "PopupView", condition: nil),
    .external(name: "Kingfisher", condition: nil)
  ]
)

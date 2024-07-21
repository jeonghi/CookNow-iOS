import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeApp(
  name: ModuleNameSpace.App.App.rawValue,
  dependencies: [
    .Project.DesignSystem,
    .ExternalProject.Google.FirebaseAnalytics,
    .ExternalProject.Google.FirebaseAuth,
    .ExternalProject.Google.GoogleSignIn
  ]
)

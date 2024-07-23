// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers


    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
      productTypes: [
        "Lottie": .framework,
        "ComposableArchitecture": .framework,
        "Alamofire": .framework
      ]
    )
#endif

let package = Package(
    name: "CookNow",
    dependencies: [
      .package(
        url: "https://github.com/exyte/FloatingButton.git",
        from: "1.3.0"
      ),
      .package(
        url: "https://github.com/WenchaoD/FSCalendar.git",
        from: "2.8.3"
      ),
      .package(
        url: "https://github.com/SnapKit/SnapKit.git",
        from: "5.7.1"
      ),
      .package(
        url: "https://github.com/devxoul/Then.git",
        from: "3.0.0"
      ),
      .package(
        url: "https://github.com/exyte/PopupView.git",
        from: "3.0.0"
      ),
      .package(
        url: "https://github.com/onevcat/Kingfisher.git",
        from: "7.12.0"
      ),
      .package(
        url: "https://github.com/pointfreeco/swift-composable-architecture.git",
        from: "1.11.2"
      ),
      .package(
        url: "https://github.com/airbnb/lottie-ios.git",
        from: "4.5.0"
      ),
      .package(
        url: "https://github.com/Alamofire/Alamofire",
        from: "5.9.1"
       ),
      .package(
        url: "https://github.com/firebase/firebase-ios-sdk",
        from: "10.29.0"
      ),
      .package(
        url: "https://github.com/google/GoogleSignIn-iOS",
        from: "7.1.0"
      )
    ]
)

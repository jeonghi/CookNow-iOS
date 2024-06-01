import SwiftUI

@main
struct _App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
}

extension _App: App {
  var body: some Scene {
    WindowGroup {
      EmptyView()
    }
  }
}

#Preview {
  EmptyView()
}

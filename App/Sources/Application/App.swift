import SwiftUI
import Onboading

@main
struct _App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
}

extension _App: App {
  var body: some Scene {
    WindowGroup {
      OnboardingView()
    }
  }
}

#Preview {
  EmptyView()
}

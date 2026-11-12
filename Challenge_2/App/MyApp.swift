import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                // The whole app is always dark: keyboard, alerts and status bar match the black design.
                .preferredColorScheme(.dark)
        }
    }
}

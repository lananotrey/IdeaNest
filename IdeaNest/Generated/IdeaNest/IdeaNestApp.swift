import SwiftUI
import FirebaseCore

@main
struct IdeaNestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen()
        }
    }
}
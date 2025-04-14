import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("username") private var username = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile") {
                    TextField("Your Name", text: $username)
                }
                
                Section("Appearance") {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                }
                
                Section("App") {
                    Button(action: addToFavorites) {
                        Label("Add to Favorites", systemImage: "star.fill")
                    }
                    
                    Link(destination: URL(string: "https://apps.apple.com/app/id6451018837")!) {
                        HStack {
                            Label("Rate App", systemImage: "star.fill")
                            Spacer()
                            Image(systemName: "arrow.up.forward.app")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: shareApp) {
                        Label("Share App", systemImage: "square.and.arrow.up.fill")
                    }
                }
                
                Section("Legal") {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("Privacy Policy", systemImage: "shield.fill")
                    }
                    
                    NavigationLink(destination: TermsOfUseView()) {
                        Label("Terms of Use", systemImage: "doc.text.fill")
                    }
                }
                
                Section("About") {
                    LabeledContent("Version", value: "1.0.0")
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private func shareApp() {
        let url = URL(string: "https://apps.apple.com/app/id6451018837")!
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func addToFavorites() {
        if let url = URL(string: "ideanest://") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        if let shortcutItem = UIApplication.shared.shortcutItems?.first(where: { $0.type == "com.ideanest.quickadd" }) {
            UIApplication.shared.shortcutItems?.removeAll(where: { $0 == shortcutItem })
        } else {
            let shortcut = UIApplicationShortcutItem(
                type: "com.ideanest.quickadd",
                localizedTitle: "Quick Add Idea",
                localizedSubtitle: "Add a new idea quickly",
                icon: UIApplicationShortcutIcon(systemImageName: "plus.circle.fill"),
                userInfo: nil
            )
            UIApplication.shared.shortcutItems = [shortcut]
        }
    }
}
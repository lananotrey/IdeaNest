import SwiftUI
import StoreKit

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
                    Button(action: rateApp) {
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
            }
            .navigationTitle("Settings")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private func rateApp() {
        guard let appStoreURL = URL(string: "https://apps.apple.com/app/id6451018837") else { return }
        UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
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
}
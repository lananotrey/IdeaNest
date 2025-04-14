import SwiftUI

struct SettingsView: View {
    @AppStorage("username") private var username = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile") {
                    TextField("Your Name", text: $username)
                }
                
                Section("About") {
                    LabeledContent("Version", value: "1.0.0")
                    Link(destination: URL(string: "https://www.example.com/privacy")!) {
                        Text("Privacy Policy")
                    }
                    Link(destination: URL(string: "https://www.example.com/terms")!) {
                        Text("Terms of Use")
                    }
                }
                
                Section {
                    Button("Rate App") {
                        if let url = URL(string: "itms-apps://apple.com/app/id123456789") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    Button("Share App") {
                        let url = URL(string: "https://apps.apple.com/app/id123456789")!
                        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first,
                           let rootVC = window.rootViewController {
                            rootVC.present(activityVC, animated: true)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
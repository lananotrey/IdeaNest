import SwiftUI

struct ContentView: View {
    @StateObject private var ideaStore = IdeaStore()
    
    var body: some View {
        TabView {
            IdeasListView(ideaStore: ideaStore)
                .tabItem {
                    Label("Ideas", systemImage: "lightbulb.fill")
                }
            
            QuickAddView(ideaStore: ideaStore)
                .tabItem {
                    Label("Quick Add", systemImage: "plus.circle.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .tint(.purple)
    }
}
import SwiftUI

struct ContentView: View {
    @StateObject private var ideaStore = IdeaStore()
    
    var body: some View {
        TabView {
            IdeasListView(ideaStore: ideaStore)
                .tabItem {
                    Label("Ideas", systemImage: "lightbulb.fill")
                }
            
            FavoritesView(ideaStore: ideaStore)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .tint(.purple)
    }
}
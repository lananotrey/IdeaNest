import SwiftUI

struct ContentView: View {
    @StateObject private var ideaStore = IdeaStore()
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showOnboarding = false
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                IdeasListView(ideaStore: ideaStore)
                    .tabItem {
                        Label("Ideas", systemImage: "lightbulb.fill")
                    }
                    .tag(0)
                
                QuickAddView(ideaStore: ideaStore, selectedTab: $selectedTab)
                    .tabItem {
                        Label("Quick Add", systemImage: "plus.circle.fill")
                    }
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(2)
            }
            .tint(.purple)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            }
        }
        .onAppear {
            if !hasSeenOnboarding {
                showOnboarding = true
            }
        }
    }
}
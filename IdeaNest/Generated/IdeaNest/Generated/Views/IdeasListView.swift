import SwiftUI

struct IdeasListView: View {
    @ObservedObject var ideaStore: IdeaStore
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if ideaStore.ideas.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(ideaStore.ideas) { idea in
                            IdeaRowView(idea: idea, ideaStore: ideaStore)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                ideaStore.deleteIdea(ideaStore.ideas[index])
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("My Ideas")
            .toolbar {
                Button {
                    showingAddSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddIdeaView(ideaStore: ideaStore)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lightbulb")
                .font(.system(size: 60))
                .foregroundColor(.purple)
            
            Text("No Ideas Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add your first idea by tapping the + button")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
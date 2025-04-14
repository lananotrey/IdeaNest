import SwiftUI

struct FavoritesView: View {
    @ObservedObject var ideaStore: IdeaStore
    
    var favoriteIdeas: [Idea] {
        ideaStore.ideas.filter { $0.isFavorite }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if favoriteIdeas.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("No Favorites Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Mark your favorite ideas with a star")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(favoriteIdeas) { idea in
                            IdeaRowView(idea: idea, ideaStore: ideaStore)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
import SwiftUI

struct IdeaRowView: View {
    let idea: Idea
    @ObservedObject var ideaStore: IdeaStore
    @State private var showingEditSheet = false
    
    var body: some View {
        NavigationLink(destination: IdeaDetailView(idea: idea, ideaStore: ideaStore)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: idea.icon)
                        .foregroundColor(.purple)
                    
                    Text(idea.title)
                        .font(.headline)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            ideaStore.toggleFavorite(idea)
                        }
                    } label: {
                        Image(systemName: idea.isFavorite ? "star.fill" : "star")
                            .foregroundColor(idea.isFavorite ? .yellow : .gray)
                    }
                }
                
                Text(idea.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.gray)
                    Text(idea.location)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    Text(formatDuration(idea.duration))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(idea.createdDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.7))
            }
            .padding(.vertical, 4)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive) {
                    ideaStore.deleteIdea(idea)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                
                Button {
                    showingEditSheet = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .tint(.blue)
                
                Button {
                    ideaStore.toggleFavorite(idea)
                } label: {
                    Label("Favorite", systemImage: "star")
                }
                .tint(.yellow)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditIdeaView(idea: idea, ideaStore: ideaStore)
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        if hours > 0 {
            return "\(hours)h"
        }
        let minutes = Int(duration) / 60
        return "\(minutes)m"
    }
}
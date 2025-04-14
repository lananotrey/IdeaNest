import SwiftUI

struct IdeaRowView: View {
    let idea: Idea
    @ObservedObject var ideaStore: IdeaStore
    @State private var showingEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(idea.title)
                    .font(.headline)
                
                Spacer()
                
                Button {
                    ideaStore.toggleFavorite(idea)
                } label: {
                    Image(systemName: idea.isFavorite ? "star.fill" : "star")
                        .foregroundColor(idea.isFavorite ? .yellow : .gray)
                }
            }
            
            Text(idea.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            Text(idea.createdDate.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundColor(.tertiary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            showingEditSheet = true
        }
        .sheet(isPresented: $showingEditSheet) {
            EditIdeaView(idea: idea, ideaStore: ideaStore)
        }
    }
}
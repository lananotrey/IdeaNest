import SwiftUI

struct IdeaDetailView: View {
    let idea: Idea
    @ObservedObject var ideaStore: IdeaStore
    @Environment(\.dismiss) var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                contentSection
                
                actionButtons
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button(action: { showingEditSheet = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(action: shareIdea) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteIdea()
            }
        } message: {
            Text("Are you sure you want to delete this idea? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditSheet) {
            EditIdeaView(idea: idea, ideaStore: ideaStore)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: idea.icon)
                .font(.system(size: 60))
                .foregroundColor(.purple)
                .padding()
                .background(Color.purple.opacity(0.1))
                .clipShape(Circle())
            
            Text(idea.title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(idea.createdDate.formatted(date: .long, time: .shortened))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            detailRow(icon: "text.alignleft", title: "Description", content: idea.description)
            detailRow(icon: "mappin", title: "Location", content: idea.location)
            detailRow(icon: "clock", title: "Duration", content: formatDuration(idea.duration))
            detailRow(icon: "list.bullet", title: "Conditions", content: idea.conditions)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 20) {
            Button(action: { showingEditSheet = true }) {
                Label("Edit", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            Button(action: shareIdea) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
        }
    }
    
    private func detailRow(icon: String, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.purple)
                Text(title)
                    .font(.headline)
            }
            
            Text(content)
                .foregroundColor(.secondary)
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration.truncatingRemainder(dividingBy: 3600)) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
    
    private func deleteIdea() {
        ideaStore.deleteIdea(idea)
        dismiss()
    }
    
    private func shareIdea() {
        let shareText = """
        Idea: \(idea.title)
        Description: \(idea.description)
        Location: \(idea.location)
        Duration: \(formatDuration(idea.duration))
        Conditions: \(idea.conditions)
        """
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
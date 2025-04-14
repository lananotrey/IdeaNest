import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lightbulb")
                .font(.system(size: 60))
                .foregroundColor(.purple)
            
            Text("No Ideas Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap + to add your first idea")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
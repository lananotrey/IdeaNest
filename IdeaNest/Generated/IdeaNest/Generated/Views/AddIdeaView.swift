import SwiftUI

struct AddIdeaView: View {
    @ObservedObject var ideaStore: IdeaStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section {
                    Button("Save Idea") {
                        let idea = Idea(title: title, description: description)
                        ideaStore.addIdea(idea)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("New Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}
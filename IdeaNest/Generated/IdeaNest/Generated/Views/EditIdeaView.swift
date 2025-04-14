import SwiftUI

struct EditIdeaView: View {
    let idea: Idea
    @ObservedObject var ideaStore: IdeaStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var description: String
    
    init(idea: Idea, ideaStore: IdeaStore) {
        self.idea = idea
        self.ideaStore = ideaStore
        _title = State(initialValue: idea.title)
        _description = State(initialValue: idea.description)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section {
                    Button("Save Changes") {
                        let updatedIdea = Idea(id: idea.id,
                                             title: title,
                                             description: description,
                                             isFavorite: idea.isFavorite,
                                             createdDate: idea.createdDate)
                        ideaStore.updateIdea(updatedIdea)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("Edit Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}
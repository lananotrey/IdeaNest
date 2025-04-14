import SwiftUI

struct EditIdeaView: View {
    let idea: Idea
    @ObservedObject var ideaStore: IdeaStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var description: String
    @State private var location: String
    @State private var duration: TimeInterval
    @State private var conditions: String
    @State private var selectedIcon: String
    
    init(idea: Idea, ideaStore: IdeaStore) {
        self.idea = idea
        self.ideaStore = ideaStore
        _title = State(initialValue: idea.title)
        _description = State(initialValue: idea.description)
        _location = State(initialValue: idea.location)
        _duration = State(initialValue: idea.duration)
        _conditions = State(initialValue: idea.conditions)
        _selectedIcon = State(initialValue: idea.icon)
    }
    
    let icons = ["lightbulb", "star", "heart", "flag", "bookmark", "tag", "paperclip", "link", "clock", "calendar"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("Location & Time")) {
                    TextField("Location", text: $location)
                    HStack {
                        Text("Duration")
                        Spacer()
                        Picker("Duration", selection: $duration) {
                            Text("30 min").tag(TimeInterval(1800))
                            Text("1 hour").tag(TimeInterval(3600))
                            Text("2 hours").tag(TimeInterval(7200))
                            Text("4 hours").tag(TimeInterval(14400))
                            Text("8 hours").tag(TimeInterval(28800))
                        }
                    }
                }
                
                Section(header: Text("Conditions")) {
                    TextEditor(text: $conditions)
                        .frame(height: 80)
                }
                
                Section(header: Text("Icon")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.title2)
                                .padding(8)
                                .background(selectedIcon == icon ? Color.purple.opacity(0.2) : Color.clear)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedIcon = icon
                                }
                        }
                    }
                }
                
                Section {
                    Button("Save Changes") {
                        let updatedIdea = Idea(
                            id: idea.id,
                            title: title,
                            description: description,
                            location: location,
                            duration: duration,
                            conditions: conditions,
                            icon: selectedIcon,
                            isFavorite: idea.isFavorite,
                            createdDate: idea.createdDate
                        )
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
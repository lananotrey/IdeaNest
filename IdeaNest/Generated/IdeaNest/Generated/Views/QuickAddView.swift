import SwiftUI

struct QuickAddView: View {
    @ObservedObject var ideaStore: IdeaStore
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var duration: TimeInterval = 3600 // 1 hour default
    @State private var conditions = ""
    @State private var selectedIcon = "lightbulb"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
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
                    Button(action: saveIdea) {
                        HStack {
                            Spacer()
                            Text("Save Idea")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.purple)
                    .foregroundColor(.white)
                }
            }
            .navigationTitle("Quick Add")
            .alert("Missing Information", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveIdea() {
        // Validation
        if title.isEmpty {
            alertMessage = "Please enter a title"
            showingAlert = true
            return
        }
        
        if description.isEmpty {
            alertMessage = "Please enter a description"
            showingAlert = true
            return
        }
        
        if location.isEmpty {
            alertMessage = "Please enter a location"
            showingAlert = true
            return
        }
        
        if conditions.isEmpty {
            alertMessage = "Please specify conditions"
            showingAlert = true
            return
        }
        
        // Create and save the idea
        let idea = Idea(
            title: title,
            description: description,
            location: location,
            duration: duration,
            conditions: conditions,
            icon: selectedIcon
        )
        
        ideaStore.addIdea(idea)
        
        // Reset form
        title = ""
        description = ""
        location = ""
        duration = 3600
        conditions = ""
        selectedIcon = "lightbulb"
    }
}
import SwiftUI

struct QuickAddView: View {
    @ObservedObject var ideaStore: IdeaStore
    @Binding var selectedTab: Int
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var duration: Double = 60
    @State private var conditions = ""
    @State private var selectedIcon = "lightbulb"
    @State private var showingSuccessAlert = false
    
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
                    VStack(alignment: .leading) {
                        Text("Duration (minutes): \(Int(duration))")
                        Slider(value: $duration, in: 5...480, step: 5)
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
                    .disabled(!isValidForm)
                }
            }
            .navigationTitle("Quick Add")
            .alert("Success!", isPresented: $showingSuccessAlert) {
                Button("OK") { }
            } message: {
                Text("Your idea has been saved successfully!")
            }
        }
    }
    
    private var isValidForm: Bool {
        !title.isEmpty && !description.isEmpty && !location.isEmpty && !conditions.isEmpty
    }
    
    private func saveIdea() {
        let idea = Idea(
            title: title,
            description: description,
            location: location,
            duration: TimeInterval(duration * 60),
            conditions: conditions,
            icon: selectedIcon
        )
        
        ideaStore.addIdea(idea)
        resetForm()
        showingSuccessAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            selectedTab = 0
        }
    }
    
    private func resetForm() {
        title = ""
        description = ""
        location = ""
        duration = 60
        conditions = ""
        selectedIcon = "lightbulb"
    }
}
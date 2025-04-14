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
    @State private var showingValidationAlert = false
    @State private var alertMessage = ""
    
    let icons = ["lightbulb", "star", "heart", "flag", "bookmark", "tag", "paperclip", "link", "clock", "calendar"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Title", text: $title)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(showingValidationAlert && title.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                        )
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(showingValidationAlert && description.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                        )
                }
                
                Section(header: Text("Location & Time")) {
                    TextField("Location", text: $location)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(showingValidationAlert && location.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                        )
                    VStack(alignment: .leading) {
                        Text("Duration (minutes): \(Int(duration))")
                        Slider(value: $duration, in: 5...480, step: 5)
                    }
                }
                
                Section(header: Text("Conditions")) {
                    TextEditor(text: $conditions)
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(showingValidationAlert && conditions.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                        )
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
                    Button(action: validateAndSave) {
                        HStack {
                            Spacer()
                            Text("Save Idea")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .listRowBackground(isValidForm ? Color.purple : Color.gray)
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
            .alert("Missing Information", isPresented: $showingValidationAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var isValidForm: Bool {
        !title.isEmpty && !description.isEmpty && !location.isEmpty && !conditions.isEmpty
    }
    
    private func validateAndSave() {
        var missingFields: [String] = []
        
        if title.isEmpty { missingFields.append("Title") }
        if description.isEmpty { missingFields.append("Description") }
        if location.isEmpty { missingFields.append("Location") }
        if conditions.isEmpty { missingFields.append("Conditions") }
        
        if !missingFields.isEmpty {
            alertMessage = "Please fill in the following required fields:\n" + missingFields.joined(separator: "\n")
            showingValidationAlert = true
            return
        }
        
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
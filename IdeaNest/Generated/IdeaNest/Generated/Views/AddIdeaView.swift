import SwiftUI

struct AddIdeaView: View {
    @ObservedObject var ideaStore: IdeaStore
    @Environment(\.dismiss) var dismiss
    @Binding var selectedTab: Int
    
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var duration: TimeInterval = 3600
    @State private var conditions = ""
    @State private var selectedIcon = "lightbulb"
    @State private var isFavorite = false
    @State private var showingAlert = false
    @State private var showingSuccessToast = false
    
    let icons = ["lightbulb", "star", "heart", "flag", "bookmark", "tag", "paperclip", "link", "clock", "calendar"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Title", text: $title)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(showingAlert && title.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                        )
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(showingAlert && description.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                        )
                }
                
                Section(header: Text("Location & Time")) {
                    TextField("Location", text: $location)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(showingAlert && location.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                        )
                    Picker("Duration", selection: $duration) {
                        Text("30 min").tag(TimeInterval(1800))
                        Text("1 hour").tag(TimeInterval(3600))
                        Text("2 hours").tag(TimeInterval(7200))
                        Text("4 hours").tag(TimeInterval(14400))
                        Text("8 hours").tag(TimeInterval(28800))
                    }
                }
                
                Section(header: Text("Conditions")) {
                    TextEditor(text: $conditions)
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(showingAlert && conditions.isEmpty ? Color.red : Color.clear, lineWidth: 1)
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
                    Toggle(isOn: $isFavorite) {
                        Label("Add to Favorites", systemImage: "star.fill")
                    }
                    .tint(.yellow)
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
            .navigationTitle("New Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
            .alert("Missing Information", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .overlay {
                if showingSuccessToast {
                    ToastView(message: "Idea saved successfully!")
                        .transition(.move(edge: .top))
                }
            }
        }
    }
    
    private var isValidForm: Bool {
        !title.isEmpty && !description.isEmpty && !location.isEmpty && !conditions.isEmpty
    }
    
    private var alertMessage: String {
        var missingFields: [String] = []
        
        if title.isEmpty { missingFields.append("Title") }
        if description.isEmpty { missingFields.append("Description") }
        if location.isEmpty { missingFields.append("Location") }
        if conditions.isEmpty { missingFields.append("Conditions") }
        
        return "Please fill in the following required fields:\n" + missingFields.joined(separator: "\n")
    }
    
    private func validateAndSave() {
        if !isValidForm {
            showingAlert = true
            return
        }
        
        let idea = Idea(
            title: title,
            description: description,
            location: location,
            duration: duration,
            conditions: conditions,
            icon: selectedIcon,
            isFavorite: isFavorite
        )
        
        ideaStore.addIdea(idea)
        showSuccessAndDismiss()
    }
    
    private func showSuccessAndDismiss() {
        withAnimation {
            showingSuccessToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showingSuccessToast = false
                selectedTab = 0
                dismiss()
            }
        }
    }
}
import Foundation
import SwiftUI

@MainActor
class IdeaStore: ObservableObject {
    @Published var ideas: [Idea] = []
    @Published var selectedTab = 0
    
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedIdeas")
    
    init() {
        loadIdeas()
    }
    
    func addIdea(_ idea: Idea) {
        ideas.insert(idea, at: 0)
        save()
    }
    
    func deleteIdea(_ idea: Idea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas.remove(at: index)
            save()
            ToastManager.shared.show(message: "Idea deleted successfully")
            selectedTab = 0
        }
    }
    
    func updateIdea(_ idea: Idea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index] = idea
            save()
            ToastManager.shared.show(message: "Idea updated successfully")
            selectedTab = 0
        }
    }
    
    func toggleFavorite(_ idea: Idea) {
        var updatedIdea = idea
        updatedIdea.isFavorite.toggle()
        updateIdea(updatedIdea)
    }
    
    private func loadIdeas() {
        do {
            let data = try Data(contentsOf: savePath)
            ideas = try JSONDecoder().decode([Idea].self, from: data)
        } catch {
            ideas = []
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(ideas)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save ideas: \(error.localizedDescription)")
        }
    }
}
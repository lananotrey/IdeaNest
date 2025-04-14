import Foundation

struct Idea: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var isFavorite: Bool
    var createdDate: Date
    
    init(id: UUID = UUID(), title: String, description: String, isFavorite: Bool = false, createdDate: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.isFavorite = isFavorite
        self.createdDate = createdDate
    }
}
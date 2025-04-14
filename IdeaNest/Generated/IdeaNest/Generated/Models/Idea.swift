import Foundation

struct Idea: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var isFavorite: Bool
    var createdDate: Date
    var location: String
    var duration: TimeInterval
    var conditions: String
    var icon: String
    
    init(id: UUID = UUID(), title: String, description: String, location: String, duration: TimeInterval, conditions: String, icon: String, isFavorite: Bool = false, createdDate: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.location = location
        self.duration = duration
        self.conditions = conditions
        self.icon = icon
        self.isFavorite = isFavorite
        self.createdDate = createdDate
    }
}
import SwiftUI

struct StatisticsView: View {
    @ObservedObject var ideaStore: IdeaStore
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("General Statistics") {
                    StatRow(title: "Total Ideas", value: "\(ideaStore.ideas.count)")
                    StatRow(title: "Favorite Ideas", value: "\(ideaStore.ideas.filter { $0.isFavorite }.count)")
                }
                
                Section("Time Statistics") {
                    StatRow(title: "Created Today", value: "\(ideasCreatedToday)")
                    StatRow(title: "Created This Week", value: "\(ideasCreatedThisWeek)")
                    StatRow(title: "Created This Month", value: "\(ideasCreatedThisMonth)")
                }
                
                Section("Content Statistics") {
                    StatRow(title: "Average Title Length", value: String(format: "%.1f characters", averageTitleLength))
                    StatRow(title: "Average Description Length", value: String(format: "%.1f characters", averageDescriptionLength))
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
    
    private var ideasCreatedToday: Int {
        ideaStore.ideas.filter { Calendar.current.isDateInToday($0.createdDate) }.count
    }
    
    private var ideasCreatedThisWeek: Int {
        ideaStore.ideas.filter { Calendar.current.isDate($0.createdDate, equalTo: Date(), toGranularity: .weekOfYear) }.count
    }
    
    private var ideasCreatedThisMonth: Int {
        ideaStore.ideas.filter { Calendar.current.isDate($0.createdDate, equalTo: Date(), toGranularity: .month) }.count
    }
    
    private var averageTitleLength: Double {
        guard !ideaStore.ideas.isEmpty else { return 0 }
        let totalLength = ideaStore.ideas.reduce(0) { $0 + $1.title.count }
        return Double(totalLength) / Double(ideaStore.ideas.count)
    }
    
    private var averageDescriptionLength: Double {
        guard !ideaStore.ideas.isEmpty else { return 0 }
        let totalLength = ideaStore.ideas.reduce(0) { $0 + $1.description.count }
        return Double(totalLength) / Double(ideaStore.ideas.count)
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
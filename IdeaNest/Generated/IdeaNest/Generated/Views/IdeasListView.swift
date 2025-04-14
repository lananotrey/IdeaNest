import SwiftUI

struct IdeasListView: View {
    @ObservedObject var ideaStore: IdeaStore
    @State private var showingAddSheet = false
    @State private var searchText = ""
    @State private var sortOption: SortOption = .dateDesc
    @State private var showingStats = false
    
    enum SortOption {
        case dateDesc, dateAsc, titleAsc, titleDesc
    }
    
    var filteredAndSortedIdeas: [Idea] {
        let filtered = ideaStore.ideas.filter { idea in
            searchText.isEmpty || 
            idea.title.localizedCaseInsensitiveContains(searchText) ||
            idea.description.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { first, second in
            switch sortOption {
            case .dateDesc:
                return first.createdDate > second.createdDate
            case .dateAsc:
                return first.createdDate < second.createdDate
            case .titleAsc:
                return first.title < second.title
            case .titleDesc:
                return first.title > second.title
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                statisticsBar
                
                ZStack {
                    if ideaStore.ideas.isEmpty {
                        EmptyStateView()
                    } else {
                        List {
                            ForEach(filteredAndSortedIdeas) { idea in
                                IdeaRowView(idea: idea, ideaStore: ideaStore)
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    ideaStore.deleteIdea(filteredAndSortedIdeas[index])
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search ideas...")
            .navigationTitle("My Ideas")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Picker("Sort by", selection: $sortOption) {
                            Text("Newest First").tag(SortOption.dateDesc)
                            Text("Oldest First").tag(SortOption.dateAsc)
                            Text("Title A-Z").tag(SortOption.titleAsc)
                            Text("Title Z-A").tag(SortOption.titleDesc)
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddIdeaView(ideaStore: ideaStore)
        }
        .sheet(isPresented: $showingStats) {
            StatisticsView(ideaStore: ideaStore)
        }
    }
    
    private var statisticsBar: some View {
        HStack {
            StatCard(title: "Total", value: "\(ideaStore.ideas.count)")
            StatCard(title: "Favorites", value: "\(ideaStore.ideas.filter { $0.isFavorite }.count)")
            StatCard(title: "This Month", value: "\(ideaStore.ideas.filter { Calendar.current.isDate($0.createdDate, equalTo: Date(), toGranularity: .month) }.count)")
        }
        .padding()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}
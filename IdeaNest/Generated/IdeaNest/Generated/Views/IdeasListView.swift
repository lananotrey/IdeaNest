import SwiftUI

struct IdeasListView: View {
    @ObservedObject var ideaStore: IdeaStore
    @State private var showingAddSheet = false
    @State private var searchText = ""
    @State private var sortOption: SortOption = .dateDesc
    @State private var showingStats = false
    @State private var showFavoritesOnly = false
    @State private var selectedTab = 0
    
    enum SortOption {
        case dateDesc, dateAsc, titleAsc, titleDesc
    }
    
    var filteredAndSortedIdeas: [Idea] {
        let filtered = ideaStore.ideas.filter { idea in
            let matchesSearch = searchText.isEmpty || 
                idea.title.localizedCaseInsensitiveContains(searchText) ||
                idea.description.localizedCaseInsensitiveContains(searchText)
            
            let matchesFavorite = !showFavoritesOnly || idea.isFavorite
            
            return matchesSearch && matchesFavorite
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
                
                Picker("Filter", selection: $showFavoritesOnly) {
                    Text("All Ideas").tag(false)
                    Text("Favorites").tag(true)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                ZStack {
                    if ideaStore.ideas.isEmpty {
                        EmptyStateView()
                    } else if filteredAndSortedIdeas.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No matching ideas found")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
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
                ToolbarItemGroup(placement: .navigationBarLeading) {
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
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
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
            AddIdeaView(ideaStore: ideaStore, selectedTab: $selectedTab)
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
//
//  SearchView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftData
import SwiftUI

struct SearchView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Query(sort: \MomentumEntry.date, order: .reverse) private var entries: [MomentumEntry]
    
    @State private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                WritingPaper()
                    .ignoresSafeArea()
                
                // Main content: either the search results or an empty state view
                mainContent
            }
            .navigationTitle("Search Entries")
            .searchable(text: $viewModel.searchText, prompt: "Search by text or mood")
            .onChange(of: viewModel.searchText) { _, _ in
                // Re-run the filter whenever the search text changes
                viewModel.filterEntries(allEntries: entries)
            }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        if viewModel.searchText.isEmpty {
            // Initial state before the user has typed anything
            ContentUnavailableView("Search Your Journal", systemImage: "magnifyingglass", description: Text("Find entries by typing a keyword, phrase, or mood (e.g., 'positive')."))
        } else if viewModel.filteredEntries.isEmpty {
            // State for when a search yields no results
            ContentUnavailableView.search(text: viewModel.searchText)
        } else {
            // Display the list of filtered entries
            List {
                ForEach(viewModel.filteredEntries) { entry in
                    TimelineEntry(entry: entry, isHovered: false) {
                        dependencies.navigation.presentedSheet = .entryDetail(entry: entry)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}


#Preview(traits: .previewData) {
    SearchView()
}


//
//  SearchViewModel.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/16/25.
//

import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class SearchViewModel {
    var searchText = ""
    var filteredEntries: [MomentumEntry] = []
    
    /// Filters entries based on the current search text.
    ///
    /// This method searches the `text` and `sentiment` of each entry. The search is case-insensitive.
    /// If the search text is empty, the filtered list will also be empty.
    /// - Parameter allEntries: An array of all `MomentumEntry` objects to be filtered.
    func filterEntries(allEntries: [MomentumEntry]) {
        if searchText.isEmpty {
            filteredEntries = []
        } else {
            let lowercasedQuery = searchText.lowercased()
            filteredEntries = allEntries.filter { entry in
                let textMatch = entry.detail.lowercased().contains(lowercasedQuery)
                let sentimentMatch = entry.sentiment.rawValue.lowercased().contains(lowercasedQuery)
                return textMatch || sentimentMatch
            }
        }
    }
}

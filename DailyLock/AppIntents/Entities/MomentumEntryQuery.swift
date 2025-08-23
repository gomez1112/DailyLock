//
//  MomentumEntryQuery.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents

@MainActor
/// Provides the logic for fetching and filtering `MomentumEntryEntity` objects for App Intents.
struct MomentumEntryQuery: EntityQuery, EntityStringQuery, EnumerableEntityQuery {
    @Dependency var dataService: DataService
    
    /// Finds entries by their unique `UUID`.
    func entities(for identifiers: [UUID]) async throws -> [MomentumEntryEntity] {
        try dataService.entryEntities(matching: #Predicate { identifiers.contains($0.id)})
    }
    
    /// Finds entries whose text contains the matching string.
    func entities(matching string: String) async throws -> [MomentumEntryEntity] {
        try dataService.entryEntities(matching: #Predicate {
            $0.text.localizedStandardContains(string)
        })
    }
    
    /// Provides a list of suggested entries when a user is building a shortcut.
    func suggestedEntities() async throws -> [MomentumEntryEntity] {
        // Suggest the 5 most recent entries
        try dataService.suggest5Entities()
    }
    
    func allEntities() async throws -> [MomentumEntryEntity] {
        try dataService.entryEntities()
    }
}


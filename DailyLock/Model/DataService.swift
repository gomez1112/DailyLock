//
//  DataService.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import Observation
import SwiftData

@Observable
final class DataService {
    
    let context: ModelContext
    
    init(container: ModelContainer) {
        context = container.mainContext
    }
    
    func save<T: PersistentModel>(_ model: T) {
        context.insert(model)
    }
    
    func delete<T: PersistentModel>(_ model: T) {
        context.delete(model)
    }
    
    func deleteAll(_ model: any PersistentModel.Type) throws {
        do {
            try context.delete(model: model)
        } catch {
            throw DatabaseError.deleteFailed
        }
    }
    
    func fetchAllEntries() throws -> [MomentumEntry] {
        let descriptor = FetchDescriptor<MomentumEntry>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func hasEntriesToday() throws -> Bool {
        (todayEntry(for: try fetchAllEntries()) != nil)
    }
    func entryCount() throws -> Int {
        try context.fetchCount(FetchDescriptor<MomentumEntry>())
    }
    // MARK: - Entry-Specific Operations
    
    /// Finds or creates today's entry and locks it with the provided text and sentiment.
    func lockEntry(text: String, sentiment: Sentiment, for allEntries: [MomentumEntry]) {
        if let entry = todayEntry(for: allEntries) {
            // Update existing entry
            entry.text = text
            entry.sentiment = sentiment
            entry.lockedAt = Date()
            entry.wordCount = text.split(separator: " ").count
        } else {
            // Create a new entry
            let newEntry = MomentumEntry(text: text, sentiment: sentiment, lockedAt: Date())
            context.insert(newEntry)
        }
    }
    
    /// Fetches the entry for today, if one exists.
    func todayEntry(for allEntries: [MomentumEntry]) -> MomentumEntry? {
        let today = Calendar.current.startOfDay(for: Date())
        return allEntries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
}

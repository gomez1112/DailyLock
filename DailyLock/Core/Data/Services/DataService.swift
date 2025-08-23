//
//  DataService.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import Observation
import SwiftData
import os

@Observable
final class DataService {
    
    let context: ModelContext
    
    init(container: ModelContainer) {
        context = container.mainContext
    }
    
    func save() {
        do {
            try context.save()
            Log.data.info("DataService: Context saved successfully after deletion")
        } catch {
            Log.data.error("DataService: Failed to save context after deletion: Error: \(error.localizedDescription)")
        }
    }
    func insert<T: PersistentModel>(_ model: T) {
        context.insert(model)
        save()
    }
    
    func delete<T: PersistentModel>(_ model: T) {
        Log.data.info("DataService: Attempting to delete Object....")
        context.delete(model)
        save()
    }
    
    func deleteAll(_ model: any PersistentModel.Type) throws {
        do {
            try context.delete(model: model)
        } catch {
            throw DatabaseError.deleteFailed
        }
        save()
    }
    
    func fetchAllEntries() throws -> [MomentumEntry] {
        let descriptor = FetchDescriptor<MomentumEntry>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func recent7Entries() throws -> [MomentumEntry] {
        var descriptor = FetchDescriptor<MomentumEntry>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        descriptor.fetchLimit = 7
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
    /// This function now fetches internally, simplifying the call site.
    func lockEntry(title: String, detail: String, sentiment: Sentiment) {
        let allEntries = (try? fetchAllEntries()) ?? []
        if let entry = todayEntry(for: allEntries) {
            // Update existing entry
            entry.title = title
            entry.detail = detail
            entry.sentiment = sentiment
            entry.lockedAt = Date()
            entry.wordCount = MomentumEntry.calculateWordCount(from: detail)
        } else {
            // Create a new entry
            let newEntry = MomentumEntry(title: title, detail: detail, sentiment: sentiment, lockedAt: Date())
            insert(newEntry)
        }
    }
    
    /// Fetches the entry for today, if one exists.
    func todayEntry(for allEntries: [MomentumEntry]) -> MomentumEntry? {
        let today = Calendar.current.startOfDay(for: Date())
        return allEntries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    func entryEntities(matching predicate: Predicate<MomentumEntry> = #Predicate { _ in true}, sortBy: [SortDescriptor<MomentumEntry>] = [SortDescriptor(\.date, order: .reverse)], limit: Int? = nil) throws -> [MomentumEntryEntity] {
        var entryDescriptor = FetchDescriptor<MomentumEntry>(predicate: predicate, sortBy: sortBy)
        entryDescriptor.fetchLimit = limit
        
        let fetchedEntries = try context.fetch(entryDescriptor)
        return fetchedEntries.map(MomentumEntryEntity.init)
    }
    
    func entryCount(matching predicate: Predicate<MomentumEntry> = #Predicate { _ in true}) throws -> Int {
        let entryDescriptor = FetchDescriptor<MomentumEntry>(predicate: predicate)
        return try context.fetchCount(entryDescriptor)
    }
    
    func select(entity: MomentumEntryEntity, navigation: NavigationContext) throws {
        let id = entity.id
        
        let results = try fetchAllEntries().filter { $0.id == id }
        
        if let result = results.first {
            navigation.presentedSheet = .entryDetail(entry: result)
        }
    }
    func suggest5Entities() throws -> [MomentumEntryEntity] {
        Array(try entryEntities().prefix(5))
    }
}


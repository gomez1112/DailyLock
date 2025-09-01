//
//  DataService+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import Foundation
import SwiftData

extension DataService {
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

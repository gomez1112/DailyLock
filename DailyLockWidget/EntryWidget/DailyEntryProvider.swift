//
//  DailyEntryProvider.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import AppIntents
import Foundation
import SwiftData
import WidgetKit

@MainActor
struct DailyEntryProvider: TimelineProvider {
    func placeholder(in context: Context) -> DailyEntry {
        DailyEntry(date: Date(), hasEntry: false, entry: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DailyEntry) -> Void) {
        let container = ModelContainerFactory.createSharedContainer
        let dataService = DataService(container: container)
        let entries = try? dataService.fetchAllEntries()
        let todayEntry = dataService.todayEntry(for: entries ?? [])
        
        let entry = DailyEntry(date: Date(), hasEntry: todayEntry != nil, entry: todayEntry)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<DailyEntry>) -> Void) {
        let container = ModelContainerFactory.createSharedContainer
        let dataService = DataService(container: container)
        let entries = try? dataService.fetchAllEntries()
        let todayEntry = dataService.todayEntry(for: entries ?? [])
        
        let entry = DailyEntry(
            date: Date(),
            hasEntry: todayEntry != nil,
            entry: todayEntry
        )
        
        // Update at midnight
        let tomorrow = Calendar.current.startOfDay(for: Date().addingTimeInterval(86400))
        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        
        completion(timeline)
    }
}

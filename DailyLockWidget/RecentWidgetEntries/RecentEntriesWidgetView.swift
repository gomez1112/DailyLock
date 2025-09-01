//
//  RecentEntriesWidgetView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/31/25.
//

import SwiftUI
import SwiftData
import WidgetKit
import AppIntents

// MARK: - View
struct RecentEntriesWidgetView: View {
    let entry: RecentEntriesTimelineEntry
    
    @Query(sort: [SortDescriptor(\MomentumEntry.date, order: .reverse)])
    private var allEntries: [MomentumEntry]
    
    var body: some View {
        let count = max(1, min(Int(entry.configuration.daysBack), 30))
        let recent = Array(allEntries.prefix(count))
        
        Group {
            if recent.isEmpty {
                ContentUnavailableView("No entries", systemImage: "tray")
            } else {
                RecentEntriesSnippetView(entries: Array(recent.prefix(3)))
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}


#Preview(as: .systemSmall) {
    RecentEntriesWidget()
} timeline: {
    let intent: RecentEntriesWidgetConfigurationIntent = {
        let i = RecentEntriesWidgetConfigurationIntent()
        i.daysBack = 7
        return i
    }()
    RecentEntriesTimelineEntry(date: Date(), configuration: intent)
}
#Preview(as: .systemLarge) {
    RecentEntriesWidget()
} timeline: {
    let intent: RecentEntriesWidgetConfigurationIntent = {
        let i = RecentEntriesWidgetConfigurationIntent()
        i.daysBack = 10
        return i
    }()
    RecentEntriesTimelineEntry(date: Date(), configuration: intent)
}

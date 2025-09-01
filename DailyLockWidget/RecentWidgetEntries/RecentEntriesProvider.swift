//
//  RecentEntriesProvider.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/31/25.
//

import WidgetKit

// MARK: - Provider
struct RecentEntriesProvider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> RecentEntriesTimelineEntry {
        RecentEntriesTimelineEntry(date: .now, configuration: .init())
    }
    
    func snapshot(for configuration: RecentEntriesWidgetConfigurationIntent, in context: Context) async -> RecentEntriesTimelineEntry {
        return(RecentEntriesTimelineEntry(date: .now, configuration: configuration))
    }
    
    func timeline(for configuration: RecentEntriesWidgetConfigurationIntent, in context: Context) -> Timeline<RecentEntriesTimelineEntry> {
        let entry = RecentEntriesTimelineEntry(date: .now, configuration: configuration)
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now.addingTimeInterval(1800)
        return Timeline(entries: [entry], policy: .after(nextRefresh))
       
    }
}

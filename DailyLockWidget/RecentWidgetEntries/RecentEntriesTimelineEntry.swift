//
//  RecentEntriesTimelineEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/31/25.
//

import WidgetKit
// MARK: - Timeline Entry
struct RecentEntriesTimelineEntry: TimelineEntry {
    let date: Date
    let configuration: RecentEntriesWidgetConfigurationIntent
}

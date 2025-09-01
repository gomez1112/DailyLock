//
//  RecentEntriesWidgetConfigurationIntent.swift
//  DailyLockWidget
//
//  Created by Assistant on 8/31/25.
//

import AppIntents

struct RecentEntriesWidgetConfigurationIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Recent Entries"
    static let description = IntentDescription("Configure how many recent entries to show.")
    
    @Parameter(title: "Number of Entries", default: 7, inclusiveRange: (1, 30))
    var daysBack: Int
}

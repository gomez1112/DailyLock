//
//  RecentEntriesWidget.swift
//  DailyLockWidget
//
//  Created by Assistant on 8/31/25.
//

import SwiftUI
import WidgetKit
import SwiftData
import AppIntents


// MARK: - Widget
struct RecentEntriesWidget: Widget {
    let kind: String = "RecentEntriesWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: RecentEntriesWidgetConfigurationIntent.self, provider: RecentEntriesProvider()) { entry in
            RecentEntriesWidgetView(entry: entry)
                .modelContainer(ModelContainerFactory.createSharedContainer)
        }
        .configurationDisplayName("Recent Entries")
        .description("See your latest journal entries at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

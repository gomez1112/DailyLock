//
//  DailyEntryWidget.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import AppIntents
import Foundation
import SwiftData
import WidgetKit
import SwiftUI


struct DailyEntryWidget: Widget {
    let kind: String = "DailyEntryWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyEntryProvider()) { entry in
            DailyLockEntryWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Today's Entry")
        .description("Track your daily journaling")
        .supportedFamilies([.systemSmall])
    }
}

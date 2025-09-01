//
//  MoodDistributionEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/30/25.
//

import WidgetKit


// MARK: - Entry
struct MoodDistributionEntry: TimelineEntry {
    let date: Date
    let configuration: MoodWidgetConfigurationIntent
    let counts: [Sentiment: Int]
    let total: Int
}

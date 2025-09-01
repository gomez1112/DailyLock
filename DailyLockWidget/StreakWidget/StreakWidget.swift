//
//  StreakWidget.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/24/25.
//

import AppIntents
import SwiftData
import SwiftUI
import WidgetKit

struct StreakWidget: Widget {

    let kind: String = "StreakWidget"
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: GetCurrentStreak.self, provider: StreakProvider()) { _ in
            StreakWidgetView()
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(ModelContainerFactory.createSharedContainer)
        }
        
        .configurationDisplayName("Writing Streak")
        .description("Track your consecutive days")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
    
}

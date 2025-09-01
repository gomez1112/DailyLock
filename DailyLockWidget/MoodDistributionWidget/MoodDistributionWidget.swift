//
//  MoodDistributionWidget.swift
//  DailyLockWidget
//
//  Created by Assistant on 8/30/25.
//

import SwiftUI
import WidgetKit
import AppIntents
import SwiftData


// MARK: - Widget
struct MoodDistributionWidget: Widget {
    static let kind = "com.transfinite.DailyLock.MoodDistributionWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: Self.kind,
            intent: MoodWidgetConfigurationIntent.self,
            provider: MoodDistributionProvider()
        ) { entry in
            MoodDistributionWidgetView(entry: entry)
        }
        .configurationDisplayName("Mood Patterns")
        .description("See your mood distribution at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}

// MARK: - Preview
#if DEBUG
struct MoodDistributionWidget_Previews: PreviewProvider {
    static var previews: some View {
        MoodDistributionWidgetView(entry: .init(
            date: .now,
            configuration: MoodWidgetConfigurationIntent(),
            counts: [.positive: 5, .indifferent: 3, .negative: 2],
            total: 10
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif

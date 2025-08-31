struct StreakWidget: Widget {
    let kind: String = "StreakWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: StreakIntent.self,
            provider: StreakProvider()
        ) { entry in
            StreakWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Writing Streak")
        .description("Track your consecutive days")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
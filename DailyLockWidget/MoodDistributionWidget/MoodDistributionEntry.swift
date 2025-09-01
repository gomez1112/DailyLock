// MARK: - Entry
struct MoodDistributionEntry: TimelineEntry {
    let date: Date
    let configuration: MoodWidgetConfigurationIntent
    let counts: [Sentiment: Int]
    let total: Int
}
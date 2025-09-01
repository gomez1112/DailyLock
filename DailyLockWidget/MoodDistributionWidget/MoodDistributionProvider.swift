//
//  MoodDistributionProvider.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/30/25.
//

import WidgetKit


// MARK: - Provider
struct MoodDistributionProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MoodDistributionEntry {
        MoodDistributionEntry(
            date: Date(),
            configuration: MoodWidgetConfigurationIntent(),
            counts: [.positive: 4, .indifferent: 2, .negative: 1],
            total: 7
        )
    }
    
    func snapshot(for configuration: MoodWidgetConfigurationIntent, in context: Context) async -> MoodDistributionEntry {
        await loadEntry(configuration: configuration)
    }
    
    func timeline(for configuration: MoodWidgetConfigurationIntent, in context: Context) async -> Timeline<MoodDistributionEntry> {
        let entry = await loadEntry(configuration: configuration)
        // Refresh hourly to stay light, and also when your app calls WidgetCenter.reloadAllTimelines()
        let next = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date().addingTimeInterval(3600)
        return Timeline(entries: [entry], policy: .after(next))
    }
    
    // MARK: Data Loading
    @MainActor
    private func loadEntry(configuration: MoodWidgetConfigurationIntent) async -> MoodDistributionEntry {
        // Reuse your shared container and DataService. App Group is already configured in your project.
        let container = ModelContainerFactory.createSharedContainer
        let service = DataService(container: container)
        
        // Fetch via your DataService and filter by range in-memory to maximize sharing.
        var entries: [MomentumEntry] = (try? service.fetchAllEntries()) ?? []
        if let start = configuration.range.startDateForFilter() {
            entries = entries.filter { $0.date >= start }
        }
        
        // Reuse your StatsCalculator to keep logic identical to the main app.
        let moodPairs = StatsCalculator.moodData(for: entries) // counts only locked entries
        var counts: [Sentiment: Int] = [:]
        moodPairs.forEach { counts[$0.sentiment] = $0.count }
        let total = counts.values.reduce(0, +)
        
        return MoodDistributionEntry(
            date: Date(),
            configuration: configuration,
            counts: counts,
            total: total
        )
    }
}

struct StreakProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(date: Date(), currentStreak: 7, longestStreak: 30, isInGracePeriod: false)
    }
    
    func snapshot(for configuration: StreakIntent, in context: Context) async -> StreakEntry {
        await fetchStreakData(allowGracePeriod: configuration.allowGracePeriod)
    }
    
    func timeline(for configuration: StreakIntent, in context: Context) async -> Timeline<StreakEntry> {
        let entry = await fetchStreakData(allowGracePeriod: configuration.allowGracePeriod)
        let tomorrow = Calendar.current.startOfDay(for: Date().addingTimeInterval(86400))
        return Timeline(entries: [entry], policy: .after(tomorrow))
    }
    
    private func fetchStreakData(allowGracePeriod: Bool) async -> StreakEntry {
        let container = ModelContainerFactory.createSharedContainer
        let dataService = DataService(container: container)
        let entries = try? dataService.fetchAllEntries() ?? []
        
        let streakInfo = StreakCalculator.calculateStreak(
            from: entries ?? [],
            allowGracePeriod: allowGracePeriod
        )
        
        let longestStreak = StreakCalculator.calculateLongestStreak(
            for: entries ?? [],
            allowGracePeriod: allowGracePeriod
        )
        
        return StreakEntry(
            date: Date(),
            currentStreak: streakInfo.count,
            longestStreak: longestStreak,
            isInGracePeriod: streakInfo.isGracePeriodActiveNow
        )
    }
}
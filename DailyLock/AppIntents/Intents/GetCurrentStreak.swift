//
//  GetCurrentStreak.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
import SwiftUI

struct GetCurrentStreak: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Get Current Streak"
    static let description = IntentDescription("Check your current journaling streak.")
    
    
    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        let dataService = DataService(container: ModelContainerFactory.createSharedContainer)
        let syncedSetting = SyncedSetting()
        let entries = try dataService.fetchAllEntries()
        let streakInfo = StreakCalculator.calculateStreak(from: entries, allowGracePeriod: syncedSetting.allowGracePeriod)
        
        let snippet = StreakAchievementView(streakCount: streakInfo.count)
        
        return .result(view: snippet)
    }
}

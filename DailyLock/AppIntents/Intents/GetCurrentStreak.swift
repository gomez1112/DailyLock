//
//  GetCurrentStreak.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
import SwiftUI

struct GetCurrentStreak: AppIntent {
    static let title: LocalizedStringResource = "Get Current Streak"
    static let description = IntentDescription("Check your current journaling streak.")
    
    @Dependency private var dataService: DataService
    @Dependency private var syncedSetting: SyncedSetting
    
    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        
        let entries = try dataService.fetchAllEntries()
        let streakInfo = StreakCalculator.calculateStreak(from: entries, allowGracePeriod: syncedSetting.allowGracePeriod)
    
        let snippet = StreakAchievementView(streakCount: streakInfo.count)

        return .result(view: snippet)
    }
}

//
//  StreakProvider.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/24/25.
//

import AppIntents
import SwiftData
import WidgetKit

// StreakProvider.swift
@MainActor
struct StreakProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(
            date: Date(),
            currentStreak: 7,
            longestStreak: 30,
            isInGracePeriod: false,
        )
    }
    
    func snapshot(for configuration: GetCurrentStreak, in context: Context) async -> StreakEntry {
        if context.isPreview {
            // Return sample data for previews
            return StreakEntry(
                date: Date(),
                currentStreak: 7,
                longestStreak: 30,
                isInGracePeriod: false,
            )
        }
        return fetchStreakData()
    }
    
    func timeline(for configuration: GetCurrentStreak, in context: Context) async -> Timeline<StreakEntry> {
        Timeline(entries: [StreakEntry(
            date: Date(),
            currentStreak: 7,
            longestStreak: 30,
            isInGracePeriod: false,
        )], policy: .never)
    }
    
    private func fetchStreakData() -> StreakEntry {
        do {
            let context = ModelContainerFactory.createSharedContainer.mainContext
            let descriptor = FetchDescriptor<MomentumEntry>()
            let entries = try context.fetch(descriptor)
            
            print("Widget: Fetched \(entries.count) entries")
            
            // Calculate streak
            let streakInfo = StreakCalculator.calculateStreak(from: entries)
            let longestStreak = StreakCalculator.calculateLongestStreak(for: entries)
            
            return StreakEntry(
                date: Date(),
                currentStreak: streakInfo.count,
                longestStreak: longestStreak,
                isInGracePeriod: streakInfo.isGracePeriodActiveNow
            )
        } catch {
            print("Widget Error: \(error)")
            // Return placeholder data on error
            return StreakEntry(
                date: Date(),
                currentStreak: 0,
                longestStreak: 0,
                isInGracePeriod: false
            )
        }
    }
}

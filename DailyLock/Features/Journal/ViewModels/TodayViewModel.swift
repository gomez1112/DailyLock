//
//  TodayViewModel.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/4/25.
//


import Foundation
import Observation
import os

@Observable
final class TodayViewModel {
    
    private let dataService: DataService
    private let haptics: HapticEngine
    private let syncedSetting: SyncedSetting
    
    init(dataService: DataService, haptics: HapticEngine, syncedSetting: SyncedSetting) {
        self.dataService = dataService
        self.haptics = haptics
        self.syncedSetting = syncedSetting
    }
    // MARK: - UI State
    var title = ""
    var currentDetail = ""
    var selectedSentiment: Sentiment = .indifferent
    var inkOpacity: Double = DesignSystem.Text.inkOpacity
    var showLockConfirmation = false
    var showConfetti = false
    var showStreakAchievement = false
    var currentStreak = 0
    var isInGracePeriod = false
    var hasUsedGrace = false
    
    // MARK: - Computed Properties (Pure functions)
    var characterCount: Int { currentDetail.count }
    var progressToLimit: Double { min(Double(characterCount) / Double(DesignSystem.Text.maxCharacterCount), 1.0) }
    var canLock: Bool { characterCount > 0 && characterCount <= DesignSystem.Text.maxCharacterCount }
    var allowGracePeriod: Bool { syncedSetting.allowGracePeriod }
    // MARK: - Pure Functions for UI Logic
    
    func updateInkOpacity() {
        inkOpacity = min(Double(currentDetail.count) / DesignSystem.Text.inkOpacityMaxDenominator, 1.0)
    }
    
    func progressColor(progress: Double, isDark: Bool) -> ProgressColorStyle {
        if progress > 0.9 {
            return .red
        } else if progress > 0.7 {
            return .orange
        } else {
            return isDark ? .darkLine : .lightLine
        }
    }
    
    func loadExistingEntry(_ entry: MomentumEntry) {
        currentDetail = entry.detail
        selectedSentiment = entry.sentiment
        updateInkOpacity()
    }
    
    func updateStreakInfo(_ streakInfo: StreakInfo) {
        currentStreak = streakInfo.count
        isInGracePeriod = streakInfo.isGracePeriodActiveNow
        hasUsedGrace = streakInfo.gracePeriodUsed
    }
    
    func shouldShowAchievement(oldStreak: Int, newStreak: Int) -> Bool {
        return newStreak > oldStreak &&
        newStreak >= AppAchievements.streakMilestone &&
        newStreak % 3 == 0
    }
    
    func triggerAchievementAnimation() {
        showConfetti = true
        showStreakAchievement = true
        
        Task {
            try? await Task.sleep(for: .seconds(5))
            await MainActor.run { self.showConfetti = false }
        }
        Task {
            try? await Task.sleep(for: .seconds(3.5))
            await MainActor.run { self.showStreakAchievement = false }
        }
    }
    
    func reset() {
        title = ""
        currentDetail = ""
        selectedSentiment = .indifferent
        inkOpacity = DesignSystem.Text.inkOpacity
        showLockConfirmation = false
    }
    func todayEntry(entries: [MomentumEntry]) -> MomentumEntry? {
        let today = Calendar.current.startOfDay(for: Date())
        return entries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    func loadViewModelState(entries: [MomentumEntry]) {
        // Load existing entry if it exists
        if let existingEntry = todayEntry(entries: entries), !existingEntry.isLocked {
            loadExistingEntry(existingEntry)
        }
        
        // Update streak info
        updateStreakInfo(entries: entries)
    }
    
    func updateStreakInfo(entries: [MomentumEntry]) {
        let streakInfo = StreakCalculator.calculateStreak(
            from: entries,
            allowGracePeriod: allowGracePeriod
        )
        updateStreakInfo(streakInfo)
    }
    
    /// This is the new function that will be called from the View's onChange modifier.
    /// It compares the streak before and after the data changes to decide if an achievement should be shown.
    func processEntriesUpdate(newEntries: [MomentumEntry]) {
        let oldStreak = self.currentStreak
        self.updateStreakInfo(entries: newEntries)
        let newStreak = self.currentStreak
        
        if shouldShowAchievement(oldStreak: oldStreak, newStreak: newStreak) {
            triggerAchievementAnimation()
        }
    }
    
    /// This function is now simplified. Its only job is to save the data.
    /// The UI will react to the data change via the @Query property wrapper.
    func handleEntryLock() {
        dataService.lockEntry(title: title, detail: currentDetail, sentiment: selectedSentiment)
        haptics.lock()
        haptics.success()
    }
    
    private func extractKeywords(from text: String) -> [String] {
        // Simple keyword extraction - in production, you might use NLP
        let words = text.components(separatedBy: .whitespacesAndNewlines)
            .filter { $0.count > 4 } // Only words with more than 4 characters
            .prefix(5) // Take top 5 words
        
        return Array(words)
    }
    enum ProgressColorStyle {
        case red
        case orange
        case darkLine
        case lightLine
    }
}

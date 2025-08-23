//
//  DailyLockShortcuts.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents

struct DailyLockShortcuts: AppShortcutsProvider {
    
    static let shortcutTileColor: ShortcutTileColor = .purple
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartNewEntry(),
            phrases: [
                "Start my entry in \(.applicationName)",
                "Write in \(.applicationName)"],
            shortTitle: "New Entry",
            systemImageName: "pencil.tip"
        )
        
        AppShortcut(
            intent: LockTodaysEntry(),
            phrases: ["Lock my entry in \(.applicationName)"],
            shortTitle: "Lock Entry",
            systemImageName: "lock.fill"
        )
        
        AppShortcut(
            intent: GetCurrentStreak(),
            phrases: [
                "What is my streak in \(.applicationName)?",
                "Check my \(.applicationName) streak"],
            shortTitle: "Current Streak",
            systemImageName: "flame.fill"
        )
        
        AppShortcut(
            intent: ReadEntry(),
            phrases: ["Read my entry in \(.applicationName)"],
            shortTitle: "Read Entry",
            systemImageName: "book.pages"
        )
        
        AppShortcut(
            intent: GenerateWeeklySummary(),
            phrases: ["Generate weekly summary in \(.applicationName)"],
            shortTitle: "Generate Weekly Summary",
            systemImageName: "sparkles")
        
        AppShortcut(
            intent: LeaveATip(),
            phrases: ["Leave a tip in \(.applicationName)"],
            shortTitle: "Leave a Tip",
            systemImageName: "hand.thumbsup")
        
        AppShortcut(
            intent: ViewRecentEntriesIntent(),
            phrases: ["View recent entries in \(.applicationName)"],
            shortTitle: "View Recent Entries",
            systemImageName: "list.bullet")
        AppShortcut(
            intent: CheckMoodDistributionIntent(),
            phrases: ["Check mood distribution in \(.applicationName)"],
            shortTitle: "Check Mood Distribution",
            systemImageName: "chart.bar")
        
        AppShortcut(
            intent: SummarizeJournal(),
            phrases: ["Summarize my journal in \(.applicationName)"],
            shortTitle: "Summarize Journal",
            systemImageName: "book.fill")
        
        AppShortcut(
            intent: OpenEntryIntent(),
            phrases: ["Open entry in \(.applicationName)"],
            shortTitle: "Open Entry",
            systemImageName: "book.fill")
    }
}

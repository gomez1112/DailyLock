// DebugSetup.swift
// Contains logic for debug/test arguments & setup extracted from DailyLockApp

import Foundation
import SwiftData

/// `DebugSetup` provides utility functions to configure and manipulate the app's data model and user defaults
/// for debugging and UI testing scenarios. It enables the injection of mock data, the resetting of persistent
/// state, and the customization of app behavior based on command line arguments.
///
/// - Note: All logic within this struct is only active when building the app in DEBUG mode.
struct DebugSetup {
    
    /// Applies debug and testing behaviors to the app based on the provided command line arguments.
    ///
    /// This function modifies the application's persistent state and user defaults to facilitate specific
    /// debug or UI testing scenarios. Depending on which flags are present in the `arguments` array,
    /// it can:
    /// - Reset all `MomentumEntry` data and insert two consecutive days of sample entries ("two-day-streak").
    /// - Clear all `MomentumEntry` data for an empty state ("No data").
    /// - Reset onboarding state to show onboarding on next launch ("-resetOnboarding").
    /// - Mark onboarding as completed to skip onboarding ("skipOnboarding").
    ///
    /// - Parameters:
    ///   - arguments: The list of command line arguments (e.g., from `CommandLine.arguments`) used to determine
    ///     which debug actions to apply.
    ///   - container: The `ModelContainer` instance whose main context will be manipulated for inserting or
    ///     deleting mock data entries.
    ///
    /// - Note: This method is only active and has effect when building in DEBUG mode. In release builds,
    ///   it has no effect.
    static func applyDebugArguments(_ arguments: [String], container: ModelContainer) {
        #if DEBUG
        if arguments.contains("two-day-streak") {
            try? container.mainContext.delete(model: MomentumEntry.self)
            let calendar = Calendar.current
            let today = Date()
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            let beforeYesterday = calendar.date(byAdding: .day, value: -2, to: today)!
            let yesterdayEntry = MomentumEntry(date: yesterday, text: "Yesterday's entry", lockedAt: yesterday)
            let beforeYesterdayEntry = MomentumEntry(date: beforeYesterday, text: "Day before's entry", lockedAt: beforeYesterday)
            container.mainContext.insert(yesterdayEntry)
            container.mainContext.insert(beforeYesterdayEntry)
        }
        if arguments.contains("No data") {
            try? container.mainContext.delete(model: MomentumEntry.self)
        }
        if arguments.contains("-resetOnboarding") {
            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        }
        if arguments.contains("skipOnboarding") {
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        }
        #endif
    }
}

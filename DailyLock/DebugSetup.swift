// DebugSetup.swift
// Contains logic for debug/test arguments & setup extracted from DailyLockApp

import Foundation
import SwiftData

struct DebugSetup {
    static func configureContainer(for arguments: [String]) -> ModelContainer {
        #if DEBUG
        if arguments.contains("enable-testing") {
            return ModelContainerFactory.createPreviewContainer()
        } else {
            return ModelContainerFactory.createSharedContainer()
        }
        #else
        return ModelContainerFactory.createSharedContainer()
        #endif
    }
    
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

//
//  StartNewEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
/// Opens the app to the Today screen to begin writing a new entry.
struct StartNewEntry: AppIntent {
    static let title: LocalizedStringResource = "Start New Entry"
    static let description = IntentDescription("Opens DailyLock to the Today screen to write a new entry.")
    
    static let openAppWhenRun: Bool = true
    
    @Dependency var navigation: NavigationContext
    
    @MainActor
    func perform() async throws -> some IntentResult {
        navigation.navigate(to: .today)
        return .result()
    }
}

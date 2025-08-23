//
//  OpenEntryIntent.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents

struct OpenEntryIntent: OpenIntent {
    static let title: LocalizedStringResource = "Open Entry"
    
    
    @Dependency private var navigation: NavigationContext
    @Dependency private var dataService: DataService
    
    @Parameter(title: "Entry")
    var target: MomentumEntryEntity
    
    @MainActor
    func perform() async throws -> some IntentResult {
        try dataService.select(entity: target, navigation: navigation)
        return .result()
    }
}

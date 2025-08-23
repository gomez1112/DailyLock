//
//  GenerateWeeklySummary.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents

/// Generates and returns an AI-powered summary of the last 7 days of entries.
struct GenerateWeeklySummary: AppIntent {
    
    static let title: LocalizedStringResource = "Generate Weekly Summary"
    static let description = IntentDescription("Uses AI to generate a summary of your last 7 days of entries. Requires DailyLock+.")
    
    @Dependency private var dataService: DataService
    @Dependency private var store: Store
    @Dependency private var errorState: ErrorState
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        
        guard store.hasUnlockedPremium else {
            return .result(value: "No lifetime or subscription.", dialog: "You do not have the lifetime premium or the subscription. Try subscribing for more features!")
        }
        
        
        let last7entries = try dataService.fetchAllEntries().prefix(7)
        let generator = InsightGenerator(entries: Array(last7entries))
        
        if last7entries.isEmpty {
            return .result(value: "No entries found. Try adding some entries to get started!", dialog: "No entries found. Try adding some entries to get started!")
        }
        
        try await generator.suggestWeeklyInsight()
        
        
        guard let summary = generator.insight?.summary else {
            errorState.showIntentError(.generationFailed)
            throw IntentError.generationFailed
        }
        
        return .result(value: summary, dialog: "Here is your weekly summary: \(summary)")
    }
}

//
//  SummarizeJournal.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
import Foundation


struct SummarizeJournal: AppIntent {
    static let title: LocalizedStringResource = "Summarize Journal"
    static let description = IntentDescription("Summarizes your journal", categoryName: "Stats tracking", searchKeywords: ["journal", "stats", "tracking"], resultValueName: "Journal Statistics")
    
    @Dependency private var dataService: DataService
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog & ReturnsValue<JournalStatisticsSummary> {
        let entries = try dataService.fetchAllEntries()
        
        let stats = StreakCalculator.journalStatistics(for: entries)
        if entries.isEmpty {
            return .result(value: stats, dialog: "You have no entries")
        } else {
            let dialog = IntentDialog("You completed \(stats.totalEntries) entries \(stats.summaryStartDateFormatted). Incredible!")
            return .result(value: stats, dialog: dialog)
        }
    }
}

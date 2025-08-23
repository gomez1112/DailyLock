//
//  LockTodaysEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
/// Creates and locks a new journal entry with the provided text and sentiment.
struct LockTodaysEntry: AppIntent {
    static let title: LocalizedStringResource = "Lock Today's Entry"
    static let description = IntentDescription("Creates and locks a new journal entry for today without opening the app.")
    
    @Parameter(title: "Title", requestValueDialog: "What is your title?")
    var title: String
    
    @Parameter(title: "Detail", requestValueDialog: "What would you like to write?")
    var detail: String
    
    @Parameter(title: "Sentiment")
    var sentiment: Sentiment
    
    static var parameterSummary: some ParameterSummary {
        Summary("Lock my entry saying \(\.$detail) with a \(\.$sentiment) mood")
    }
    
    @Dependency var dataService: DataService
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        
        let entries = try dataService.fetchAllEntries()
        
        if dataService.todayEntry(for: entries) != nil {
            return .result(dialog: "Today's entry is already locked. You can only write one entry per day.")
        } else {
            dataService.lockEntry(title: title, detail: detail, sentiment: sentiment)
            return .result(dialog: "Your entry has been locked.")
        }
        
    }
}

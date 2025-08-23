//
//  ReadEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
import SwiftUI


/// Reads a specific journal entry from a given date.
struct ReadEntry: AppIntent {
    static let title: LocalizedStringResource = "Read Entry From Date"
    static let description = IntentDescription("Reads or displays the journal entry from a specific date.")
    
    @Parameter(title: "Date", requestValueDialog: "Which date would you like to read?")
    var date: Date
    
    static var parameterSummary: some ParameterSummary {
        Summary("Read my entry from \(\.$date)")
    }
    @Dependency private var dataService: DataService
    @Dependency private var errorState: ErrorState
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<MomentumEntryEntity> & ProvidesDialog {
        
        let allEntries = try dataService.fetchAllEntries()
        let calendar = Calendar.current
        
        if allEntries.isEmpty {
            return .result(value: MomentumEntryEntity(from: MomentumEntry()), dialog: "You have no entries yet.")
        }
        guard let entry = allEntries.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) else {
            errorState.showIntentError(.noEntryFound)
            throw IntentError.noEntryFound
        }
        
        return .result(
            value: MomentumEntryEntity(from: entry),
            dialog: "On \(entry.date.formatted(date: .long, time: .omitted)), you wrote: \(entry.detail)"
        )
    }
}


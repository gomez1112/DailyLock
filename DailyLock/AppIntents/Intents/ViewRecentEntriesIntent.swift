//
//  ViewRecentEntriesIntent.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
import SwiftUI

struct ViewRecentEntriesIntent: AppIntent {
    static let title: LocalizedStringResource = "View Recent Entries"
    static let description = IntentDescription("See your recent journal entries")
    
    @Parameter(title: "Number of Days", default: 7, inclusiveRange: (1, 30))
    var daysBack: Int
    
    @Dependency
    private var dataService: DataService
    
    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        let entries = try dataService.recent7Entries()
        
        let unavailableView = ContentUnavailableView("No entries", systemImage: "tray")
        if entries.isEmpty {
            return .result(view: unavailableView)
        }
        
        return .result(view: RecentEntriesSnippetView(entries: entries))
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Show entries from the last 7 days")
    }
}

//
//  CheckMoodDistributionIntent.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
import SwiftUI

struct CheckMoodDistributionIntent: AppIntent {
    static let title: LocalizedStringResource = "Check Mood Patterns"
    static let description = IntentDescription("See your mood distribution over time")
    
    @Dependency
    private var dataService: DataService
    
    @MainActor
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        
        let entries = try dataService.fetchAllEntries()
        
        let unavailableView = ContentUnavailableView {
            Label("Keep Writing", systemImage: "chart.line.uptrend.xyaxis")
        } description: {
            VStack {
                Text("You need at least 1 entries to see insights")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .accessibilityIdentifier("entriesNeededText")
            }
        }
        
        if entries.isEmpty {
            return .result(view: unavailableView)
        }
        
        return .result(view: MoodDistributionCard(entries: entries))
    }
}

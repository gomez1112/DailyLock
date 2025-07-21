//
//  MomentumEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import SwiftData

@Model
final class MomentumEntry {
    var date = Date()
    var text = ""
    var sentiment = Sentiment.negative
    var lockedAt: Date?
    var wordCount = 0
    var topKeywords: [String]?
    var inkColor = "#1a1a1a"
    
    init(date: Date = Date(), text: String = "", sentiment: Sentiment = .neutral) {
        self.date = Calendar.current.startOfDay(for: date)
        self.text = text
        self.sentiment = sentiment
        self.wordCount = text.split(separator: " ").count
        self.inkColor = ["#1a1a1a", "#2c3e50", "#34495e", "#16213e"].randomElement()!
        self.topKeywords = nil
        self.lockedAt = nil
    }
    
    
    
    var isLocked: Bool {
        lockedAt != nil
    }
    
    var displayDate: String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        return date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
    }
    
    static var samples: [MomentumEntry] {
        [
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 30*2), text: "Lost motivation and skipped tasks.", sentiment: .neutral),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 9), text: "Started a new book and learned something insightful.", sentiment: .positive),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 8), text: "Work was challenging but I managed the stress.", sentiment: .neutral),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 7), text: "Felt under the weather today, stayed in mostly.", sentiment: .negative),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 6), text: "Had an energizing workout in the morning!", sentiment: .positive),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 5), text: "Productive day with a few interruptions.", sentiment: .neutral),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 4), text: "Argued with a friend, feeling regretful.", sentiment: .negative),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 3), text: "Tried a new recipe, it was delicious!", sentiment: .positive),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 2), text: "Average day, nothing much to note.", sentiment: .neutral),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 1), text: "Lost motivation and skipped tasks.", sentiment: .negative)
        ]
    }
}

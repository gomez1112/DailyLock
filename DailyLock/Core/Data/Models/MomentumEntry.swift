//
//  MomentumEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import SwiftData

typealias MomentumEntry = MomentumEntrySchemaV1.MomentumEntry

enum MomentumEntrySchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [MomentumEntry.self]
    }
    
    @Model
    final class MomentumEntry: Identifiable {
        var id = UUID()
        
        @Attribute(.spotlight)
        var date = Date()
        
        @Attribute(.spotlight)
        var title = ""
        
        @Attribute(.spotlight)
        var detail = ""
        
        var sentiment = Sentiment.indifferent
        
        @Attribute(.spotlight)
        var lockedAt: Date?
        
        @Attribute(.spotlight)
        var wordCount = 0
        
        @Attribute(.spotlight)
        var topKeywords: [String]?
        
        var inkColor = "#1a1a1a"
        
        init(id: UUID = UUID(), date: Date = Date(), title: String = "", detail: String = "", sentiment: Sentiment = Sentiment.indifferent, lockedAt: Date? = nil) {
            self.id = id
            self.date = Calendar.current.startOfDay(for: date)
            self.title = title
            self.detail = detail
            self.sentiment = sentiment
            self.lockedAt = lockedAt
            self.wordCount = Self.calculateWordCount(from: detail)
            self.inkColor = Self.getRandomInkColor()
            self.topKeywords = nil
        }
        
        var isLocked: Bool { lockedAt != nil }
        
        var displayDate: String {
            if Calendar.current.isDateInToday(date) { return "Today" } else if Calendar.current.isDateInYesterday(date) { return "Yesterday" }
            return date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
        }

        static func calculateWordCount(from text: String) -> Int {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return 0 }
            
            // Use NSString's word enumeration for accurate count
            var wordCount = 0
            let range = NSRange(location: 0, length: trimmed.utf16.count)
            let options: NSString.EnumerationOptions = [
                .byWords,
                .localized
            ]
            
            (trimmed as NSString).enumerateSubstrings(
                in: range,
                options: options
            ) { _, _, _, _ in
                wordCount += 1
            }
            
            return wordCount
        }
        static func getRandomInkColor() -> String {
            let colors = ["#1a1a1a", "#2c3e50", "#34495e", "#16213e"]
            return colors.randomElement() ?? "#1a1a1a"  // Provide default instead of force unwrap
        }
        static var samples: [MomentumEntry] {
            [
                MomentumEntry(date: Date().addingTimeInterval(-86400 * 30*2), title: "Saturday", detail: "Lost motivation and skipped tasks.", sentiment: .indifferent, lockedAt: Date().addingTimeInterval(-86400 * 30*2)),
                MomentumEntry(date: Date().addingTimeInterval(-86400 * 9), detail: "Started a new book and learned something insightful.", sentiment: .positive, lockedAt: Date().addingTimeInterval(-86400 * 9)),
                MomentumEntry(date: Date().addingTimeInterval(-86400 * 8), detail: "Work was challenging but I managed the stress.", sentiment: .indifferent,lockedAt: Date().addingTimeInterval(-86400 * 8)),
                MomentumEntry(date: Date().addingTimeInterval(-86400 * 7), detail: "Felt under the weather today, stayed in mostly.", sentiment: .negative, lockedAt: Date().addingTimeInterval(-86400 * 7)),
                MomentumEntry(date: Date().addingTimeInterval(-86400 * 6), detail: "Had an energizing workout in the morning!", sentiment: .positive, lockedAt: Date().addingTimeInterval(-86400 * 6)),
                MomentumEntry(date: Date().addingTimeInterval(-86400 * 5), detail: "Productive day with a few interruptions.", sentiment: .indifferent, lockedAt: Date().addingTimeInterval(-86400 * 5)),
                MomentumEntry(date: Date().addingTimeInterval(-86400 * 4), detail: "Argued with a friend, feeling regretful.", sentiment: .negative, lockedAt: Date().addingTimeInterval(-86400 * 4)),
                MomentumEntry(date: Date().addingTimeInterval(-86400 * 3), detail: "Tried a new recipe, it was delicious!", sentiment: .positive, lockedAt: Date().addingTimeInterval(-86400 * 3)),
                MomentumEntry(date: Date().addingTimeInterval(-86400 * 2), detail: "Average day, nothing much to note.", sentiment: .indifferent, lockedAt: Date().addingTimeInterval(-86400 * 2)),
                MomentumEntry(date: Date().addingTimeInterval(-86400 * 1), title: "Saturday", detail: "Lost motivation and skipped tasks.", sentiment: .negative, lockedAt: Date().addingTimeInterval(-86400 * 1)),
                MomentumEntry(date: Date(), title: "Saturday", detail: "Lost motivation and skipped tasks.", sentiment: .negative, lockedAt: Date.now)
            ]
        }
    }
}


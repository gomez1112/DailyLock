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
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [MomentumEntry.self]
    }
    
    @Model
    final class MomentumEntry: Identifiable {
        var id = UUID()
        var date = Date()
        var text = ""
        var sentiment = Sentiment.indifferent
        var lockedAt: Date?
        var wordCount = 0
        var topKeywords: [String]?
        var inkColor = "#1a1a1a" 
        
        init(date: Date = Date(), text: String = "", sentiment: Sentiment = Sentiment.indifferent, lockedAt: Date? = nil) {
            self.date = Calendar.current.startOfDay(for: date)
            self.text = text
            self.sentiment = sentiment
            self.lockedAt = lockedAt
            self.wordCount = Self.calculateWordCount(from: text)
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
    }
}

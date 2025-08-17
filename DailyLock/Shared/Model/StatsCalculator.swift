//
//  StatsCalculator.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/4/25.
//

import Foundation

struct StatsCalculator {
    
    // This function is already excellent. No changes needed.
    static func moodData(for entries: [MomentumEntry]) -> [(sentiment: Sentiment, count: Int)] {
        
        var counts: [Sentiment: Int] = [:]
        for entry in entries where entry.isLocked {
            counts[entry.sentiment, default: 0] += 1
        }
        return Sentiment.allCases.map { sentiment in
            (sentiment, counts[sentiment] ?? 0)
        }
    }
    
    // This function has been improved for safety and performance.
    static func entriesByMonth(for entries: [MomentumEntry]) -> [(month: Date, count: Int)] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        // Improvement: Use `reduce(into:)` for a single, efficient pass over the entries.
        let countsByMonth: [Int: Int] = entries.reduce(into: [:]) { (counts, entry) in
            let year = calendar.component(.year, from: entry.date)
            // Only count entries from the current year.
            if year == currentYear {
                let month = calendar.component(.month, from: entry.date)
                counts[month, default: 0] += 1
            }
        }
        
        // Improvement: Use `compactMap` to safely create dates without force unwrapping.
        return (1...12).compactMap { monthIndex in
            let components = DateComponents(year: currentYear, month: monthIndex, day: 1)
            guard let date = calendar.date(from: components) else {
                // This will safely skip the month if date creation ever fails.
                return nil
            }
            let count = countsByMonth[monthIndex] ?? 0
            return (month: date, count: count)
        }
    }
}

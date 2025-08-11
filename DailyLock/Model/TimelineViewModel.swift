//
//  TimelineViewModel.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/4/25.
//

import Foundation
import Observation

@Observable
final class TimelineViewModel {
    
    // MARK: - UI State Only
    var selectedEntry: MomentumEntry?
    var hoveredDate: Date?
    var expandedMonths: Set<String> = []
    
    // MARK: - Cached computed values
    private var cachedGroupedEntries: [(key: String, value: [MomentumEntry])]?
    private var lastEntriesHash: Int = 0
    
    // MARK: - Pure Functions
    
    func toggleMonth(_ month: String) {
        if expandedMonths.contains(month) {
            expandedMonths.remove(month)
        } else {
            expandedMonths.insert(month)
        }
    }
    
    func setHoveredEntry(_ entry: MomentumEntry?) {
        hoveredDate = entry?.date
    }
    
    func groupedEntries(for entries: [MomentumEntry]) -> [(key: String, value: [MomentumEntry])] {
        let currentHash = entries.hashValue
        
        if currentHash == lastEntriesHash, let cached = cachedGroupedEntries {
            return cached
        }
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        
        let grouped = Dictionary(grouping: entries) { entry in
            formatter.string(from: calendar.startOfDay(for: entry.date))
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMMM yyyy"
        
        let result = grouped.keys.sorted(by: >).map { key in
            let date = formatter.date(from: key)!
            let keyString = displayFormatter.string(from: date)
            let value = grouped[key]!.sorted { $0.date > $1.date }
            return (key: keyString, value: value)
        }
        
        cachedGroupedEntries = result
        lastEntriesHash = currentHash
        
        return result
    }
    
    func expandCurrentMonth(entries: [MomentumEntry]) {
        if let currentMonth = groupedEntries(for: entries).first?.key {
            expandedMonths.insert(currentMonth)
        }
    }
}

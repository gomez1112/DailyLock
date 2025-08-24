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
    
    var currentMonth = Date()
    let calendar = Calendar.current
    var viewModel = ViewMode.list
    private(set) var days: [Date] = []
    var monthTitle: String {
        currentMonth.formatted(.dateTime.month(.wide).year())
    }
    // MARK: - UI State Only
    var selectedEntry: MomentumEntry?
    var hoveredDate: Date?
    var expandedMonths: Set<String> = []
    
    init() {
        generateDays()
    }
    // MARK: - Cached computed values
    private var cachedGroupedEntries: [(key: String, value: [MomentumEntry])]?
    private var lastEntriesHash: Int = 0
    
    enum ViewMode: Identifiable, CaseIterable {
        case list, calendar
        
        var id: Self { self }
        
        var title: String {
            switch self {
                case .calendar: return "Calendar"
                case .list: return "List"
            }
        }
        
        var symbol: String {
            switch self {
                case .calendar: return "calendar"
                case .list: return "list.bullet"
            }
        }
    }
    /// Populates the `days` array for the `currentMonth`.
    private func generateDays() {
        let monthInterval = calendar.dateInterval(of: .month, for: currentMonth)!
        let monthFirstDay = monthInterval.start
        let monthDaysCount = calendar.component(.day, from: monthInterval.end) == 1
        ? calendar.range(of: .day, in: .month, for: monthFirstDay)!.count
        : calendar.component(.day, from: monthInterval.end) - 1 // Handle month end date quirk
        
        // Get the weekday of the first day of the month (e.g., Sunday = 1, Saturday = 7)
        let firstWeekday = calendar.component(.weekday, from: monthFirstDay)
        
        var calendarDays: [Date] = []
        
        // 1. Add padding days from the previous month
        let paddingDaysCount = firstWeekday - 1
        if paddingDaysCount > 0 {
            for i in (1...paddingDaysCount).reversed() {
                if let paddingDay = calendar.date(byAdding: .day, value: -i, to: monthFirstDay) {
                    calendarDays.append(paddingDay)
                }
            }
        }
        
        // 2. Add the actual days of the current month
        for i in 0..<monthDaysCount {
            if let day = calendar.date(byAdding: .day, value: i, to: monthFirstDay) {
                calendarDays.append(day)
            }
        }
        
        // 3. Add padding days from the next month to fill the grid (usually up to 42 cells for 6 rows)
        let remainingCells = 42 - calendarDays.count
        let nextMonthFirstDay = monthInterval.end
        
        if remainingCells > 0 {
            for i in 0..<remainingCells {
                if let paddingDay = calendar.date(byAdding: .day, value: i, to: nextMonthFirstDay) {
                    calendarDays.append(paddingDay)
                }
            }
        }
        
        self.days = calendarDays
    }
    // MARK: - Pure Functions
    func changeMonth(by value: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) else { return }
        currentMonth = newMonth
    }
    
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

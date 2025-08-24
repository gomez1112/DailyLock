//
//  CalendarDayView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//


import SwiftUI

struct macOSCalendarDayView: View {
    let date: Date
    let entry: MomentumEntry?
    let currentMonth: Date
    let isSelected: Bool // State is now passed in from the parent
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var isOfCurrentMonth: Bool {
        Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // MARK: - Day Number
            Text(date, format: .dateTime.day())
                .fontWeight(isToday ? .bold : .medium)
                .foregroundStyle(foregroundColor)
                .frame(width: 30, height: 30)
                .background(selectionBackground)
                .clipShape(Circle())
            
            // MARK: - Sentiment Decoration
            if let entry {
                Image(systemName: entry.sentiment.symbol)
                    .font(.caption)
                    .foregroundStyle(entry.sentiment.color)
            } else {
                // Add a placeholder to keep the grid layout consistent
                Text("").font(.caption)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .opacity(isOfCurrentMonth ? 1.0 : 0.3) // Fade out days not in the current month
        .animation(.spring(response: 0.3), value: entry?.sentiment)
        .animation(.spring(response: 0.3), value: isSelected)
    }
    
    /// The background for the day number, showing a solid circle for selection.
    @ViewBuilder
    private var selectionBackground: some View {
        if isSelected {
            Circle()
                .fill(isToday ? .accent.opacity(0.8) : .accent.opacity(0.6))
        } else if isToday {
            Circle()
                .strokeBorder(Color.accentColor, lineWidth: 2)
        }
    }
    
    /// The color of the day number text.
    private var foregroundColor: Color {
        if isSelected {
            return .white
        }
        if isToday {
            return .accent
        }
        return .primary
    }
}

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
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var isOfCurrentMonth: Bool {
        Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    var body: some View {
        Text(date, format: .dateTime.day())
            .fontWeight(isToday ? .bold : .medium)
            .foregroundStyle(isOfCurrentMonth ? foregroundColor : .secondary.opacity(0.5))
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(background)
            .clipShape(Circle())
            .overlay(
                // Add a ring around today's date for emphasis
                isToday ? Circle().stroke(Color.accentColor, lineWidth: 2) : nil
            )
            .animation(.spring(response: 0.3), value: entry?.sentiment)
    }
    
    @ViewBuilder
    private var background: some View {
        if let entry {
            // Fill the circle with a color based on the entry's sentiment
            Circle()
                .fill(entry.sentiment.color.opacity(isOfCurrentMonth ? 0.4 : 0.1))
        }
    }
    
    private var foregroundColor: Color {
        if let _ = entry {
            return .primary.opacity(0.9)
        }
        return isToday ? .accent : .secondary
    }
}

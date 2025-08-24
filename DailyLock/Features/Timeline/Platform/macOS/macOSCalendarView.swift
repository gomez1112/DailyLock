//
//  MacOSCalendarView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import SwiftUI
import SwiftData

struct macOSCalendarView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Query(sort: \MomentumEntry.date, order: .reverse) private var entries: [MomentumEntry]
    
    let timelineVM: TimelineViewModel
    
    private let weekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    private var entriesByDay: [Date: MomentumEntry] {
        Dictionary(uniqueKeysWithValues: entries.map { (Calendar.current.startOfDay(for: $0.date), $0) })
    }
    
    var body: some View {
        VStack {
            header
            weekdayHeader
            calendarGrid
        }
        .padding(.horizontal)
    }
    
    private var header: some View {
        HStack {
            Button {
                timelineVM.changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.title2)
            }
            
            Text(timelineVM.monthTitle)
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
            
            Button {
                timelineVM.changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
            }
        }
        .foregroundStyle(.accent)
        .buttonStyle(.plain)
        .padding(.vertical)
    }
    
    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(timelineVM.days, id: \.self) { date in
                let entry = entriesByDay[date]
                
                Button {
                    if let entry {
                        dependencies.navigation.presentedSheet = .entryDetail(entry: entry)
                    }
                } label: {
                    macOSCalendarDayView(date: date, entry: entry, currentMonth: timelineVM.currentMonth)
                }
                .buttonStyle(.plain)
                .disabled(entry == nil)
            }
        }
    }
}

#Preview(traits: .previewData) {
    macOSCalendarView(timelineVM: TimelineViewModel())
        .padding()
}

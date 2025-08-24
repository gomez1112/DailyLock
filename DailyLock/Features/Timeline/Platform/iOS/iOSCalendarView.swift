//
//  CalendarView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import SwiftUI
import SwiftData

struct iOSCalendarView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Query(sort: \MomentumEntry.date, order: .reverse) private var entries: [MomentumEntry]
    
    let timelineVM: TimelineViewModel
    
    private var entriesByDay: [Date: MomentumEntry] {
        Dictionary(uniqueKeysWithValues: entries.map { (Calendar.current.startOfDay(for: $0.date), $0) })
    }
    
    var body: some View {
        VStack {
            // ✨ Replace the custom grid with the new representable view
            CalendarRepresentableView(entriesByDay: entriesByDay, currentMonth: timelineVM.currentMonth) { selectedDate in
                if let entry = entriesByDay[selectedDate] {
                    dependencies.navigation.presentedSheet = .entryDetail(entry: entry)
                }
            }
        }
        .padding(.horizontal)
    }
}

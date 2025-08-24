//
//  CalendarView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//


import SwiftUI

/// A platform-aware view that displays the native UICalendarView on iOS
/// and a custom SwiftUI grid calendar on macOS.
struct CalendarView: View {
    let timelineVM: TimelineViewModel
    var body: some View {
        #if os(iOS)
        iOSCalendarView(timelineVM: timelineVM)
        #else
        macOSCalendarView(timelineVM: timelineVM)
        #endif
    }
}

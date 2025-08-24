//
//  CalendarRepresentableView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
struct CalendarRepresentableView: UIViewRepresentable {
    // Data passed in from SwiftUI
    let entriesByDay: [Date: MomentumEntry]
    let currentMonth: Date
    
    // Callback to notify SwiftUI of a selection
    let onDateSelected: (Date) -> Void
    
    // This creates the initial UICalendarView
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = .current
        calendarView.fontDesign = .serif // Match your app's aesthetic
        calendarView.delegate = context.coordinator
        
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        let today = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        selection.setSelected(today, animated: false)
        calendarView.selectionBehavior = selection
        
        return calendarView
    }
    
    // This updates the view when SwiftUI state changes
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Animate to the new month if it changes
        if !Calendar.current.isDate(currentMonth, equalTo: uiView.visibleDateComponents.date!, toGranularity: .month) {
            let components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
            uiView.setVisibleDateComponents(components, animated: true)
        }
        
        // Reload decorations for all entry dates
        let entryDates = entriesByDay.keys.map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
        uiView.reloadDecorations(forDateComponents: entryDates, animated: true)
    }
    
    // This creates the coordinator that handles communication
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarRepresentableView
        
        init(parent: CalendarRepresentableView) {
            self.parent = parent
        }
        
        // Provide a decoration (a colored dot) for dates that have an entry
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let date = dateComponents.date,
                  let entry = parent.entriesByDay[date] else {
                return nil
            }
            // Return a colored dot using the sentiment color
            return .image(
                UIImage(systemName: entry.sentiment.symbol),
                color: UIColor(entry.sentiment.color),
                size: .large
            )
        }
        
        // Handle a date being tapped
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let date = dateComponents?.date else { return }
            parent.onDateSelected(date)
        }
    }
}

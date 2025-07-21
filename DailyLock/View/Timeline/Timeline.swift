//
//  Timeline.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftData
import SwiftUI

struct Timeline: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Environment(HapticEngine.self) private var haptics: HapticEngine
    
    @Query(sort: \MomentumEntry.date, order: .reverse) private var entries: [MomentumEntry]
    
    @State private var selectedEntry: MomentumEntry?
    @State private var hoveredDate: Date?
    
    private var groupedEntries: [(key: String, value: [MomentumEntry])] {
        Dictionary(grouping: entries) { entry in
            entry.date.formatted(.dateTime.month(.wide).year())
        }
        .sorted { lhs, rhs in
            // Sort by parsing the date strings
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            let lhsDate = formatter.date(from: lhs.key) ?? Date.distantPast
            let rhsDate = formatter.date(from: rhs.key) ?? Date.distantPast
            return lhsDate > rhsDate
        }
        .map { ($0.key, $0.value.sorted { $0.date > $1.date }) }
    }
    
    var body: some View {
        ZStack {
            PaperTextureView()
                .ignoresSafeArea()
        ScrollView {
                VStack(spacing: 40) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Your Journey")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fontDesign(.serif)
                            .foregroundStyle((colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor))
                        
                        Text("\(entries.count) moments captured")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Timeline
                    ForEach(groupedEntries, id: \.key) { month, monthEntries in
                        VStack(alignment: .leading, spacing: 20) {
                            // Month Header
                            Text(month)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle((colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor))
                                .padding(.horizontal)
                            
                            // Entries
                            VStack(spacing: 0) {
                                ForEach(monthEntries) { entry in
                                    TimelineEntry(
                                        entry: entry,
                                        isHovered: hoveredDate == entry.date,
                                        onTap: {
                                            selectedEntry = entry
                                            haptics.tap()
                                        }
                                    )
                                    .onHover { hovering in
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            hoveredDate = hovering ? entry.date : nil
                                        }
                                    }
                                    
                                    if entry != monthEntries.last {
                                        TimelineConnector()
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(entry: entry)
        }
    }
}

#Preview(traits: .previewData) {
    Timeline()
}

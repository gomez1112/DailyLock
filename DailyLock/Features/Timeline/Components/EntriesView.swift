//
//  EntriesView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import SwiftUI

struct EntriesView: View {
    @Environment(\.isDark) private var isDark
    
    let entries: [MomentumEntry]
    let dependencies: AppDependencies
    let timelineVM: TimelineViewModel
    
    var body: some View {
        ForEach(timelineVM.groupedEntries(for: entries), id: \.key) { month, monthEntries in
            VStack(alignment: .leading, spacing: AppTimeline.monthSectionSpacing) {
                monthHeaderButton(month: month, monthEntries: monthEntries)
#if os(macOS)
                    .onHover { hovering in
                        if hovering {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
#endif
                
                if timelineVM.expandedMonths.contains(month) {
                    expandedMonthsView(monthEntries: monthEntries)
                } else {
                    monthSummary(monthEntries: monthEntries)
                        .accessibilityIdentifier("monthSummary_\(month)")
                }
            }
        }
    }
    private func expandedMonthsView(monthEntries: [MomentumEntry]) -> some View {
        VStack(spacing: 0) {
            ForEach(monthEntries) { entry in
                TimelineEntry(
                    entry: entry,
                    isHovered: timelineVM.hoveredDate == entry.date
                ) {
                    dependencies.navigation.presentedSheet = .entryDetail(entry: entry)
#if !os(macOS)
                    dependencies.haptics.tap()
#endif
                }
                .contextMenu {
                    Button(role: .destructive) {
                        dependencies.dataService.delete(entry)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Moment entry for \(entry.date.formatted(date: .long, time: .omitted)), sentiment: \(entry.sentiment.rawValue)")
                .accessibilityIdentifier("timelineEntry_\(entry.id)")
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        timelineVM.hoveredDate = hovering ? entry.date : nil
                    }
                }
                
                if entry != monthEntries.last {
                    TimelineConnector()
                }
            }
        }
        .padding(.horizontal)
        .transition(.asymmetric(
            insertion: .opacity,
            removal: .opacity
        ))
    }
    private func monthSummary(monthEntries: [MomentumEntry]) -> some View {
        HStack(spacing: 16) {
            ForEach(Sentiment.allCases) { sentiment in
                let count = monthEntries.filter { $0.sentiment == sentiment }.count
                if count > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: sentiment.symbol)
                            .font(.caption)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(LinearGradient(
                                colors: sentiment.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                        Text(count.formatted())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
            Text("Tap to expand")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Summary for month. " + Sentiment.allCases.map({ sentiment in
            let count = monthEntries.filter { $0.sentiment == sentiment }.count
            return "\(sentiment.rawValue): \(count)"
        }).joined(separator: ", "))
        .accessibilityIdentifier("monthSummaryView")
        .padding(.horizontal, AppTimeline.summaryHorizontalPadding)
        .padding(.vertical, AppTimeline.summaryVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: AppTimeline.summaryCornerRadius)
                .fill(isDark ? ColorPalette.darkCardBackground : ColorPalette.lightCardBackground)
                .opacity(0.5)
        )
        .padding(.horizontal)
        .transition(.scale(scale: AppTimeline.transitionScale).combined(with: .opacity))
    }
    private func monthHeaderButton(month: String, monthEntries: [MomentumEntry]) -> some View {
        // Month Header Button
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                timelineVM.toggleMonth(month)
#if !os(macOS)
                dependencies.haptics.tap()
#endif
            }
        } label: {
            HStack {
                Text(month)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                Spacer()
                Text(monthEntries.count.formatted())
                Image(systemName: timelineVM.expandedMonths.contains(month) ? "chevron.up" : "chevron.down")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(month), \(monthEntries.count) moments, \(timelineVM.expandedMonths.contains(month) ? "Expanded" : "Collapsed")")
        .accessibilityIdentifier("monthHeader_\(month)")
    }
}

#Preview(traits: .previewData) {
    EntriesView(entries: MomentumEntry.samples, dependencies: AppDependencies(), timelineVM: TimelineViewModel())
}

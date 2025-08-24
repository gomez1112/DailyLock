//
//  Timeline.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftData
import SwiftUI

struct Timeline: View {
    
    @State private var timelineVM = TimelineViewModel()
    
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.deviceStatus) private var deviceStatus
    @Environment(\.isDark) private var isDark
    @Environment(\.modelContext) private var context
    
    @Query(sort: \MomentumEntry.date, order: .reverse) private var entries: [MomentumEntry]
    
    var body: some View {
        ZStack {
            WritingPaper()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                header
                //.padding(.top, AppSpacing.large)
                if timelineVM.viewModel == .list {
                ScrollView {
                    VStack(spacing: AppTimeline.mainVStackSpacing) {
                        
                        
                        if timelineVM.groupedEntries(for: entries).isEmpty {
                            ContentUnavailableView {
                                Label("Your journey starts here", systemImage: "pencil.line")
                            } description: {
                                Text("Capture your first moment to begin building your timeline")
                            } actions: {
                                Button {
                                    dependencies.navigation.navigate(to: .today)
                                } label: {
                                    Text("Write First Entry")
                                        .accessibilityIdentifier("writeFirstEntryButton")
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(.accent)
                            }
                            
                        } else {
                            EntriesView(entries: entries, dependencies: dependencies, timelineVM: timelineVM)
                                .applyIf(deviceStatus != .compact) { $0.frame(maxWidth: AppLayout.timelineContentMaxWidth) }
                            Spacer(minLength: AppTimeline.entriesSpacerMin)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                } else {
                    CalendarView(timelineVM: timelineVM)
                }
        }
        }
        .scrollBounceBehavior(.basedOnSize)
        .onAppear {
            timelineVM.expandCurrentMonth(entries: entries)
        }
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text("Your Journey")
                .font(.largeTitle)
                .fontWeight(.bold)
                .fontDesign(.serif)
                .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                .accessibilityIdentifier("timelineHeader")
                .accessibilityLabel("Timeline Header")
            
            Text("\(entries.count) moments captured")
                .font(.callout)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("timelineMomentCount")
                .accessibilityLabel("Number of moments captured")
                .accessibilityValue("\(entries.count)")
            
            Picker("View Mode", selection: $timelineVM.viewModel.animation()) {
                ForEach(TimelineViewModel.ViewMode.allCases) { view in
                    Label(view.title, systemImage: view.symbol)
                        .tag(view)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        }
        .padding(.bottom, AppTimeline.headerBottomPadding)
    }
}

#Preview(traits: .previewData) {
    Timeline()
}

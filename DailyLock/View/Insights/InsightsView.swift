//
//  InsightsView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import FoundationModels
import SwiftData
import SwiftUI

struct InsightsView: View {
    
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isDark) private var isDark
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \MomentumEntry.date, order: .reverse) private var entries: [MomentumEntry]
    
    private let foundationModel = SystemLanguageModel.default
    
    var body: some View {
#if os(macOS)
        insightsContent
#else
        NavigationStack {
            insightsContent
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button {
                            dependencies.navigation.presentedSheet = .paywall
                            dismiss()
                        } label: {
                            Label("Upgrade", systemImage: "crown")
                        }
                        .opacity(dependencies.store.hasUnlockedPremium ? 0 : 1)
                        .accessibilityIdentifier("upgradeButton")
                        .accessibilityLabel("Upgrade to Premium")
                        .accessibilityHint("Opens the upgrade paywall")
                    }
                }
        }
#endif
    }
    
    private var insightsContent: some View {
        ZStack {
            WritingPaper()
            
            ScrollView(.vertical) {
                VStack {
                    header
                        .padding(.top, headerPadding)
                    
                    if entries.count >= 1 {
                        VStack(spacing: cardSpacing) {
                            StreakStatsCard(allowGracePeriod: dependencies.syncedSetting.allowGracePeriod, entries: entries)
                                .accessibilityElement(children: .contain)
                                .accessibilityIdentifier("streakStatsCard")
                                .onPlatform { view in
                                    view.padding(.horizontal)
                                }
                            
                            // NEW: Yearly Stats Card (Premium Feature)
                            YearlyStatsCard(entries: entries)
                                .premiumFeature(.yearlyStats, isLocked: !dependencies.store.hasUnlockedPremium)
                                .accessibilityElement(children: .contain)
                                .accessibilityIdentifier("yearlyStatsCard")
                                .onPlatform { view in
                                    view.padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                            
                            MoodDistributionCard(entries: entries)
                                .premiumFeature(.advancedInsights, isLocked: !dependencies.store.hasUnlockedPremium)
                                .accessibilityElement(children: .contain)
                                .accessibilityIdentifier("moodDistributionCard")
                                .onPlatform { view in
                                    view.padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                            if foundationModel.isAvailable {
                                WeeklySummaryCard(haptics: dependencies.haptics ,errorState: dependencies.errorState, entries: entries, generator: InsightGenerator(entries: entries))
                                    .premiumFeature(.aiSummaries, isLocked: !dependencies.store.hasUnlockedPremium)
                                    .accessibilityElement(children: .contain)
                                    .accessibilityIdentifier("weeklySummaryCard")
                                    .onPlatform { view in
                                        view.padding(.horizontal)
                                    }
                                    .buttonStyle(.plain)
                            }
                        }
                        .onPlatform { view in
                            view.frame(maxWidth: AppLayout.insightsCardMaxWidth)
                        }
                    }
                    else {
                        contentUnavailable
                    }
                    
                    Spacer(minLength: 50)
                }
                .frame(maxWidth: .infinity)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
    
    private var headerPadding: CGFloat {
        platformValue(iOS: 20, macOS: 30)
    }
    
    private var cardSpacing: CGFloat {
        platformValue(iOS: 16, macOS: 20)
    }
    
    private var header: some View {
        VStack {
            Text("Your Insights")
                .font(.title2)
                .fontWeight(.bold)
                .fontDesign(.serif)
                .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                .accessibilityIdentifier("insightsHeader")
                .accessibilityAddTraits(.isHeader)
            
            if entries.count >= 1 {
                Text("Based on \(entries.count) entries")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("entriesCountText")
            }
        }
    }
    
    private var contentUnavailable: some View {
        ContentUnavailableView {
            Label("Keep Writing", systemImage: "chart.line.uptrend.xyaxis")
        } description: {
            VStack {
                Text("You need at least 1 entries to see insights")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .accessibilityIdentifier("entriesNeededText")
                Button("Go write your first Entry!") {
                    dependencies.navigation.navigate(to: .today)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(40)
        .accessibilityIdentifier("contentUnavailableView")
        .accessibilityLabel("Insufficient Entries")
        .accessibilityHint("You need at least 5 entries to view insights")
    }
}

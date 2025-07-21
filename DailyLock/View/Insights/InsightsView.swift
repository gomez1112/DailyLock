//
//  InsightsView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftData
import SwiftUI

struct InsightsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Environment(DataModel.self) private var model
    
    @Query(sort: \MomentumEntry.date, order: .reverse) private var entries: [MomentumEntry]
    
    @State private var showPaywall = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                PaperTextureView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Your Insights")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .fontDesign(.serif)
                                .foregroundStyle(colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor)
                            
                            if entries.count >= 5 {
                                Text("Based on \(entries.count) entries")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.top, 40)
                        
                        if entries.count >= 5 {
                            // Mood Distribution Chart
                            MoodDistributionCard(entries: entries)
                                .premiumFeature(.advancedInsights, isLocked: !model.store.hasUnlockedPremium)
                            
                            // Word Cloud Preview
                            WordCloudCard(entries: entries)
                                .premiumFeature(.advancedInsights, isLocked: !model.store.hasUnlockedPremium)
                            
                            // Weekly Summary
                            WeeklySummaryCard()
                                .premiumFeature(.aiSummaries, isLocked: !model.store.hasUnlockedPremium)
                            
                            // Streak Stats
                            StreakStatsCard(entries: entries)
                            
                        } else {
                            // Not enough data
                            VStack(spacing: 20) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.secondary)
                                
                                Text("Keep Writing")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Text("You need at least 5 entries to see insights")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Text("\(5 - entries.count) more to go!")
                                    .font(.headline)
                                    .foregroundStyle(Color(hex: "FFD700"))
                            }
                            .padding(60)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                }
            }
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem {
                    Button {
                        showPaywall = true
                    } label: {
                        Label("Upgrade", systemImage: "sparkles")
                            .labelStyle(.iconOnly)
                            .font(.title3)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .opacity(model.store.hasUnlockedPremium ? 0 : 1)
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}

#Preview(traits: .previewData) {
    InsightsView()
}

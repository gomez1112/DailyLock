//
//  StreakStatsCard.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//


import SwiftUI

struct StreakStatsCard: View {
    @Environment(\.deviceStatus) private var deviceStatus
    let allowGracePeriod: Bool
    
    let entries: [MomentumEntry]
    
    private var streakInfo: StreakInfo {
        StreakCalculator.calculateStreak(from: entries, allowGracePeriod: allowGracePeriod)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                currentStreak
                Divider()
                    .frame(height: deviceStatus == .compact ? 60 : 80)
                longestStreak
            }
            .padding(deviceStatus == .compact ? 16: 20)
            
            // Grace Period Status Bar (NEW)
            if allowGracePeriod && (streakInfo.isGracePeriodActiveNow || streakInfo.gracePeriodUsed) {
                Divider()
                gracePeriodStatusBar
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
        }
        .cardBackground(cornerRadius: AppLayout.radiusLarge, shadowRadius: DesignSystem.Shadow.shadowSmall)
        .accessibilityIdentifier("streakStatsCard")
        .accessibilityElement(children: .contain)
    }
    
    private var currentStreak: some View {
        VStack(spacing: deviceStatus == .compact ? 8 : 12) {
            HStack(spacing: 4) {
                Image(systemName: streakIcon)
                    .font(deviceStatus == .compact ? .title2 : .title)
                    .foregroundStyle(streakGradient)
                    .symbolEffect(.bounce, value: streakInfo.isGracePeriodActiveNow)
                
                if allowGracePeriod {
                    gracePeriodBadge
                }
            }
            
            Text(streakInfo.count.formatted())
                .font(deviceStatus == .compact ? .title : .largeTitle)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .accessibilityIdentifier("currentStreakValue")
                .contentTransition(.numericText())
            
            Text("Current Streak")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityIdentifier("currentStreakSection")
        .accessibilityLabel("Current streak")
        .accessibilityValue(Text("\(streakInfo.count) day\(streakInfo.count == 1 ? "" : "s")"))
        .accessibilityHint(gracePeriodHint)
    }
    
    private var longestStreak: some View {
        VStack(spacing: deviceStatus == .compact ? 8 : 12) {
            HStack(spacing: 4) {
                Image(systemName: "trophy.fill")
                    .font(deviceStatus == .compact ? .title2 : .title)
                    .foregroundStyle(
                        LinearGradient(
                            colors: ColorPalette.insightsCardGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                if allowGracePeriod {
                    Image(systemName: "heart.fill")
                        .font(.caption2)
                        .foregroundStyle(.pink.opacity(0.7))
                        .accessibilityIdentifier("gracePeriodIndicatorLongest")
                        .accessibilityLabel("Grace period enabled for calculation")
                }
            }
            
            Text(longestStreakValue.formatted())
                .font(deviceStatus == .compact ? .title : .largeTitle)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .accessibilityIdentifier("longestStreakValue")
                .contentTransition(.numericText())
            
            Text("Best Streak")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityIdentifier("longestStreakSection")
        .accessibilityLabel("Best streak")
        .accessibilityValue("\(longestStreakValue) day\(longestStreakValue == 1 ? "" : "s")")
        .accessibilityHint(gracePeriodHint)
    }
    
    // NEW: Grace Period Status Bar
    @ViewBuilder
    private var gracePeriodStatusBar: some View {
        HStack(spacing: 8) {
            Image(systemName: gracePeriodStatusIcon)
                .font(.caption)
                .foregroundStyle(gracePeriodStatusColor)
            
            Text(gracePeriodStatusText)
                .font(.caption)
                .foregroundStyle(gracePeriodStatusColor)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .accessibilityIdentifier("gracePeriodStatus")
        .accessibilityLabel(gracePeriodStatusText)
    }
    
    // NEW: Grace Period Badge for current streak
    @ViewBuilder
    private var gracePeriodBadge: some View {
        if streakInfo.isGracePeriodActiveNow {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption2)
                .foregroundStyle(.orange)
                .accessibilityIdentifier("gracePeriodActiveIndicator")
                .accessibilityLabel("Grace period active - complete today!")
        } else if streakInfo.gracePeriodUsed {
            Image(systemName: "shield.slash.fill")
                .font(.caption2)
                .foregroundStyle(.gray.opacity(0.7))
                .accessibilityIdentifier("gracePeriodUsedIndicator")
                .accessibilityLabel("Grace period already used")
        } else {
            Image(systemName: "heart.fill")
                .font(.caption2)
                .foregroundStyle(.pink.opacity(0.7))
                .accessibilityIdentifier("gracePeriodAvailableIndicator")
                .accessibilityLabel("Grace period available")
        }
    }
    
    // Dynamic properties based on grace period status
    private var streakIcon: String {
        streakInfo.isGracePeriodActiveNow ? "flame.circle.fill" : "flame.fill"
    }
    
    private var streakGradient: LinearGradient {
        if streakInfo.isGracePeriodActiveNow {
            // Orange-yellow gradient for warning state
            LinearGradient(
                colors: [.orange, .yellow],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            // Normal orange-red gradient
            LinearGradient(
                colors: [.orange, .red],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var gracePeriodStatusIcon: String {
        if streakInfo.isGracePeriodActiveNow {
            return "exclamationmark.triangle.fill"
        } else if streakInfo.gracePeriodUsed {
            return "checkmark.shield.fill"
        } else {
            return "heart.fill"
        }
    }
    
    private var gracePeriodStatusColor: Color {
        if streakInfo.isGracePeriodActiveNow {
            return .orange
        } else if streakInfo.gracePeriodUsed {
            return .gray
        } else {
            return .green
        }
    }
    
    private var gracePeriodStatusText: String {
        if streakInfo.isGracePeriodActiveNow {
            return "Complete today to maintain streak!"
        } else if streakInfo.gracePeriodUsed {
            return "Grace period used • No more misses allowed"
        } else {
            return "Grace period available • 1 miss allowed"
        }
    }
    
    private var longestStreakValue: Int {
        StreakCalculator.calculateLongestStreak(for: entries, allowGracePeriod: allowGracePeriod)
    }
    
    private var gracePeriodHint: String {
        if streakInfo.isGracePeriodActiveNow {
            return "Grace period active. Complete today to maintain your streak."
        } else if streakInfo.gracePeriodUsed {
            return "Grace period already used. Missing another day will break your streak."
        } else if allowGracePeriod {
            return "One missed day will not break your streak."
        } else {
            return "Requires consecutive days only."
        }
    }
}

#Preview(traits: .previewData) {
    StreakStatsCard(allowGracePeriod: false, entries: MomentumEntry.samples)
}


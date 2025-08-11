//
//  GracePeriodSection.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/3/25.
//


import SwiftUI

struct GracePeriodSection: View {
    @AppStorage("allowGracePeriod") private var allowGracePeriod = false
    
    var body: some View {
        Section {
            Toggle(isOn: $allowGracePeriod.animation()) {
                Label {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Grace Period")
                            .font(.body)
                            .accessibilityIdentifier("gracePeriodTitle")
                        
                        Text(allowGracePeriod ? "One missed day won't break your streak" : "Streaks require consecutive days")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("gracePeriodDescription")
                    }
                } icon: {
                    Image(systemName: allowGracePeriod ? "heart.fill" : "calendar.badge.exclamationmark")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.accent)
                        .accessibilityIdentifier("gracePeriodIcon")
                        .contentTransition(.symbolEffect(.replace))
                }
            }
            .tint(.accent)
            .accessibilityIdentifier("gracePeriodToggle")
            .accessibilityLabel("Grace period for streaks")
            .accessibilityValue(allowGracePeriod ? "Enabled" : "Disabled")
            .accessibilityHint(allowGracePeriod ? "One missed day won't break your streak" : "Streaks require consecutive days")
            
            // Informational note
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("How it works")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
                
                Text(gracePeriodExplanation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 4)
            .accessibilityIdentifier("gracePeriodExplanation")
            .accessibilityLabel("Grace period explanation")
        } header: {
            Text("Streak Calculation")
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("gracePeriodSection")
    }
    
    private var gracePeriodExplanation: String {
        if allowGracePeriod {
            return "If you miss one day, your streak continues. Missing two consecutive days will break it. Both current and longest streaks use this setting."
        } else {
            return "Every day must have an entry to maintain your streak. This applies to both current and longest streak calculations."
        }
    }
}

//
//  PremiumFeatureGate.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct PremiumFeatureGate: View {
    
    let feature: PremiumFeature
    let onUpgrade: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            // Locked Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FFD700").opacity(0.2), Color(hex: "FFA500").opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // Feature Description
            VStack(spacing: 12) {
                Text(feature.rawValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(featureDescription)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Upgrade Button
            Button(action: onUpgrade) {
                Label("Unlock with DailyLock+", systemImage: "sparkles")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color(hex: "FFD700").opacity(0.3), radius: 10, y: 5)
            }
            .padding(.horizontal, 40)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground)
                .shadow(color: colorScheme == .dark ? Color.darkShadowColor : Color.lightShadowColor, radius: 20)
        )
        .padding(20)
    }
    
    private var featureDescription: String {
        switch feature {
        case .unlimitedEntries:
            return "Write multiple entries per day to capture every meaningful moment"
        case .advancedInsights:
            return "Discover patterns in your mood and see your most common themes"
        case .aiSummaries:
            return "Get weekly AI-generated summaries of your entries and insights"
        case .streakRescue:
            return "Missed a day? Rescue your streak once per month"
        case .customThemes:
            return "Personalize your journal with beautiful themes and fonts"
        case .smartReminders:
            return "Get intelligent reminders based on your writing patterns"
        case .secureBackup:
            return "Keep your entries safe with encrypted cloud backup"
        case .yearbook:
            return "Create beautiful annual summaries of your best moments"
        }
    }
}

#Preview {
    PremiumFeatureGate(feature: .secureBackup, onUpgrade: {})
}

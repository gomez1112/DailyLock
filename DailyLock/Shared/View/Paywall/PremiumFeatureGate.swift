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
        VStack {
            // Locked Icon
            ZStack {
                Circle()
                    .fill(.accent.gradient.opacity(0.09))
                    .frame(width: AppSpacing.headerCircleSize, height: AppSpacing.headerCircleSize)
                
                Image(systemName: "lock.fill")
                    .font(.system(size: DesignSystem.Text.Font.large))
                    .foregroundStyle(.accent.gradient)
            }
            .accessibilityLabel("Locked Feature")
            .accessibilityIdentifier("lockedIcon")
            
            // Feature Description
            VStack {
                Text(feature.rawValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .accessibilityIdentifier("featureTitle")
                
                Text(featureDescription)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.regular)
                    .accessibilityIdentifier("featureDescription")
            }
            
            // Upgrade Button
            Button(role: nil, action: onUpgrade) {
                Label("Unlock with DailyLock+", systemImage: "sparkles")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.regular)
                    .background(.accent.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: AppLayout.radiusLarge))
                    .shadow(color: Color(.accent).opacity(DesignSystem.Shadow.darkShadowOpacity), radius: DesignSystem.Shadow.shadowLarge, y: DesignSystem.Shadow.shadowSmall)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, AppSpacing.regular)
            .accessibilityIdentifier("upgradeButton")
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("premiumFeatureGateContainer")
        .padding(.vertical, AppSpacing.large)
        .padding(.horizontal, AppSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppLayout.radiusXLarge)
                .fill(colorScheme == .dark ? ColorPalette.darkCardBackground : ColorPalette.lightCardBackground)
                .shadow(color: colorScheme == .dark ? DesignSystem.Shadow.darkShadowColor : DesignSystem.Shadow.lightShadowColor, radius: DesignSystem.Shadow.shadowLarge)
        )
    }
    
    private var featureDescription: String {
        switch feature {
        case .unlimitedEntries:
            return "Write multiple entries per day to capture every meaningful moment"
        case .advancedInsights:
            return "Discover patterns in your mood and see your most common themes"
        case .yearlyStats:
            return "Visualize your writing journey with detailed yearly statistics and trends"
        case .aiSummaries:
            return "Get weekly AI-generated summaries of your entries and insights"
        case .yearbook:
            return "Create beautiful annual summaries of your best moments"
        }
    }
}

#Preview {
    PremiumFeatureGate(feature: .advancedInsights, onUpgrade: {})
}

//
//  FeatureCard.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct FeatureCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let feature: PremiumFeature
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: feature.icon)
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 30)
            
            Text(feature.rawValue)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground)
                .shadow(color: colorScheme == .dark ? Color.darkShadowColor : Color.lightShadowColor, radius: 4)
        )
    }
}

#Preview {
    FeatureCard(feature: .advancedInsights)
}

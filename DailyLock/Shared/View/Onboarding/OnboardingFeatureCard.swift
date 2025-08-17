//
//  OnboardingFeatureCard.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//

import SwiftUI

struct OnboardingFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: Constants.OnboardingFeatureCard.vStackSpacing) {
            Image(systemName: icon)
                .font(.system(size: Constants.OnboardingFeatureCard.iconFontSize))
                .foregroundStyle(.accent)
                .accessibilityIdentifier("featureCardIcon")
            
            Text(title)
                .font(.headline)
                .accessibilityIdentifier("featureCardTitle")
            
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("featureCardDescription")
        }
        .padding(Constants.OnboardingFeatureCard.cardPadding)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(description)")
        .accessibilityIdentifier("featureCardRoot")
    }
}

#Preview {
    OnboardingFeatureCard(icon: "lock", title: "This is  a title", description: "This is the description")
}

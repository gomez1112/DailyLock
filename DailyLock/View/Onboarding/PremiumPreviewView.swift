//
//  PremiumPreviewView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//

import SwiftUI

struct PremiumPreviewView: View {
    @State private var selectedFeature = 0
    
    let features = [
        ("Unlimited Entries", "infinity", "Capture every moment throughout your day"),
        ("AI Insights", "sparkles", "Discover patterns in your thoughts"),
        ("Mood Analytics", "chart.line.uptrend.xyaxis", "Track emotional journeys"),
        ("Annual Yearbook", "book.closed", "Beautiful year-end summaries")
    ]
    
    var body: some View {
        VStack(spacing: Constants.Premium.previewVStackSpacing) {
            Spacer()
            
            // Crown animation
            Image(systemName: "crown.fill")
                .font(.system(size: Constants.Premium.previewCrownFontSize))
                .foregroundStyle(.accent)
                .symbolEffect(.pulse)
                .accessibilityIdentifier("premiumCrown")
                .accessibilityLabel("Premium feature crown")
            
            Text("DailyLock+ Premium")
                .font(.title)
                .fontWeight(.bold)
                .accessibilityIdentifier("premiumTitle")
                .accessibilityAddTraits(.isHeader)
            
            // Feature carousel
            TabView(selection: $selectedFeature) {
                ForEach(0..<features.count, id: \.self) { index in
                    VStack {
                        OnboardingFeatureCard(
                            icon: features[index].1,
                            title: features[index].0,
                            description: features[index].2
                        )
                    }
                    .accessibilityIdentifier("featureCard_\(index)")
                    .accessibilityLabel(features[index].0)
                    .tag(index)
                }
            }
            #if !os(macOS)
            .tabViewStyle(.page)
            #endif
            .frame(height: Constants.Premium.previewFeatureCarouselHeight)
            .accessibilityIdentifier("featureCarousel")
            .accessibilityLabel("Premium feature carousel")
            
            Spacer()
            
            VStack(spacing: Constants.Premium.previewButtonVStackSpacing) {
                Button {
                    // Show paywall
                } label: {
                    Text("Start Free Trial")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Premium.previewButtonCornerRadius))
                }
                .accessibilityIdentifier("startFreeTrialButton")
                .accessibilityLabel("Start Free Trial")
                .accessibilityHint("Begins a 7-day free trial, then $4.99 per month")
                
                Text("7 days free, then $4.99/month")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("trialInfoText")
                    .accessibilityLabel("7 days free, then $4.99 per month")
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.horizontal, Constants.Premium.previewHorizontalPadding)
    }
}

#Preview {
    PremiumPreviewView()
}

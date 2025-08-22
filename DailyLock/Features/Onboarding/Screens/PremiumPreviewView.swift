//
//  PremiumPreviewView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//

import SwiftUI
struct PremiumPreviewView: View {
    @Environment(AppDependencies.self) private var dependencies
    @State private var selectedFeature = 0
    @State private var animationTask: Task<Void, Never>?
    private var features: [(String, String, String)] {
        [
            ("Unlimited Entries", "infinity", "Capture every moment throughout your day"),
            ("AI Insights", "sparkles", "Discover patterns in your thoughts"),
            ("Mood Analytics", "chart.line.uptrend.xyaxis", "Track emotional journeys"),
            ("Annual Yearbook", "book.closed", "Beautiful year-end summaries")
        ]
    }
    var body: some View {
        OnboardingPageView {
            VStack {
                Spacer()
                Image(systemName: "crown.fill")
                    .font(.system(size: Constants.Premium.previewCrownFontSize))
                    .foregroundStyle(.accent)
                    .symbolEffect(.pulse, value: selectedFeature)
                    .accessibilityIdentifier("premiumCrown")
                    .accessibilityLabel("Premium feature crown")
                Text("DailyLock+ Premium")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityIdentifier("premiumTitle")
                    .accessibilityAddTraits(.isHeader)
                Spacer()
            }
        } content: {
            VStack(spacing: Constants.Premium.previewVStackSpacing) {
                // Feature carousel - Platform specific implementation
#if os(macOS)
                macOSPremiumPreviewView(selectedFeature: $selectedFeature, features: features)
#else
                // iOS/iPadOS: Use TabView with page style
                TabView(selection: $selectedFeature) {
                    ForEach(features.indices, id: \.self) { index in
                        if index < features.count {
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
                }
                .tabViewStyle(.page)
                .frame(height: Constants.Premium.previewFeatureCarouselHeight)
#endif
                
                VStack(spacing: Constants.Premium.previewButtonVStackSpacing) {
                    Button {
                        dependencies.navigation.presentedSheet = .paywall
                    } label: {
                        Text("Start Free Trial")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.Premium.previewButtonCornerRadius))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("startFreeTrialButton")
                    .accessibilityLabel("Start Free Trial")
                    .accessibilityHint("Begins a 7-day free trial, then $4.99 per month")
                    
                    Text("7 days free, then $4.99/month")
                        .font(.caption)
                        .lineLimit(2...2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("trialInfoText")
                        .accessibilityLabel("7 days free, then $4.99 per month")
                }
                
            }
            .padding(.horizontal, Constants.Premium.previewHorizontalPadding)
            .onDisappear {
                animationTask?.cancel() // Clean up any running animations
            }
        }
    }
}


#Preview(traits: .previewData) {
    PremiumPreviewView()
}

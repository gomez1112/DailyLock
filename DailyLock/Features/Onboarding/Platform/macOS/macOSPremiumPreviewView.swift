//
//  MacPremiumPreviewView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/17/25.
//

import SwiftUI

struct macOSPremiumPreviewView: View {
    @Binding var selectedFeature: Int
    let features: [(String, String, String)]
    
    var body: some View {
        VStack(spacing: 20) {
            // Feature Card Display
            if selectedFeature < features.count {
                OnboardingFeatureCard(
                    icon: features[selectedFeature].1,
                    title: features[selectedFeature].0,
                    description: features[selectedFeature].2
                )
                .accessibilityIdentifier("featureCard_\(selectedFeature)")
                .accessibilityLabel(features[selectedFeature].0)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .id(selectedFeature) // Force view refresh on change
            }
            
            // Navigation Controls
            HStack(spacing: 20) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedFeature = max(0, selectedFeature - 1)
                    }
                } label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.plain)
                .keyboardShortcut(.leftArrow, modifiers: [])
                .disabled(selectedFeature == 0)
                .opacity(selectedFeature == 0 ? 0.3 : 1)
                
                // Page dots
                HStack(spacing: 8) {
                    ForEach(features.indices, id: \.self) { index in
                        Circle()
                            .fill(index == selectedFeature ? Color.accent : Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.spring(), value: selectedFeature)
                    }
                }
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedFeature = min(features.count - 1, selectedFeature + 1)
                    }
                } label: {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.plain)
                .keyboardShortcut(.rightArrow, modifiers: [])
                .disabled(selectedFeature == features.count - 1)
                .opacity(selectedFeature == features.count - 1 ? 0.3 : 1)
            }
            .padding(.horizontal)
        }
        .frame(height: Constants.Premium.previewFeatureCarouselHeight)
    }
}

#Preview {
    macOSPremiumPreviewView(selectedFeature: .constant(0), features: [("", "", "")])
}

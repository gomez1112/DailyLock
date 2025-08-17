//
//  iOSPremiumPreviewView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/17/25.
//

import SwiftUI

struct iOSPremiumPreviewView: View {
    @Binding var selectedFeature: Int
    let features: [(String, String, String)]
        
    var body: some View {
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
    }
}

#Preview {
    iOSPremiumPreviewView(selectedFeature: .constant(0), features: [("", "", "")])
}

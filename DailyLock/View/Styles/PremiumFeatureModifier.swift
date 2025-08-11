//
//  PremiumFeatureModifier.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct PremiumFeatureModifier: ViewModifier {
    let isLocked: Bool
    let feature: PremiumFeature
    @State private var showPaywall = false
    
    func body(content: Content) -> some View {
        if isLocked {
            ZStack {
                content
                    .blur(radius: 10)
                    .disabled(true)
                
                PremiumFeatureGate(feature: feature) {
                    showPaywall = true
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        } else {
            content
        }
    }
}

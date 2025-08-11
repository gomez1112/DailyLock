//
//  PremiumFeatureModifier.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct PremiumFeatureModifier: ViewModifier {
    @Environment(AppDependencies.self) private var dependencies
    
    let isLocked: Bool
    let feature: PremiumFeature
    
    func body(content: Content) -> some View {
        if isLocked {
            ZStack {
                content
                    .blur(radius: 10)
                    .disabled(true)
                
                PremiumFeatureGate(feature: feature) {
                    dependencies.navigation.presentedSheet = .paywall
                }
            }
        } else {
            content
        }
    }
}

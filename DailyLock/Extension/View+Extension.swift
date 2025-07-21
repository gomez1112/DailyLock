//
//  View+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

extension View {
    func premiumFeature(_ feature: PremiumFeature, isLocked: Bool) -> some View {
        modifier(PremiumFeatureModifier(isLocked: isLocked, feature: feature))
    }
    func cardBackground(cornerRadius: CGFloat = 20, shadowRadius: CGFloat = 10) -> some View {
        modifier(CardBackgroundModifier(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
}
extension EnvironmentValues {
    var isDark: Bool {
        colorScheme == .dark
    }
}

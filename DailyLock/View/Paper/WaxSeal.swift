//
//  WaxSeal.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct WaxSeal: View {
    let entry: MomentumEntry
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: ColorPalette.waxSealGradient,
                        center: .center,
                        startRadius: AppLayout.waxSealStartRadius,
                        endRadius: AppLayout.waxSealEndRadius
                    )
                )
                .accessibilityIdentifier("waxSealBackground")
            
            Circle()
                .stroke(ColorPalette.waxSealColor.opacity(0.3), lineWidth: 2)
                .padding(2)
                .accessibilityIdentifier("waxSealBorder")
            
            Text(entry.sentiment.rawValue.capitalized.prefix(1))
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundStyle(.white.opacity(0.9))
                .accessibilityIdentifier("waxSealInitial")
        }
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(entry.sentiment.rawValue.capitalized) wax seal")
        .accessibilityValue(entry.sentiment.rawValue.capitalized)
        .accessibilityIdentifier("waxSeal")
    }
}

#Preview {
    WaxSeal(entry: MomentumEntry.samples[0])
}

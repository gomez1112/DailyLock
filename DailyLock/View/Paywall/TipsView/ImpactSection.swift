//
//  ImpactSectin.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import SwiftUI

struct ImpactSection: View {
    
    @Environment(\.isDark) private var isDark
    @Environment(\.deviceStatus) private var deviceStatus
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Impact")
                .font(.headline)
                .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
            
            HStack(spacing: 30) {
                ImpactItem(
                    icon: "bolt.fill",
                    title: "Server Costs",
                    description: "Keep DailyLock fast & reliable"
                )
                
                ImpactItem(
                    icon: "sparkles",
                    title: "New Features",
                    description: "Fund exciting updates"
                )
                
                ImpactItem(
                    icon: "heart.fill",
                    title: "Ad-Free",
                    description: "Forever, thanks to you"
                )
            }
        }
        .accessibilityIdentifier("impactSection")
    }
}

#Preview {
    ImpactSection()
}

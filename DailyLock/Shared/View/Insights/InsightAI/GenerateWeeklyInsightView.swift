//
//  GenerateWeeklyInsightView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/6/25.
//

import FoundationModels
import SwiftUI

struct GenerateWeeklyInsightView: View {
    
    let generator: InsightGenerator
    
    @Environment(\.isDark) private var isDark
    
    let closure: () async throws -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.accent.opacity(0.1),
                                Color.accent.opacity(0.05),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "sparkles.rectangle.stack")
                    .font(.system(size: 36))
                    .foregroundStyle(.accent.gradient)
                    .symbolEffect(.pulse)
            }
            
            VStack(spacing: 8) {
                Text("Generate Weekly Insights")
                    .font(.headline)
                    .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                
                Text("Discover patterns and get personalized suggestions")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            GetInsightButton {
                try? await closure()
            }
        }
    }
}

#Preview {
    GenerateWeeklyInsightView(generator: InsightGenerator.init(entries: MomentumEntry.samples), closure: {})
}

//
//  SmallStreakView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/24/25.
//

import SwiftUI
import WidgetKit

struct SmallStreakView: View {
    let streakInfo: StreakInfo
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.largeTitle)
                .foregroundStyle(
                    LinearGradient(
                        colors: streakInfo.isGracePeriodActiveNow ? [.orange, .yellow] : [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(.pulse.byLayer, isActive: streakInfo.count > 0)
            
            Text("\(streakInfo.count)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
            
            Text(streakInfo.count == 1 ? "Day" : "Days")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if streakInfo.isGracePeriodActiveNow {
                Text("Complete today!")
                    .font(.caption2)
                    .foregroundStyle(.orange)
            }
        }
        .widgetURL(URL(string: "dailylock://insights"))
    }
}

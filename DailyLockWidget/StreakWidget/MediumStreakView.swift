//
//  MediumStreakView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/24/25.
//

import SwiftUI
import WidgetKit

struct MediumStreakView: View {
    let streakInfo: StreakInfo
    let longestStreak: Int
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Label("Current", systemImage: "flame.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(streakInfo.count) days")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                
                if streakInfo.isGracePeriodActiveNow {
                    Label("Grace period active", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Label("Best", systemImage: "trophy.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(longestStreak) days")
                    .font(.title3)
                    .foregroundStyle(.primary)
                
                ProgressView(value: Double(streakInfo.count), total: Double(max(longestStreak, streakInfo.count)))
                    .tint(.accent)
            }
        }
        .widgetURL(URL(string: "dailylock://insights"))
    }
}

//
//  HealthMoodSummary.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/16/25.
//

import Foundation
import SwiftUI

struct HealthMoodSummary {
    let averageValence: Double
    let totalEntries: Int
    let dateRange: ClosedRange<Date>
    let distribution: [Sentiment: Int]
    let trend: MoodTrend
    
    enum MoodTrend {
        case improving
        case stable
        case declining
        
        var icon: String {
            switch self {
            case .improving: "arrow.up.circle.fill"
            case .stable: "equal.circle.fill"
            case .declining: "arrow.down.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .improving: .green
            case .stable: .blue
            case .declining: .orange
            }
        }
    }
}

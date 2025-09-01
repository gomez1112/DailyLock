//
//  StreakEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/24/25.
//

import Foundation
import WidgetKit

// StreakEntry.swift
struct StreakEntry: TimelineEntry {
    let date: Date
    let currentStreak: Int
    let longestStreak: Int
    let isInGracePeriod: Bool
}

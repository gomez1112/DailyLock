//
//  HealthMoodEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/16/25.
//

import Foundation
import HealthKit
import SwiftUI

struct HealthMoodEntry: Identifiable {
    let id = UUID()
    let date: Date
    let valence: Double
    let labels: [HKStateOfMind.Label]
    let kind: HKStateOfMind.Kind
    let associations: [HKStateOfMind.Association]
    let metadata: [String: Any]?
    
    var sentiment: Sentiment {
        if valence > 0.3 { return .positive }
        if valence < -0.3 { return .negative }
        return .indifferent
    }
    
    var dominantLabel: HKStateOfMind.Label? {
        labels.first
    }
}


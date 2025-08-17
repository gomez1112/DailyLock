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

//struct HealthInsight {
//    let title: String
//    let description: String
//    let icon: String
//    let value: String
//    let trend: Trend
//    
//    enum Trend {
//        case up, down, stable
//        
//        var color: Color {
//            switch self {
//            case .up: .green
//            case .down: .red
//            case .stable: .blue
//            }
//        }
//        
//        var icon: String {
//            switch self {
//            case .up: "arrow.up.right"
//            case .down: "arrow.down.right"
//            case .stable: "arrow.right"
//            }
//        }
//    }
//}

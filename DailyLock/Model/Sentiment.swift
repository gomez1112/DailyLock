//
//  Sentiment.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import HealthKit
import SwiftUI

enum Sentiment: String, Codable, CaseIterable, Identifiable {
    
    case positive
    case indifferent
    case negative
    
    var id: Self { self }
   
    var gradient: [Color] {
        switch self {
            case .positive: ColorPalette.sentimentPositiveGradient
            case .indifferent: ColorPalette.sentimentIndifferentGradient
            case .negative: ColorPalette.sentimentNegativeGradient
        }
    }
    
    var symbol: String {
        switch self {
            case .positive: "sun.max.fill"
            case .indifferent: "cloud.fill"
            case .negative: "cloud.rain.fill"
        }
    }
    
    var inkIntensity: Double {
        switch self {
            case .positive: DesignSystem.Text.positiveInkIntensity
            case .indifferent: DesignSystem.Text.indifferentInkIntensity
            case .negative: DesignSystem.Text.negativeInkIntensity
        }
    }
    
    var color: Color {
        gradient.first ?? .gray
    }
    
    var accessibilityDescription: String {
        switch self {
            case .positive: return "Positive mood"
            case .indifferent: return "Indifferent mood"
            case .negative: return "Negative mood"
        }
    }
    
    // MARK: - HealthKit Integration Properties
    
    /// The emotional valence score (-1.0 to 1.0) for HealthKit.
    var valence: Double {
        switch self {
            case .positive: return 0.7
            case .indifferent: return 0.0
            case .negative: return -0.7
        }
    }
    
    /// The corresponding `HKStateOfMind.Label` for this sentiment.
    var label: HKStateOfMind.Label {
        switch self {
            case .positive: .happy
            case .indifferent: .indifferent
            case .negative: .sad
        }
    }
}

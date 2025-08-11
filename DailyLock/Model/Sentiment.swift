//
//  Sentiment.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

enum Sentiment: String, Codable, CaseIterable, Identifiable {
    
    case positive
    case neutral
    case negative
    
    var id: Self { self }
    
    var gradient: [Color] {
        switch self {
            case .positive: ColorPalette.sentimentPositiveGradient
            case .neutral: ColorPalette.sentimentNeutralGradient
            case .negative: ColorPalette.sentimentNegativeGradient
        }
    }
    
    var symbol: String {
        switch self {
            case .positive: "sun.max.fill"
            case .neutral: "cloud.fill"
            case .negative: "cloud.rain.fill"
        }
    }
    
    var inkIntensity: Double {
        switch self {
            case .positive: DesignSystem.Text.positiveInkIntensity
            case .neutral: DesignSystem.Text.neutralInkIntensity
            case .negative: DesignSystem.Text.negativeInkIntensity
        }
    }
    
    var color: Color {
        gradient.first ?? .gray
    }
    
    var accessibilityDescription: String {
        switch self {
        case .positive: return "Positive mood"
        case .neutral: return "Neutral mood"
        case .negative: return "Negative mood"
        }
    }
}

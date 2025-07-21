//
//  Sentiment.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

enum Sentiment: String, Codable, CaseIterable, Identifiable {
    case positive = "positive"
    case neutral = "neutral"
    case negative = "negative"
    
    var id: Self { self }
    
    var gradient: [Color] {
        switch self {
            case .positive:
                return [Color(hex: "FFE5B4"), Color(hex: "FFDAB9"), Color(hex: "FFD700")]
            case .neutral:
                return [Color(hex: "E8E8E8"), Color(hex: "D3D3D3"), Color(hex: "C0C0C0")]
            case .negative:
                return [Color(hex: "B0C4DE"), Color(hex: "87CEEB"), Color(hex: "6495ED")]
        }
    }
    
    var symbol: String {
        switch self {
            case .positive: return "sun.max.fill"
            case .neutral: return "cloud.fill"
            case .negative: return "cloud.rain.fill"
        }
    }
    
    var inkIntensity: Double {
        switch self {
            case .positive: return 0.9
            case .neutral: return 0.7
            case .negative: return 0.5
        }
    }
    
    var color: Color {
        gradient.first ?? .gray
    }
}

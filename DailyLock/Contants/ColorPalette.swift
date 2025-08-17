//
//  ColorPalette.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/6/25.
//

import Foundation
import SwiftUI

enum ColorPalette {
    
    static let lightPaperBackground = SwiftUI.Color(hex: "FBF8F3") ?? .black
    static let darkPaperBackground = SwiftUI.Color(hex: "1C1C1E") ?? .black
    static let lightCardBackground = SwiftUI.Color(.white) //
    static let darkCardBackground = SwiftUI.Color(hex: "2C2C2E") ?? .black //
    static let lightLineColor = SwiftUI.Color(hex: "E8E8E8") ?? .black //
    static let darkLineColor = SwiftUI.Color(hex: "3A3A3C") ?? .black//
    static let lightInkColor = SwiftUI.Color(hex: "2c3e50") ?? .black //
    static let darkInkColor = SwiftUI.Color(hex: "E5E5E7") ?? .black //
    
    // MARK: Sentiment Colors
    static let sentimentPositiveGradient = [SwiftUI.Color(hex: "FFE5B4") ?? .black, SwiftUI.Color(hex: "FFDAB9") ?? .black, SwiftUI.Color(hex: "FFD700") ?? .black ]
    static let sentimentIndifferentGradient = [SwiftUI.Color(hex: "E8E8E8") ?? .black, SwiftUI.Color(hex: "D3D3D3") ?? .black, SwiftUI.Color(hex: "C0C0C0") ?? .black ]
    static let sentimentNegativeGradient = [SwiftUI.Color(hex: "B0C4DE") ?? .black, SwiftUI.Color(hex: "87CEEB") ?? .black, SwiftUI.Color(hex: "6495ED") ?? .black]
    
    // MARK: Feature Colors
    static let premiumGradient = [SwiftUI.Color(hex: "FFD700") ?? .black, SwiftUI.Color(hex: "FFA500") ?? .black]
    static let waxSealGradient = [SwiftUI.Color(hex: "8B0000") ?? .black, SwiftUI.Color(hex: "A52A2A") ?? .black, SwiftUI.Color(hex: "8B0000") ?? .black] //
    static let waxSealColor = SwiftUI.Color(hex: "8B0000") ?? .black //
    
    // MARK: Lock Button Colors
    static let canLockLightGradient = [SwiftUI.Color(hex: "2c3e50") ?? .black, SwiftUI.Color(hex: "34495e") ?? .black]
    static let canLockDarkGradient = [SwiftUI.Color(hex: "5856D6") ?? .black, SwiftUI.Color(hex: "7C7AFF") ?? .black]
    
    // MARK: Component Specific
    static let insightsCardGradient = premiumGradient //
}

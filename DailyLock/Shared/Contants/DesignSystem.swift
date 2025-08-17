//
//  DesignSystem.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/6/25.
//

import Foundation
import SwiftUI

enum DesignSystem {
    enum Spacing {
        static let small = unit              // 8pt
        static let regular = unit * 2        // 16pt
        static let medium = unit * 3         // 24pt
        static let large = unit * 4          // 32pt
        static let xLarge = unit * 5         // 40pt
        static let xxLarge = unit * 6        // 48pt
        static let xxxLarge = unit * 7       // 56pt

        static let headerCircleSize: CGFloat = 120
    }
    enum CornerRadius {
        
    }
    enum Shadow {
        static let lightShadowOpacity = 0.05
        static let darkShadowOpacity = 0.3
        static let lightShadowColor = Color.black.opacity(lightShadowOpacity)
        static let darkShadowColor = Color.black.opacity(darkShadowOpacity)
        
        static let shadowSmall = unit           // 8pt
        static let shadowRegular = unit * 1.25  // 10pt
        static let shadowMedium = unit * 1.5    // 12pt
        static let shadowLarge = unit * 2
    }
    
    enum Text {
        // MARK: Character Limits
        static let maxCharacterCount = 180 //
        static let minimumCharacterCount = 1 //
        
        // MARK: Text Properties
        static let inkOpacity: Double = 0.0 //
        static let inkOpacityDenominator: Double = 20.0 //
        static let inkOpacityMaxDenominator: Double = 180.0 //
        static let hapticFeedbackInterval = 10 //
        
        // MARK: Sentiment Intensities
        static let positiveInkIntensity = 3.0 //
        static let indifferentInkIntensity = 2.0 //
        static let negativeInkIntensity = 1.0 //
        
        // MARK: TextView Properties
        static let defaultLineSpacing: CGFloat = 12 //
        static let minLineLimit: Int = 8 //
        static let maxLineLimit: Int = 10 //
        enum Font {
            // Custom Font Sizes
            static let sentenceSerifSize: CGFloat = 20
            static let dateScriptSize: CGFloat = 24
            
            // System Font Sizes (based on unit system)
            static let small = unit //
            static let regular = unit * 1.5  // 12pt //
            static let medium = unit * 2     // 16pt //
            static let large = unit * 3      // 24pt //
            
            // Component Specific Sizes
            static let sentimentIcon: CGFloat = 14 //

            
            // Timeline Specific
            static let timelineDate: CGFloat = 20 //
            static let timelineSentiment: CGFloat = 14 //
            static let timelineLock: CGFloat = 12 //
            static let timelineEntryText: CGFloat = 15 //
        }
    }
}

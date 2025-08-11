//
//  Feature.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/6/25.
//

import Foundation

enum Feature {
    enum Entry {
        static let cardVerticalSpacing: CGFloat = 24
        static let entryCardSpacing: CGFloat = 20
        static let sentimentIconSpacing: CGFloat = 8
        static let lockTimeIconSpacing: CGFloat = 4
        static let cardPadding: CGFloat = 32
        static let cardHorizontalPadding: CGFloat = 40
        static let lockTimeFontSize: CGFloat = 12
    }
    enum Timeline {
        static let mainVStackSpacing: CGFloat = 40
        static let monthSectionSpacing: CGFloat = 20
        static let headerBottomPadding: CGFloat = 20
        static let entriesSpacerMin: CGFloat = 100
        static let transitionScale: CGFloat = 0.95
        
        // Entry Component
        static let dateBadgeWidth: CGFloat = 50
        static let entrySpacing: CGFloat = 20
        static let verticalPadding: CGFloat = 8
        static let entryCardPadding: CGFloat = 16
        static let entryTextOpacity: Double = 0.8
        static let entryTextLineLimit: Int = 2
        
        static let hoveredShadowYOffset: CGFloat = 4
        static let shadowYOffset: CGFloat = 2
        
        // Shadows
#if os(macOS)
        static let hoveredShadowRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 6
#else
        static let hoveredShadowRadius: CGFloat = 8
        static let shadowRadius: CGFloat = 4
#endif
        
        // Summary
        static let summaryHorizontalPadding: CGFloat = 32
        static let summaryVerticalPadding: CGFloat = 12
        static let summaryCornerRadius: CGFloat = 12
        
        // Connector
        static let connectorSpacing: CGFloat = 20
        static let connectorLineWidth: CGFloat = 1
        static let connectorLineHeight: CGFloat = 30
        static let connectorLeadingPadding: CGFloat = 25
    }
    enum Insight {
        static let minimumEntriesForInsights = 5
        static let chartHeight: CGFloat = 180
        static let chartHeightCompact: CGFloat = 140
        static let moodBarCornerRadius: CGFloat = 6
    }
    enum Achievements {
        static let currentStreak = 0
        static let streakMilestone = 3
        static let achievementDisplayDuration: Double = 3.5
        static let confettiParticleCount = 50
        static let numberOfParticles = 100
        
        // Particle Properties
        static let particleYPosition: Double = -20
        static let particleMinSize: Double = 8
        static let particleMaxSize: Double = 16
        static let particleMinRotation: Double = 0
        static let particleMaxRotation: Double = 360
        static let particleMinDuration: Double = 2
        static let particleMaxDuration: Double = 4
        static let particleOpacity = 1.0
    }
    enum Onboarding {
        static let totalPages = 5
        static let pageIndicatorBottomPadding: CGFloat = 50
        static let skipButtonPadding: CGFloat = 16
        static let tabAnimationResponse: Double = 0.5
        static let tabAnimationDamping: Double = 0.8
    }
    enum Paper {
        
    }
    enum Paywall {
        
        enum Tips {
            
            // Style specific
            static let loadingProgressScale: CGFloat = 1.4
            static let loadingVStackSpacing: CGFloat = 12 //
            static let loadingMinHeight: CGFloat = 70 //
            static let cornerRadius: CGFloat = 16 //
            static let shadowRadius: CGFloat = 4 //
            static let monthlyGoalAmount = 100.0
        }
        
    }
    enum Search {
        
    }
    enum Settings {
        
    }
    enum Style {
        
    }
}

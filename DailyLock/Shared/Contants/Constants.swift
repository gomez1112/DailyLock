//
//  Constants.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/23/25.
//

import Foundation
import SwiftUI

// MARK: - Type Aliases
typealias AppLayout = Constants.Layout
typealias AppSpacing = DesignSystem.Spacing
typealias AppInsights = Feature.Insight
typealias AppTimeline = Feature.Timeline
typealias AppPremium = Constants.Premium
typealias AppNotification = Constants.Notification
typealias AppGetStarted = Constants.GetStarted
typealias AppOnboarding = Feature.Onboarding
typealias AppAchievements = Feature.Achievements
typealias AppWelcome = Constants.Welcome
typealias AppAnimation = Constants.Animation
typealias AppNotificationPermissionView = Constants.NotificationPermissionView
typealias AppEntry = Feature.Entry

let unit: CGFloat = 8
enum Constants {

    // MARK: - Layout
    enum Layout {
        // MARK: Corner Radius
        static let radiusSmall = unit           // 8pt
        static let radiusRegular = unit * 1.25  // 10pt
        static let radiusMedium = unit * 1.5    // 12pt
        static let radiusLarge = unit * 2       // 16pt
        static let radiusXLarge = unit * 3      // 24pt

        
        // MARK: Component Sizes
        static let waxSealSize: CGFloat = 80
        static let waxSealStartRadius: CGFloat = 5
        static let waxSealEndRadius: CGFloat = 40
        
        // MARK: Max Widths
        static let entryMaxWidth: CGFloat = 700
        static let lockedEntryMaxWidth: CGFloat = 600
        static let timelineContentMaxWidth: CGFloat = 800
        static let insightsCardMaxWidth: CGFloat = 900
        
        // MARK: Canvas Dimensions
#if os(iOS)
        static let canvasHeight: CGFloat = 350
        static let textViewHeight: CGFloat = 220
        static let innerContentHeight: CGFloat = 300
#else
        static let canvasHeight: CGFloat = 300
        static let textViewHeight: CGFloat = 180
        static let innerContentHeight: CGFloat = 250
#endif
        
        // MARK: Platform Specific
#if os(macOS)
        static let settingsWindowWidth: CGFloat = 500
        static let settingsWindowHeight: CGFloat = 600
        static let insightsPaywallMinWidth: CGFloat = 600
        static let insightsPaywallMinHeight: CGFloat = 700
#else
        static let insightsPaywallMinWidth: CGFloat = 0
        static let insightsPaywallMinHeight: CGFloat = 0
#endif
        static let timelineMonthSheetMinWidth: CGFloat = {
#if os(macOS)
            return 500
#else
            return 0
#endif
        }()
        static let timelineMonthSheetMinHeight: CGFloat = {
#if os(macOS)
            return 600
#else
            return 0
#endif
        }()
        
        // MARK: PaperTexture
        static let dotsCount = 50_000
        static let tileSize = 512
    }

    
    //MARK: - Notification
    enum Notification {
        static let id = "daily-reminder"
    }
}

// MARK: - View Specific Constants
// These are used in only one or two views, so they're separated for clarity

extension Constants {
    
    // MARK: - Locked Entry View
    
    // MARK: - Premium Feature
    enum Premium {
        static let iconCircleSize: CGFloat = 100
        static let buttonCornerRadius: CGFloat = 16
        static let cardCornerRadius: CGFloat = 24
        static let buttonShadowRadius: CGFloat = 10
        static let buttonShadowYOffset: CGFloat = 5
        static let verticalPadding: CGFloat = 24

        // MARK: Premium Preview View
        static let previewCrownFontSize: CGFloat = 60
        static let previewFeatureCarouselHeight: CGFloat = 200
        static let previewButtonCornerRadius: CGFloat = 16
        static let previewHorizontalPadding: CGFloat = 40
        static let previewVStackSpacing: CGFloat = 40
        static let previewButtonVStackSpacing: CGFloat = 16
    }
    
    // MARK: - GetStarted View
    enum GetStarted {
        static let vStackSpacing: CGFloat = 40
        static let checkmarkSpacing: CGFloat = 20
        static let animatedCheckmarksCount: Int = 3
        static let titleSpacing: CGFloat = 16
        static let horizontalPadding: CGFloat = 40
        static let buttonCornerRadius: CGFloat = 16
        static let buttonShadowRadius: CGFloat = 10
        static let buttonShadowYOffset: CGFloat = 5
        static let buttonScaleInactive: CGFloat = 0.9
        static let buttonSpringDelay: Double = 0.8
        static let checkmarkAnimationBaseDelay: Double = 0.2
        static let textOpacityDelay: Double = 0.1
    }
    enum Welcome {
        static let vStackSpacing: CGFloat = 40
        static let horizontalPadding: CGFloat = 40
        static let iconFontSize: CGFloat = 80
        static let iconInitialScale: CGFloat = 0.5
        static let animationDelay: Double = 0.2
        static let textYOffset: CGFloat = 30
        static let springResponse: Double = 0.8
        static let springDamping: Double = 0.7
    }
    // MARK: - Animation
    enum Animation {
        static let standardDuration: Double = 0.3
        static let springResponse: Double = 0.6
        static let springDamping: Double = 0.8
        static let delay = 0.1
        static let inkFadeInDuration: Double = 0.1
        static let confettiDuration: Double = 3.0
        
        // Scale Values
        static let lockButtonScale: CGFloat = 0.95
        static let lockAnimationScale: CGFloat = 0.97
        static let hoverScale: CGFloat = 1.02
        static let pressedScale: CGFloat = 0.97
        static let timelineHoveredScale: CGFloat = 1.02
    }
    // MARK: - Notification Permission View
    enum NotificationPermissionView {
        static let bellCount = 3
        static let bellSize: CGFloat = 50
        static let bellSpacing: CGFloat = 20
        static let bellsAnimationDuration: Double = 1
        static let mainVStackSpacing: CGFloat = 40
        static let titleSpacing: CGFloat = 16
        static let timePickerSpacing: CGFloat = 12
        static let timePickerHeight: CGFloat = 120
        static let contentHorizontalPadding: CGFloat = 40
        static let enableButtonCornerRadius: CGFloat = 16
        static let enableButtonHorizontalPadding: CGFloat = 0 // for .infinity
        static let laterButtonForegroundOpacity: Double = 1 // .secondary
    }
    
    // MARK: - Onboarding Feature Card
    enum OnboardingFeatureCard {
        static let iconFontSize: CGFloat = 40
        static let vStackSpacing: CGFloat = 16
        static let cardPadding: CGFloat = 16
    }
}

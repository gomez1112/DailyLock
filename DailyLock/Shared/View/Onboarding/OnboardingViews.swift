//
//  OnboardingViews.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/17/25.
//

import SwiftUI

struct OnboardingViews: View {
    let step: OnboardingStep
    let goNext: () -> Void
    let onFinish: () -> Void
    
    var body: some View {
        switch step {
            case .welcome:
                WelcomeView()
            case .concept:
                ConceptView()
            case .health:
                HealthKitPermissionView(onComplete: goNext)
            case .notifications:
                NotificationPermissionView(onComplete: goNext)
            case .premium:
                PremiumPreviewView()         
            case .getStarted:
                GetStartedView(onComplete: onFinish)
        }
    }
}

#Preview {
    OnboardingViews(step: .concept, goNext: {}, onFinish: {})
}

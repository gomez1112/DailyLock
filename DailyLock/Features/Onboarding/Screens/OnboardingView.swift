//
//  OnboardingView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.isDark) private var isDark
    @Environment(\.dismiss) private var dismiss
    @Environment(AppDependencies.self) private var dependencies
    
    
    @State private var currentPage = 0
    
    private let totalPages = Feature.Onboarding.totalPages
    
    var body: some View {
        
        #if os(macOS)
        macOSOnboardingView(currentPage: $currentPage, haptics: dependencies.haptics, isDark: isDark)
        #else
        iOSOnboardingView(currentPage: $currentPage, haptics: dependencies.haptics, isDark: isDark)
        #endif
    }
}

#Preview(traits: .previewData) {
    OnboardingView()
}

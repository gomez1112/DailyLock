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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var currentPage = 0
    
    // Updated to include HealthKit permission page
    private let totalPages = 6 // Increased from 5 to 6
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                Image(isDark ? .defaultDarkPaper : .defaultLightPaper)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // On compact views, the skip button is part of the VStack flow.
                    if horizontalSizeClass == .compact {
                        skipButton
                            .padding()
                    }
                    
                    TabView(selection: $currentPage) {
                        WelcomeView().tag(0)
                        ConceptView().tag(1)
                        HealthKitPermissionView(onComplete: goToNextPage).tag(2) // NEW
                        NotificationPermissionView(onComplete: goToNextPage).tag(3)
                        PremiumPreviewView().tag(4)
                        GetStartedView(onComplete: completeOnboarding).tag(5)
                    }
#if !os(macOS)
                    .tabViewStyle(.page(indexDisplayMode: .never))
#endif
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                    
                    CustomPageIndicator(currentPage: currentPage, totalPages: totalPages)
                        .padding(.bottom, 50)
                }
                
                // On regular views, the skip button is an overlay for better placement.
                if horizontalSizeClass == .regular {
                    skipButton
                        .padding(32)
                }
            }
        }
#if !os(macOS)
        .statusBarHidden()
#endif
        .onChange(of: currentPage) { _, _ in
            dependencies.haptics.select()
        }
    }
    
    private var skipButton: some View {
        Button("Skip") {
            completeOnboarding()
        }
        .foregroundStyle(.secondary)
        .opacity(currentPage < totalPages - 1 ? 1 : 0)
        .accessibilityIdentifier("skipButton")
    }
    
    private func goToNextPage() {
        withAnimation {
            currentPage = min(currentPage + 1, totalPages - 1)
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.spring()) {
            dependencies.syncedSetting.save(onboardingCompleted: true)
        }
        dismiss()
    }
}

#Preview(traits: .previewData) {
    OnboardingView()
}

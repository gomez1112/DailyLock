//
//  OnboardingView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AppDependencies.self) private var dependencies
    
    @State private var currentPage = 0
    @State private var dragOffset: CGSize = .zero
    
    private let totalPages = AppOnboarding.totalPages
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient that changes with pages
                WritingPaper()
                    .ignoresSafeArea()
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("onboardingRoot")
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        completeOnboarding()
                    }
                    .foregroundStyle(.secondary)
                    .padding(AppOnboarding.skipButtonPadding)
                    .opacity(currentPage < totalPages - 1 ? 1 : 0)
                    .accessibilityIdentifier("skipButton")
                    .accessibilityLabel("Skip onboarding")
                }
                
                // Page content
                TabView(selection: $currentPage) {
                    WelcomeView()
                        .tag(0)
                        .accessibilityIdentifier("onboardingPage0")
                    
                    ConceptView()
                        .tag(1)
                        .accessibilityIdentifier("onboardingPage1")
                    
                    NotificationPermissionView()
                        .tag(2)
                        .accessibilityIdentifier("onboardingPage2")
                    
                    PremiumPreviewView()
                        .tag(3)
                        .accessibilityIdentifier("onboardingPage3")
                        
                    
                    GetStartedView(onComplete: completeOnboarding)
                        .tag(4)
                        .accessibilityIdentifier("onboardingPage4")
                }
                #if !os(macOS)
                .tabViewStyle(.page(indexDisplayMode: .never))
                #endif
                .animation(
                    .spring(response: AppOnboarding.tabAnimationResponse,
                            dampingFraction: AppOnboarding.tabAnimationDamping),
                    value: currentPage
                )
                .accessibilityIdentifier("onboardingTabView")
                .accessibilityLabel("Onboarding pages")
                .accessibilityValue("Page \(currentPage + 1) of \(totalPages)")
                
                // Custom page indicator
                CustomPageIndicator(
                    currentPage: currentPage,
                    totalPages: totalPages
                )
                .padding(.bottom, AppOnboarding.pageIndicatorBottomPadding)
                .accessibilityIdentifier("pageIndicator")
                .accessibilityLabel("Page indicator")
                .accessibilityValue("Page \(currentPage + 1) of \(totalPages)")
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("onboardingMainStack")
        }
        #if !os(macOS)
        .statusBarHidden()
        #endif
        .onChange(of: currentPage) { _, _ in
            dependencies.haptics.select()
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

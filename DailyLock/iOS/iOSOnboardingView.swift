//
//  iOSOnboardingView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/17/25.
//

import SwiftUI

struct iOSOnboardingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(AppDependencies.self) private var dependencies
    
    @Binding var currentPage: Int
    
    let haptics: HapticEngine
    private let totalPages = OnboardingStep.totalPages
    let isDark: Bool
    
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
                        ForEach(OnboardingStep.allCases) { step in
                            OnboardingViews(step: step, goNext: goToNextPage, onFinish: completeOnboarding)
                                .tag(step.rawValue)
                        }
                    }
#if !os(macOS)
                    .tabViewStyle(.page(indexDisplayMode: .never))
#endif
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                    
                    CustomPageIndicator(currentPage: currentPage, totalPages: OnboardingStep.allCases.count)
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
            haptics.select()
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
    iOSOnboardingView(currentPage: .constant(2), haptics: HapticEngine(), isDark: false)
}

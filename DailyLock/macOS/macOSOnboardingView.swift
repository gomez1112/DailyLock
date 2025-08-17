//
//  macOSOnboardingView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/17/25.
//

import SwiftUI

struct macOSOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppDependencies.self) private var dependencies
    
    @Binding var currentPage: Int
    
    let haptics: HapticEngine
    let isDark: Bool
    
    private let stesRing = Ring(OnboardingStep.allCases)
    private var step: OnboardingStep {
        OnboardingStep(rawValue: currentPage) ?? .welcome
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(isDark ? .defaultDarkPaper : .defaultLightPaper)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    skipButton
                        .padding(16)
                }
                OnboardingViews(step: step, goNext: goNextPage, onFinish: completeOnboarding)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                    .frame(maxWidth: 860, maxHeight: 520)
                    .shadow(radius: 12, y: 6)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                VStack(spacing: 20) {
                    CustomPageIndicator(currentPage: currentPage, totalPages: OnboardingStep.totalPages)
                    HStack {
                        Button("Back") {
                            goBack()
                        }
                        .keyboardShortcut(.leftArrow, modifiers: [])
                        Spacer()
                        Button(step == .getStarted ? "Get Started" : "Continue") {
                            goNextOrFinish()
                        }
                        .keyboardShortcut(.rightArrow, modifiers: [])
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal, 24)
                }
                .padding([.horizontal, .bottom], 32)
            }
        }
        .frame(minWidth: 500, minHeight: 500) // Give the window a reasonable default size
        .onChange(of: currentPage) {
            haptics.select()
        }
    }
    private var skipButton: some View {
        Button("Skip") { completeOnboarding() }
            .foregroundStyle(.secondary)
            .opacity(currentPage < OnboardingStep.totalPages - 1 ? 1 : 0)
            .accessibilityIdentifier("skipButton")
    }
    
    private func goNextOrFinish() {
        step == .getStarted ? completeOnboarding() : goNextPage()
    }
    private func goNextPage() {
        withAnimation {
            currentPage = min(currentPage + 1, OnboardingStep.totalPages - 1)
        }
    }
    private func goBack() {
        withAnimation {
            currentPage = max(currentPage - 1, 0)
        }
    }
    private func completeOnboarding() {
        withAnimation(.spring()) {
            dependencies.syncedSetting.save(onboardingCompleted: true)
        }
    }
}

#Preview(traits: .previewData) {
    macOSOnboardingView(currentPage: .constant(2), haptics: HapticEngine(), isDark: false)
}

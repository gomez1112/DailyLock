//
//  WelcomeView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var appearAnimation = false
    
    var body: some View {
        OnboardingPageView {
            // Visual Panel
            Image(systemName: "book.closed.fill")
                .font(.system(size: AppWelcome.iconFontSize))
                .foregroundStyle(.accent)
                .symbolEffect(.bounce, value: appearAnimation)
                .scaleEffect(appearAnimation ? 1 : AppWelcome.iconInitialScale)
                .opacity(appearAnimation ? 1 : 0)
                .accessibilityIdentifier("welcomeIcon")
                .accessibilityLabel("Welcome book icon")
        } content: {
            // Content Panel
            VStack(spacing: 16) {
                Text("Welcome to DailyLock")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .offset(y: appearAnimation ? 0 : AppWelcome.textYOffset)
                    .opacity(appearAnimation ? 1 : 0)
                    .accessibilityIdentifier("welcomeTitle")
                    .accessibilityAddTraits(.isHeader)
                
                Text("Capture life's moments,\none sentence at a time")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .offset(y: appearAnimation ? 0 : AppWelcome.textYOffset)
                    .opacity(appearAnimation ? 1 : 0)
                    .accessibilityIdentifier("welcomeSubtitle")
                    .accessibilityHint("App tagline")
            }
            .accessibilityElement(children: .combine)
        }
        .onAppear {
            withAnimation(.spring(response: AppWelcome.springResponse, dampingFraction: AppWelcome.springDamping).delay(AppWelcome.animationDelay)) {
                appearAnimation = true
            }
        }
    }
}

#Preview {
    WelcomeView()
}

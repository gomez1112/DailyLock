//
//  WelcomeView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//
//

import SwiftUI

struct WelcomeView: View {
    @State private var appearAnimation = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        OnboardingPageView {
            // Visual Panel
            Image(systemName: "book.closed.fill")
            // Make the icon much larger on big screens to fill the space beautifully.
                .font(.system(size: horizontalSizeClass == .regular ? 180 : 80))
                .foregroundStyle(.accent)
                .symbolEffect(.bounce, value: appearAnimation)
                .scaleEffect(appearAnimation ? 1 : 0.5)
                .opacity(appearAnimation ? 1 : 0)
        } content: {
            // Content Panel
            VStack(spacing: 16) {
                Text("Welcome to DailyLock")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .offset(y: appearAnimation ? 0 : 30)
                    .opacity(appearAnimation ? 1 : 0)
                
                Text("Capture life's moments,\none sentence at a time")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .offset(y: appearAnimation ? 0 : 30)
                    .opacity(appearAnimation ? 1 : 0)
                    .animation(.spring().delay(0.1), value: appearAnimation)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                appearAnimation = true
            }
        }
    }
}
//import SwiftUI
//
//struct WelcomeView: View {
//    @State private var appearAnimation = false
//    
//    var body: some View {
//        OnboardingPageView {
//            // Visual Panel
//            Image(systemName: "book.closed.fill")
//                .font(.system(size: AppWelcome.iconFontSize))
//                .foregroundStyle(.accent)
//                .symbolEffect(.bounce, value: appearAnimation)
//                .scaleEffect(appearAnimation ? 1 : AppWelcome.iconInitialScale)
//                .opacity(appearAnimation ? 1 : 0)
//                .accessibilityIdentifier("welcomeIcon")
//                .accessibilityLabel("Welcome book icon")
//        } content: {
//            // Content Panel
//            VStack(spacing: 16) {
//                Text("Welcome to DailyLock")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.center)
//                    .offset(y: appearAnimation ? 0 : AppWelcome.textYOffset)
//                    .opacity(appearAnimation ? 1 : 0)
//                    .accessibilityIdentifier("welcomeTitle")
//                    .accessibilityAddTraits(.isHeader)
//                
//                Text("Capture life's moments,\none sentence at a time")
//                    .font(.title3)
//                    .foregroundStyle(.secondary)
//                    .multilineTextAlignment(.center)
//                    .offset(y: appearAnimation ? 0 : AppWelcome.textYOffset)
//                    .opacity(appearAnimation ? 1 : 0)
//                    .accessibilityIdentifier("welcomeSubtitle")
//                    .accessibilityHint("App tagline")
//            }
//            .accessibilityElement(children: .combine)
//        }
//        .onAppear {
//            withAnimation(.spring(response: AppWelcome.springResponse, dampingFraction: AppWelcome.springDamping).delay(AppWelcome.animationDelay)) {
//                appearAnimation = true
//            }
//        }
//    }
//}
//
//#Preview {
//    WelcomeView()
//}

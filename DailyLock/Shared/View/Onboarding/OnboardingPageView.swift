//
//  OnboardingPageView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/16/25.
//

import SwiftUI

/// A responsive container for onboarding screens that adapts its layout
/// from a vertical stack on compact devices to a two-panel horizontal layout
/// on devices with regular horizontal size classes (like iPad and macOS).
struct OnboardingPageView<Visual: View, Content: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let visual: Visual
    let content: Content
    
    init(@ViewBuilder visual: () -> Visual, @ViewBuilder content: () -> Content) {
        self.visual = visual()
        self.content = content()
    }
    
    var body: some View {
        if horizontalSizeClass == .regular {
            // Two-panel layout for macOS and iPad (landscape)
            HStack(spacing: 0) {
                // Visual Panel (Left)
                ZStack {
                    visual
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Content Panel (Right)
                VStack {
                    content
                }
                .frame(maxWidth: 420) // Constrain content width for readability
                .padding(48)
            }
        } else {
            // Single-column layout for iOS
            VStack(spacing: 0) {
                ZStack {
                    visual
                }
                .frame(maxHeight: .infinity, alignment: .center)
                
                VStack {
                    content
                }
                .padding(32)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}

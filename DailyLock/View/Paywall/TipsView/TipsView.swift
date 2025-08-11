//
//  TipsView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//
//  This file is now compliant with iOS 26.0 deprecations regarding UIScreen usage.
//

import SwiftUI

struct TipsView: View {
    @Environment(\.isDark) private var isDark
    @Environment(\.deviceStatus) private var deviceStatus
    @Environment(\.dismiss) private var dismiss
    @Environment(AppDependencies.self) private var dependencies
    
    @State private var heartAnimationTask: Task<Void, Never>?
    
    @State private var showThankYou = false
    @State private var purchasedTipName = ""
    @State private var purchasedTipAmount: Decimal = 0.0
    @State private var animateHeart = false
    @State private var floatingHearts: [FloatingHeart] = []
    @State private var selectedTipIndex: Int? = nil
    @State private var coffeeCupSteam = false
    @State private var developerMessageExpanded = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background
                    Image(isDark ? .brownDarkTexture : .brownLightTexture)
                        .resizable()
                        .ignoresSafeArea()
                    
                    // Floating hearts background animation
                    floatingHeartsView
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            // Hero Section
                            HeroSection(animateHeart: $animateHeart, coffeeCupSteam: $coffeeCupSteam)
                                .padding(.top, 30)
                            
                            // Developer Message
                            DeveloperMessage(developerMessageExpanded: $developerMessageExpanded)
                                .padding(.top, 30)
                                .padding(.horizontal, deviceStatus == .compact ? 20 : 40)
                                
                            SupportGoal()
                                .padding(.top, 30)
                                .padding(.horizontal, deviceStatus == .compact ? 20 : 40)
                            TipsOptionSection(purchasedTipName: $purchasedTipName, purchasedTipAmount: $purchasedTipAmount, selectedTipIndex: $selectedTipIndex, showThankYou: $showThankYou)

                            ImpactSection()
                                .padding(.top, 40)
                                .padding(.horizontal, deviceStatus == .compact ? 20 : 40)
                            FooterSection()
                                .padding(.top, 30)
                                .padding(.bottom, 40)
                                
                        }
                    }
                }
                .onAppear {
                    // Hero entrance
                    animateHeart = true
                    
                    // Drive the cup “steam” forever (it uses .animation(value:) in HeroSection)
                    withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: false)) {
                        coffeeCupSteam = true
                    }
                    
                    // Background floating hearts
                    startHeartAnimations(viewHeight: geometry.size.height)
                }
                .alert("Thank You! 💖", isPresented: $showThankYou) {
                    Button("You're Welcome!") {
                        showThankYou = false
                        // Create celebration hearts
                        createCelebrationHearts(viewHeight: geometry.size.height)
                        dependencies.haptics.success()
                    }
                } message: {
                    Text("Your \(purchasedTipName) means the world to me! Thanks for believing in DailyLock's journey.")
                }
                .onChange(of: showThankYou) { _, newValue in
                    if !newValue {
                        purchasedTipName = ""
                        purchasedTipAmount = 0
                        selectedTipIndex = nil
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityIdentifier("tipsDoneButton")
                }
            }
            .navigationTitle("Support DailyLock")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
        .onDisappear {
            heartAnimationTask?.cancel()
        }
    }
    // MARK: - Floating Hearts
    private var floatingHeartsView: some View {
        ZStack {
            ForEach(floatingHearts) { heart in
                Image(systemName: "heart.fill")
                    .font(.system(size: heart.size))
                    .foregroundStyle(heart.color.opacity(heart.opacity))
                    .offset(x: heart.x, y: heart.y)
                    .rotationEffect(.degrees(heart.rotation))
            }
        }
        .allowsHitTesting(false)
    }

    private func startHeartAnimations(viewHeight: CGFloat) {
        heartAnimationTask?.cancel()
        heartAnimationTask = Task { [viewHeight] in
            while !Task.isCancelled {
                    createFloatingHeart(viewHeight: viewHeight)
                // breathe
                try? await Task.sleep(for: .milliseconds(Int.random(in: 350...900)))
            }
        }
    }
    
    @MainActor
    private func createFloatingHeart(viewHeight: CGFloat) {
        // keep memory under control
        if floatingHearts.count > 80 {
            floatingHearts.removeFirst(floatingHearts.count - 80)
        }
        
        let heart = FloatingHeart(
            x: CGFloat.random(in: -150...150),
            y: viewHeight / 2,
            size: CGFloat.random(in: 12...24),
            color: [.red, .pink, .accent].randomElement()!,
            rotation: Double.random(in: -30...30),
            opacity: 0
        )
        
        floatingHearts.append(heart)
        
        withAnimation(.linear(duration: 5)) {
            if let idx = floatingHearts.firstIndex(where: { $0.id == heart.id }) {
                floatingHearts[idx].y = -100
                floatingHearts[idx].opacity = 0.6
            }
        }
        
        Task {
            try? await Task.sleep(for: .seconds(5))
                floatingHearts.removeAll { $0.id == heart.id }
        }
    }
    
    private func createCelebrationHearts(viewHeight: CGFloat) {
        Task {
            for _ in 0..<20 { createFloatingHeart(viewHeight: viewHeight)
                try? await Task.sleep(for: .milliseconds(40))
            }
        }
    }
}

// MARK: - Supporting Views

struct FloatingHeart: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let color: Color
    let rotation: Double
    var opacity: Double
}


#Preview(traits: .previewData) {
    TipsView()
}


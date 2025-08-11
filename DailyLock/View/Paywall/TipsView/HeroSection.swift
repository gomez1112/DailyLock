//
//  HeroSection.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import SwiftUI

struct HeroSection: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var animateHeart: Bool
    @Binding var coffeeCupSteam: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Animated Coffee Cup with Heart Steam
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.red.opacity(0.2),
                                Color.red.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .blur(radius: 30)
                    .opacity(animateHeart ? 0.8 : 0)
                
                // Coffee cup
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "8B4513") ?? .black, Color(hex: "A0522D") ?? .black],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        // ✅ Heart Steam Animation
                        ZStack {
                            ForEach(0..<5) { i in
                                SteamHeart(delay: Double(i) * 0.35)
                            }
                        }
                    )
                    .scaleEffect(animateHeart ? 1 : 0.5)
                    .rotationEffect(.degrees(animateHeart ? 0 : -10))
            }
            
            VStack(spacing: 12) {
                Text("Buy Me a Coffee")
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundStyle(colorScheme == .dark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                    .opacity(animateHeart ? 1 : 0)
                    .offset(y: animateHeart ? 0 : 20)
                
                Text("Every tip fuels late-night coding sessions")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(animateHeart ? 1 : 0)
                    .offset(y: animateHeart ? 0 : 20)
                    .animation(.easeInOut(duration: 2.5).delay(Double.random(in: 0...1.2)), value: coffeeCupSteam)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("tipsHeroSection")
    }
    private struct SteamHeart: View {
        @State private var animation = false
        let delay: Double
        
        var body: some View {
            Image(systemName: "heart.fill")
                .font(.system(size: 12))
                .foregroundStyle(.red.opacity(0.5))
                .scaleEffect(animation ? 1.8 : 0.5)
                .offset(x: CGFloat.random(in: -6...6),  // slight drift
                        y: animation ? -60 : -25)
                .opacity(animation ? 0 : 0.85)
                .blur(radius: animation ? 3 : 0)
                .task {
                    // staggered start
                    try? await Task.sleep(for: .seconds(delay))
                    await loop()
                }
        }
        
        private func loop() async {
            while true {
                withAnimation(.easeInOut(duration: 2.4)) { animation = true }   // rise + fade
                try? await Task.sleep(for: .seconds(2.4))
                animation = false                                           // instant reset (no reverse)
                try? await Task.sleep(for: .seconds(Double.random(in: 0.2...0.8)))
            }
        }
    }

    
}

#Preview {
    HeroSection(animateHeart: .constant(true), coffeeCupSteam: .constant(true))
}

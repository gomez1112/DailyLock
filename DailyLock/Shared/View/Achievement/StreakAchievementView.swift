//
//  StreakAchievementView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct StreakAchievementView: View {
    
    @Environment(\.isDark) private var isDark
    
    let streakCount: Int
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "flame.fill")
                .font(.system(size: AppSpacing.xxxLarge))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .accessibilityIdentifier("streakFlameImage")
                .accessibilityLabel("Streak Flame")
            
            Text("\(streakCount) Day Streak!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .accessibilityIdentifier("streakCountText")
                .accessibilityLabel("\(streakCount) day streak")
            
            Text("Keep the momentum going")
                .font(.body)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("streakEncouragementText")
                .accessibilityLabel("Keep the momentum going")
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("streakAchievementCard")
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: AppLayout.radiusXLarge)
                .fill(isDark ? ColorPalette.darkCardBackground : ColorPalette.lightCardBackground)
                .shadow(color: isDark ? DesignSystem.Shadow.darkShadowColor : DesignSystem.Shadow.lightShadowColor, radius: AppLayout.radiusLarge, y: DesignSystem.Shadow.shadowSmall)
        )
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: AppAnimation.springResponse, dampingFraction: AppAnimation.springDamping)) {
                scale = 1.0
                opacity = 1.0
            }
            
            // Auto dismiss after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: AppAnimation.standardDuration)) {
                    opacity = 0
                    scale = 0.8
                }
            }
        }
    }
}

#Preview {
    StreakAchievementView(streakCount: 4)
}

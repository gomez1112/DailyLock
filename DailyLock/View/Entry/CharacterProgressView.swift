//
//  CharacterProgressView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct CharacterProgressView: View {
    let progress: Double
    let current: Int
    let limit: Int
    
    var body: some View {
        VStack(spacing: 8) {
            // Character count label
            HStack {
                Spacer()
                Text("\(current)/\(limit)")
                    .font(.caption)
                    .foregroundStyle(textColor)
                    .contentTransition(.numericText())
                    .animation(.default, value: current)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Capsule()
                        .fill(.quaternary)
                        .frame(height: 4)
                    
                    // Progress fill with gradient
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 4)
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: progress)
                    
                    // Animated indicator dot
                    Circle()
                        .fill(.white)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(strokeColor, lineWidth: 2))
                        .offset(x: max(0, min(geometry.size.width - 12, geometry.size.width * progress - 6)))
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: 12)
            
            // Warning text
            if progress > 0.9 {
                Text(progress >= 1.0 ? "Character limit reached" : "Approaching character limit")
                    .font(.caption2)
                    .foregroundStyle(progress >= 1.0 ? .red : .orange)
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut, value: progress > 0.9)
            }
        }
    }
    
    private var gradientColors: [Color] {
        if progress >= 1.0 { return [.red, .pink] }
        if progress > 0.9 { return [.orange, .red] }
        if progress > 0.7 { return [.yellow, .orange] }
        return [.green, .mint]
    }
    
    private var strokeColor: Color {
        if progress >= 1.0 { return .red }
        if progress > 0.9 { return .orange }
        if progress > 0.7 { return .yellow }
        return .green
    }
    
    private var textColor: Color {
        if progress >= 1.0 { return .red }
        if progress > 0.9 { return .orange }
        return .secondary
    }
}

#Preview(traits: .previewData) {
    CharacterProgressView(progress: 0.5, current: 90, limit: 180)
}

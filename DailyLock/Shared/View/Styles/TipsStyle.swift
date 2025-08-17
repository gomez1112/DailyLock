//
//  TipsStyle.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/21/25.
//

import StoreKit
import SwiftUI

struct TipsStyle: ProductViewStyle {
    
    @Environment(\.isDark) private var isDark
    @State private var isHovered = false
    @State private var isPressed = false
    
    func makeBody(configuration: Configuration) -> some View {
        switch configuration.state {
                
            case .loading:
                VStack(spacing: Feature.Paywall.Tips.loadingVStackSpacing) {
                    // Animated loading state
                    ZStack {
                        Circle()
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 3)
                            .frame(width: 40, height: 40)
                        
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(
                                LinearGradient(
                                    colors: [.accent, .accent.opacity(0.5)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                            .frame(width: 40, height: 40)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: true)
                    }
                    
                    Text("Loading tip…")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: Feature.Paywall.Tips.loadingMinHeight)
                .padding()
                .cardBackground(cornerRadius: Feature.Paywall.Tips.cornerRadius, shadowRadius: Feature.Paywall.Tips.shadowRadius)
                
            case .failure(let error):
                VStack(spacing: 16) {
                    // Friendly error state
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "cup.and.saucer")
                            .font(.title)
                            .foregroundStyle(.yellow)
                            .overlay(
                                Image(systemName: "exclamationmark")
                                    .font(.caption)
                                    .foregroundStyle(.yellow)
                                    .offset(x: 12, y: -12)
                            )
                    }
                    
                    VStack(spacing: 8) {
                        Text("Oops! Spilled the coffee")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: Feature.Paywall.Tips.loadingMinHeight)
                .padding()
                .cardBackground(cornerRadius: Feature.Paywall.Tips.cornerRadius, shadowRadius: Feature.Paywall.Tips.shadowRadius)
                
            case .unavailable:
                VStack(spacing: 16) {
                    Image(systemName: "cup.and.saucer")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                        .symbolEffect(.pulse)
                    
                    Text("Tips are brewing...")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Check back in a moment")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: Feature.Paywall.Tips.loadingMinHeight)
                .padding()
                .cardBackground()
                
            case .success(let product):
                Button(action: configuration.purchase) {
                    HStack(spacing: 20) {
                        // Icon with background
                        ZStack {
                            configuration.icon
                                .symbolRenderingMode(.hierarchical)
                        }
                        
                        // Content
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(product.displayName)
                                    .font(.headline)
                                    .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                                
                                if product.id.contains("large") {
                                    Text("GENEROUS")
                                        .font(.system(size: 9, weight: .black))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(.accent)
                                        )
                                }
                            }
                            
                            Text(product.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        // Price with emphasis
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(product.displayPrice)
                                .font(.title3.bold())
                                .foregroundStyle(.accent)
                            
                            if let emoji = tipEmoji(for: product.id) {
                                Text(emoji)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        ZStack {
                            // Base background
                            RoundedRectangle(cornerRadius: Feature.Paywall.Tips.cornerRadius)
                                .fill(isDark ? ColorPalette.darkCardBackground : ColorPalette.lightCardBackground)
                            
                            // Hover gradient overlay
                            if isHovered {
                                RoundedRectangle(cornerRadius: Feature.Paywall.Tips.cornerRadius)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.accent.opacity(0.05),
                                                Color.accent.opacity(0.02)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Feature.Paywall.Tips.cornerRadius)
                            .strokeBorder(
                                isHovered ? Color.accent.opacity(0.3) : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: isHovered ? Color.accent.opacity(0.2) : (isDark ? DesignSystem.Shadow.darkShadowColor : DesignSystem.Shadow.lightShadowColor),
                        radius: isHovered ? 12 : Feature.Paywall.Tips.shadowRadius,
                        y: isHovered ? 6 : 2
                    )
                    .scaleEffect(isPressed ? 0.98 : (isHovered ? 1.02 : 1))
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isHovered)
                    .animation(.spring(response: 0.1, dampingFraction: 0.8), value: isPressed)
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    isHovered = hovering
                }
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                    isPressed = pressing
                }, perform: {})
                
            @unknown default:
                VStack(spacing: 16) {
                    Image(systemName: "cup.and.saucer")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                        .symbolEffect(.bounce)
                    
                    Text("Something's brewing...")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Please try again")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: Feature.Paywall.Tips.loadingMinHeight)
                .padding()
                .cardBackground(cornerRadius: Feature.Paywall.Tips.cornerRadius, shadowRadius: Feature.Paywall.Tips.shadowRadius)
        }
    }
    
    private func tipEmoji(for productId: String) -> String? {
        if productId.contains("small") {
            return "☕️"
        } else if productId.contains("medium") {
            return "☕️☕️"
        } else if productId.contains("large") {
            return "☕️☕️☕️"
        }
        return nil
    }
}

extension ProductViewStyle where Self == TipsStyle {
    static var tipStyle: TipsStyle { .init() }
}

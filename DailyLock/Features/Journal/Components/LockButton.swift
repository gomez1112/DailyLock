//
//  LockButton.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct LockButton: View {
    @Environment(\.isDark) private var isDark
    
    let canLock: Bool
    let action: () -> Void
    @State private var isPressed = false
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "lock.fill")
                    .font(.system(size: fontSize, weight: .semibold))
                    .accessibilityIdentifier("LockIcon")
                
                Text("Lock Today's Entry")
                    .font(.system(size: fontSize, weight: .semibold, design: .rounded))
                    .accessibilityIdentifier("LockButtonText")
            }
            .foregroundStyle(foregroundColor)
            .padding()
            .buttonSizing(.flexible)
           // .frame(maxWidth: .infinity)
            
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .scaleEffect(isPressed ? AppAnimation.lockAnimationScale : (isHovered ? AppAnimation.hoverScale : 1.0))
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                y: DesignSystem.Shadow.shadowSmall
            )
        }
        .accessibilityIdentifier("LockButton")
        .accessibilityLabel(Text("Lock Today's Entry"))
        .accessibilityHint("Locks today's entry. Disabled when locking is unavailable.")
        .accessibilityAddTraits(.isButton)
        .accessibilityElement(children: .ignore)
        .buttonStyle(.plain)
        .disabled(!canLock)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: AppAnimation.standardDuration)) {
                isHovered = hovering && canLock
            }
#if os(macOS)
            if canLock {
                if hovering {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
#endif
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: AppAnimation.standardDuration)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var fontSize: CGFloat {
        platformValue(iOS: DesignSystem.Text.Font.medium, macOS: DesignSystem.Text.Font.regular)
    }
    
    private var verticalPadding: CGFloat {
        platformValue(iOS: AppSpacing.regular, macOS: AppSpacing.small)
    }
    
    private var cornerRadius: CGFloat {
        platformValue(iOS: AppLayout.radiusLarge, macOS: AppLayout.radiusMedium)
    }
    
    private var shadowRadius: CGFloat {
        platformValue(iOS: DesignSystem.Shadow.shadowRegular, macOS: canLock && isHovered ? DesignSystem.Shadow.shadowLarge : DesignSystem.Shadow.shadowSmall)
    }
    
    private var foregroundColor: Color {
        canLock ? .white : (isDark ? ColorPalette.darkInkColor.opacity(0.3) : ColorPalette.lightInkColor.opacity(0.3))
    }
    
    private var shadowColor: Color {
        canLock ? (isDark ? Color.blue.opacity(0.3) : Color(hex: "2c3e50")?.opacity(0.2) ?? .black  )  : .clear
    }
    
    private var background: some View {
        Group {
            if canLock {
                LinearGradient(
                    colors: isDark ? ColorPalette.canLockDarkGradient : ColorPalette.canLockLightGradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                Color(isDark ? ColorPalette.darkLineColor : ColorPalette.lightLineColor)
            }
        }
    }
}

#Preview {
    LockButton(canLock: true, action: {})
}

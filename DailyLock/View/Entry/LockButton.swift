//
//  LockButton.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct LockButton: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let canLock: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 16, weight: .semibold))
                
                Text("Lock Today's Entry")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(canLock ? .white : (colorScheme == .dark ? Color.darkInkColor.opacity(0.3) : Color.lightInkColor.opacity(0.3)))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                Group {
                    if canLock {
                        LinearGradient(
                            colors: colorScheme == .dark ? [Color(hex: "5856D6"), Color(hex: "7C7AFF")] : [Color(hex: "2c3e50"), Color(hex: "34495e")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Color((colorScheme == .dark ? Color.darkLineColor : Color.lightLineColor))
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .shadow(
                color: canLock ? (colorScheme == .dark ? Color.blue.opacity(0.3) : Color(hex: "2c3e50").opacity(0.2)) : .clear,
                radius: 10,
                y: 5
            )
        }
        .disabled(!canLock)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    LockButton(canLock: true, action: {})
}

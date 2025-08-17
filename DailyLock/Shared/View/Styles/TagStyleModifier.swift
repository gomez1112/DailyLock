//
//  TagStyleModifier.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/9/25.
//

import SwiftUI

struct TagStyleModifier: ViewModifier {
    @Environment(\.isDark) var isDark
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .clipShape(Capsule())
            .background(isDark ? AnyShapeStyle(.thinMaterial) : AnyShapeStyle(.white.opacity(0.3)))
            .clipShape(Capsule())
    }
}

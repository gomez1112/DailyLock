//
//  WritingPaper.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct WritingPaper: View {
    
    @Environment(\.isDark) var isDark
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Paper background
                RoundedRectangle(cornerRadius: 20)
                    .fill((isDark ? ColorPalette.darkCardBackground : ColorPalette.lightCardBackground))
                    .shadow(color: (isDark ? DesignSystem.Shadow.darkShadowColor : DesignSystem.Shadow.lightShadowColor), radius: DesignSystem.Shadow.shadowRegular, y: 5)
                    // Accessibility for paper background
                    .accessibilityLabel("Writing paper background")
                    .accessibilityIdentifier("writingPaperBackground")
                // Red margin line
                HStack {
                    Rectangle()
                        .fill(Color.red.opacity(0.3))
                        .frame(width: 1)
                        .padding(.leading, 35)
                        // Accessibility for red margin line
                        .accessibilityLabel("Red margin line")
                        .accessibilityIdentifier("writingPaperMarginLine")
                    
                    Spacer()
                }
            }
            // Accessibility grouping and identifier for the whole component
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("writingPaperView")
        }
    }
}

#Preview {
    WritingPaper()
}

//
//  CardBackgroundModifier.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import SwiftUI

struct CardBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    var cornerRadius: CGFloat = AppLayout.radiusLarge
    var shadowRadius: CGFloat = DesignSystem.Shadow.shadowSmall
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill((colorScheme == .dark ? ColorPalette.darkCardBackground : ColorPalette.lightCardBackground))
                    .shadow(color: colorScheme == .dark ? DesignSystem.Shadow.darkShadowColor : DesignSystem.Shadow.lightShadowColor, radius: shadowRadius)
            )
    }
}

//
//  CardBackgroundModifier.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct CardBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    var cornerRadius: CGFloat = 12
    var shadowRadius: CGFloat = 10
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground)
                    .shadow(color: colorScheme == .dark ? Color.darkShadowColor : Color.lightShadowColor, radius: shadowRadius)
            )
    }
}

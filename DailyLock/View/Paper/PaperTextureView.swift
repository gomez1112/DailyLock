//
//  PaperTextureView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct PaperTextureView: View {
    @Environment(\.isDark) private var isDark
    
    var body: some View {
        ZStack {
            // Use the appropriate background color
            Color(isDark ? ColorPalette.darkPaperBackground : ColorPalette.lightPaperBackground)
                .ignoresSafeArea()
            
            // Overlay the pre-rendered texture image
            Image(isDark ? "defaultDarkPaper" : "defaultLightPaper")
                .resizable(resizingMode: .tile) // This tiles the image
                .ignoresSafeArea()
                .opacity(isDark ? 0.3 : 1.0)
        }
        .allowsHitTesting(false)
        .compositingGroup()
    }
}

#Preview {
    PaperTextureView()
}

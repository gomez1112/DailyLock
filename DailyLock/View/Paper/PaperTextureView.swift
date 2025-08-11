//
//  PaperTextureView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI
import CoreGraphics

struct PaperTextureView: View {
    @Environment(\.isDark) private var isDark
    private static let textureCache = TextureCache()
    
    private class TextureCache {
        let lightTexture: Image
        let darkTexture: Image?
        
        init() {
            self.lightTexture = Self.createTexture(dots: 10_000)
            self.darkTexture = nil
        }
        private static func createTexture(dots: Int) -> Image {
            _ = CGSize(width: 256, height: 256)
            let renderer = ImageRenderer(content:
                                            Canvas { context, size in
                for _ in 0..<dots {
                    let x = CGFloat.random(in: 0..<size.width)
                    let y = CGFloat.random(in: 0..<size.height)
                    let alpha = CGFloat.random(in: 0.02...0.05)
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: 1, height: 1)),
                        with: .color(.black.opacity(alpha))
                    )
                }
            }
            )
            renderer.scale = 1
#if canImport(UIKit)
            if let uiImage = renderer.uiImage {
                return Image(uiImage: uiImage).resizable(resizingMode: .tile)
            }
#elseif canImport(AppKit)
            if let nsImage = renderer.nsImage {
                return Image(nsImage: nsImage).resizable(resizingMode: .tile)
            }
#endif
            
            return Image(systemName: "circle") // Fallback
        }
    }
    
    var body: some View {
        // Accessibility modifiers added for background, dots texture, gradient, and grouping for maintainers
        ZStack {
            Color((isDark ? ColorPalette.darkPaperBackground : ColorPalette.lightPaperBackground))
                .ignoresSafeArea()
                .accessibilityIdentifier("paperTextureBackground")
                .accessibilityHidden(true)
            
            if !isDark {
                Self.textureCache.lightTexture
                    .blur(radius: 0.5)
                    .accessibilityIdentifier("paperTextureDots")
                    .accessibilityHidden(true)
                    .ignoresSafeArea()
            }
            
            RadialGradient(
                colors: [.clear, isDark ? .black.opacity(0.2) : .black.opacity(0.05)],
                center: .center,
                startRadius: 100,
                endRadius: 400
            )
            .accessibilityIdentifier("paperTextureGradient")
            .accessibilityHidden(true)
        }
        .allowsHitTesting(false)
        .compositingGroup()
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PaperTextureView()
}

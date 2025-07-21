//
//  PaperTextureView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct PaperTextureView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var grainPhase: Double = 0
    
    var body: some View {
        ZStack {
            // Base paper color
            Color((colorScheme == .dark ? Color.darkPaperBackground : Color.lightPaperBackground))
            
            if colorScheme == .light {
                Canvas { context, size in
                    for _ in 0..<1000 {
                        let x = Double.random(in: 0...size.width)
                        let y = Double.random(in: 0...size.height)
                        let opacity = Double.random(in: 0.02...0.05)
                        
                        context.fill(
                            Path(ellipseIn: CGRect(x: x, y: y, width: 1, height: 1)),
                            with: .color(.black.opacity(opacity))
                        )
                    }
                }
                .blur(radius: 0.5)
            }
            
            // Subtle vignette
            RadialGradient(
                colors: [.clear, colorScheme == .dark ? .black.opacity(0.2) : .black.opacity(0.05)],
                center: .center,
                startRadius: 100,
                endRadius: 400
            )
        }
    }
}

#Preview {
    PaperTextureView()
}

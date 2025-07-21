//
//  ConfettiView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    let sentimentColors: [Color]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    ConfettiShape(shape: particle.shape)
                        .foregroundStyle(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .rotationEffect(.degrees(particle.rotation))
                        .position(x: particle.x, y: particle.y)
                        .opacity(particle.opacity)
                        .animation(.linear(duration: particle.duration), value: particle.y)
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    private func createParticles(in size: CGSize) {
        for _ in 0..<50 {
            let particle = ConfettiParticle(
                x: Double.random(in: 0...size.width),
                y: -20,
                size: Double.random(in: 8...16),
                color: sentimentColors.randomElement() ?? .orange,
                shape: ConfettiParticle.Shape.allCases.randomElement() ?? .square,
                rotation: Double.random(in: 0...360),
                duration: Double.random(in: 2...4),
                opacity: 1.0
            )
            
            particles.append(particle)
            
            // Animate the particle falling
            withAnimation(.linear(duration: particle.duration)) {
                if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                    particles[index].y = size.height + 100
                    particles[index].rotation += Double.random(in: 180...540)
                }
            }
            
            // Fade out
            withAnimation(.linear(duration: particle.duration * 0.8).delay(particle.duration * 0.2)) {
                if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                    particles[index].opacity = 0
                }
            }
        }
        
        // Clean up particles after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            particles.removeAll()
        }
    }
}

#Preview {
    ConfettiView(sentimentColors: [.red, .green, .blue])
}

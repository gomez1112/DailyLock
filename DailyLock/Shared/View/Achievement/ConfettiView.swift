//
//  ConfettiView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var cleanupTask: Task<Void, Never>?
    
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
                        .accessibilityHidden(true)
                        .accessibilityIdentifier("ConfettiParticle-\(particle.id)")
                }
            }
            .accessibilityIdentifier("ConfettiViewGroup")
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Celebratory confetti animation")
            .onAppear {
                createParticles(in: geometry.size)
            }
            .onDisappear {
                cleanupTask?.cancel()
                particles.removeAll()
            }
        }
        .allowsHitTesting(false)
    }
    
    private func createParticles(in size: CGSize) {
        
        particles.removeAll()
        
        for _ in 0..<AppAchievements.numberOfParticles
        {
            let particle = ConfettiParticle(
                x: Double.random(in: 0...size.width),
                y: -AppAchievements.particleYPosition,
                size: Double.random(in: AppAchievements.particleMinSize...AppAchievements.particleMaxSize),
                color: sentimentColors.randomElement() ?? .orange,
                shape: ConfettiParticle.Shape.allCases.randomElement() ?? .square,
                rotation: Double.random(in: AppAchievements.particleMinRotation...AppAchievements.particleMaxRotation),
                duration: Double.random(in: AppAchievements.particleMinDuration...AppAchievements.particleMaxDuration),
                opacity: AppAchievements.particleOpacity
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
        cleanupTask?.cancel()
        cleanupTask = Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            if !Task.isCancelled {
                await MainActor.run {
                    particles.removeAll()
                }
            }
        }
    }
}

#Preview {
    ConfettiView(sentimentColors: [.red, .green, .blue])
}

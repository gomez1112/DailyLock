//
//  ConfettiParticle.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//


import SwiftUI

/// A model representing a single confetti particle, used for visual confetti effects.
///
/// `ConfettiParticle` contains information about the particle's position, appearance,
/// animation, and rendering details for use in SwiftUI-based confetti effects.
///
/**
 Properties:
 - `id`: The unique identifier for this particle.
 - `x`: The horizontal position of the particle.
 - `y`: The vertical position of the particle.
 - `size`: The rendered size of the particle.
 - `color`: The color of the particle.
 - `shape`: The geometric shape of the particle.
 - `rotation`: The current rotation angle (in degrees or radians, depending on use).
 - `duration`: The duration of the particle's animation or life.
 - `opacity`: The current opacity of the particle.
 */
///
/// - Note: Use this struct to generate a collection of unique, customizable confetti
///   particles for celebratory or decorative UI effects.
///
/// - SeeAlso: `ConfettiParticle.Shape`
struct ConfettiParticle: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    let size: Double
    let color: Color
    let shape: Shape
    var rotation: Double
    let duration: Double
    var opacity: Double
    
    enum Shape: CaseIterable {
        case square, circle, triangle
    }
}

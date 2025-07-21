//
//  ConfettiParticle.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//


import SwiftUI

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

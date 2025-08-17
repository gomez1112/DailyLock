//
//  ConfettiShape.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct ConfettiShape: View {
    let shape: ConfettiParticle.Shape
    
    var body: some View {
        switch shape {
        case .square:
            Rectangle()
        case .circle:
            Circle()
        case .triangle:
            Triangle()
        }
    }
}

#Preview {
    ConfettiShape(shape: .square)
}

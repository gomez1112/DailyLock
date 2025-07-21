//
//  WaxSeal.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct WaxSeal: View {
    let entry: MomentumEntry
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "8B0000"),
                            Color(hex: "A52A2A"),
                            Color(hex: "8B0000")
                        ],
                        center: .center,
                        startRadius: 5,
                        endRadius: 40
                    )
                )
            
            Circle()
                .stroke(Color(hex: "8B0000").opacity(0.3), lineWidth: 2)
                .padding(2)
            
            Text(entry.sentiment.rawValue.capitalized.prefix(1))
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundStyle(.white.opacity(0.9))
        }
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
    }
}

#Preview {
    WaxSeal(entry: MomentumEntry.samples[0])
}

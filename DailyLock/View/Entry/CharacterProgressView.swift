//
//  CharacterProgressView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct CharacterProgressView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let current: Int
    let limit: Int
    let progress: Double
    
    private var progressColor: Color {
        if progress > 0.9 {
            return .red
        } else if progress > 0.7 {
            return .orange
        }
        return colorScheme == .dark ? Color.darkLineColor : Color.lightLineColor
    }
    
    var body: some View {
        Gauge(value: progress, in: 0...1) {
            HStack {
                Spacer()
                Text("\(current)/\(limit)")
                     .contentTransition(.numericText(value: progress))
                     .animation(.default, value: progress)
                    .foregroundStyle(colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor)
            }
        }
        
        .tint(progressColor)
    }
}

#Preview {
    CharacterProgressView(current: 10, limit: 180, progress: 0.20)
}

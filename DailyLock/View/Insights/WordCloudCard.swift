//
//  WordCloudCard.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct WordCloudCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let entries: [MomentumEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Keywords")
                .font(.headline)
                .foregroundStyle(colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor)
            
            // Simplified word cloud preview
            ZStack {
                ForEach(0..<8, id: \.self) { index in
                    Text(["grateful", "family", "work", "happy", "tired", "accomplished", "peaceful", "excited"][index])
                        .font(.system(size: CGFloat.random(in: 14...24)))
                        .foregroundStyle(
                            Sentiment.allCases.randomElement()!.gradient.randomElement()!
                        )
                        .offset(
                            x: CGFloat.random(in: -80...80),
                            y: CGFloat.random(in: -40...40)
                        )
                        .opacity(Double.random(in: 0.6...1.0))
                }
            }
            .frame(height: 150)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground)
                .shadow(color: colorScheme == .dark ? Color.darkShadowColor : Color.lightShadowColor, radius: 10))
    }
}

#Preview {
    WordCloudCard(entries: MomentumEntry.samples)
}

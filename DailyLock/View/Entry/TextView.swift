//
//  TextView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct TextView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var text: String
    
    let sentiment: Sentiment
    var opacity: Double
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        TextField("What defined today?", text: $text, axis: .vertical)
            .font(.sentenceSerif)
            .foregroundStyle(colorScheme == .dark ? Color.darkInkColor.opacity(opacity * sentiment.inkIntensity) : Color.lightInkColor.opacity(opacity * sentiment.inkIntensity))
            .lineSpacing(13) // Fine-tuned to match ruled lines
            .lineLimit(4...6)
            .focused($isFocused)
            .textFieldStyle(.plain)
            .padding(.top, WritingPaper.topPadding - 22) // Precise baseline alignment
            .baselineOffset(-2) // Fine adjustment for baseline
    }
}

#Preview {
    TextView(text: .constant("Text"), sentiment: .negative, opacity: 0.8)
}

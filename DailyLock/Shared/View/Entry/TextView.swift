//
//  TextView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI


struct TextView: View {
    @Environment(\.isDark) private var isDark
    
    @Binding var text: String
    let reflectionPrompt: String
    let haptics: HapticEngine
    let sentiment: Sentiment
    var opacity: Double
    let isFocused: FocusState<Bool>.Binding
    
    // Define the character limit in one place
    private let characterLimit = DesignSystem.Text.maxCharacterCount
    
    var body: some View {
#if os(macOS)
        // BIND DIRECTLY to $text. No extra state needed.
        TextEditor(text: $text)
            .font(.sentenceSerif)
            .foregroundStyle(textColor)
            .scrollContentBackground(.hidden)
            .focused(isFocused)
            .onChange(of: text) { _, newValue in
                // Use the same simple, robust truncation logic as iOS.
                if newValue.count > characterLimit {
                    text = String(newValue.prefix(characterLimit))
                    haptics.tap() // Provide gentle feedback on limit
                }
            }
            .accessibilityIdentifier("textEditor")
            .accessibilityLabel("Daily entry text editor")
            .accessibilityHint("Write about what defined your day. Maximum \(characterLimit) characters.")
            .accessibilityValue(text)
#else
        TextField(reflectionPrompt, text: $text, axis: .vertical)
            .font(.sentenceSerif)
            .foregroundStyle(textColor)
            .lineSpacing(DesignSystem.Text.defaultLineSpacing)
            .lineLimit(DesignSystem.Text.minLineLimit...DesignSystem.Text.maxLineLimit)
            .focused(isFocused)
            .textFieldStyle(.plain)
            .accessibilityIdentifier("textField")
            .accessibilityLabel("Daily entry text field")
            .accessibilityHint("Write about what defined your day. Maximum \(characterLimit) characters.")
            .accessibilityValue(text)
            .onChange(of: text) { _, newValue in
                if newValue.count > characterLimit {
                    text = String(newValue.prefix(characterLimit))
                }
            }
#endif
    }
    
    private var textColor: Color {
        isDark ?
        ColorPalette.darkInkColor.opacity(opacity * sentiment.inkIntensity) :
        ColorPalette.lightInkColor.opacity(opacity * sentiment.inkIntensity)
    }
}


#Preview("Default") {
    @Previewable @State var text = "A sample entry for today."
    @FocusState var isFocused: Bool

    TextView(
        text: $text, reflectionPrompt: "What did you do today?", haptics: HapticEngine(),
        sentiment: .indifferent,
        opacity: 1.0,
        isFocused: $isFocused
    )
}

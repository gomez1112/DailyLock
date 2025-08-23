//
//  TextView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI


struct TextView: View {
    @Environment(\.isDark) private var isDark
    
    @Binding var title: String
    @Binding var detail: String
    let reflectionPrompt: String
    let haptics: HapticEngine
    let sentiment: Sentiment
    var opacity: Double
    let isFocused: FocusState<Bool>.Binding
    
    private let characterLimit = DesignSystem.Text.maxCharacterCount
    
    var body: some View {
#if os(macOS)
        VStack {
            TextField("Title of your entry", text: $title)
            Divider()
        TextEditor(text: $detail)
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
    }
#else
        VStack {
            TextField("Title of your entry", text: $title)
            Divider()
                .overlay(isDark ? ColorPalette.darkLineColor.opacity(0.3) : ColorPalette.lightLineColor.opacity(0.3))
            
        TextField(reflectionPrompt, text: $detail, axis: .vertical)
            .font(.sentenceSerif)
            .foregroundStyle(textColor)
            .lineSpacing(DesignSystem.Text.defaultLineSpacing)
            .lineLimit(DesignSystem.Text.minLineLimit...DesignSystem.Text.maxLineLimit)
            .focused(isFocused)
            .textFieldStyle(.plain)
            .accessibilityIdentifier("textField")
            .accessibilityLabel("Daily entry text field")
            .accessibilityHint("Write about what defined your day. Maximum \(characterLimit) characters.")
            .accessibilityValue(detail)
            .onChange(of: detail) { _, newValue in
                if newValue.count > characterLimit {
                    detail = String(newValue.prefix(characterLimit))
                }
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


#Preview(traits: .previewData) {
    @Previewable @State var detail = "A sample entry for today."
    @FocusState var isFocused: Bool

    TextView(
        title: .constant("Title"), detail: $detail, reflectionPrompt: "What did you do today?", haptics: HapticEngine(),
        sentiment: .indifferent,
        opacity: 1.0,
        isFocused: $isFocused
    )
}

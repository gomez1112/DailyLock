//
//  TextView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct TextView: View {
    
    @Environment(\.isDark) private var isDark
    
    @State private var internalText = ""
    @State private var isProcessingPaste = false
    @State private var lastTextValue = ""

    @Binding var text: String
    
    let haptics: HapticEngine
    let sentiment: Sentiment
    var opacity: Double
    let isFocused: FocusState<Bool>.Binding
    
    var body: some View {
#if os(macOS)
        TextEditor(text: $internalText)
            .font(.sentenceSerif)
            .foregroundStyle(textColor)
            .scrollContentBackground(.hidden)
            .focused($isFocused)
            .onAppear {
                internalText = text
                lastTextValue = text
            }
            .onChange(of: internalText) { _, newValue in
                handleTextChange(oldValue: lastTextValue, newValue: newValue)
                lastTextValue = newValue
            }
            .accessibilityIdentifier("textEditor")
            .accessibilityLabel("Daily entry text editor")
            .accessibilityHint("Write about what defined your day. Maximum \(AppText.maxCharacterCount) characters.")
            .accessibilityValue(text)
#else
        TextField("What defined today?", text: $text, axis: .vertical)
            .font(.sentenceSerif)
            .foregroundStyle(textColor)
            .lineSpacing(DesignSystem.Text.defaultLineSpacing)
            .lineLimit(DesignSystem.Text.minLineLimit...DesignSystem.Text.maxLineLimit)
            .focused(isFocused)
            .textFieldStyle(.plain)
            .accessibilityIdentifier("textField")
            .accessibilityLabel("Daily entry text field")
            .accessibilityHint("Write about what defined your day. Maximum \(DesignSystem.Text.maxCharacterCount) characters.")
            .accessibilityValue(text)
            .onChange(of: text) { _, newValue in
                if newValue.count > DesignSystem.Text.maxCharacterCount {
                    text = String(newValue.prefix(DesignSystem.Text.maxCharacterCount))
                }
            }
#endif
    }
    private func handleTextChange(oldValue: String, newValue: String) {
        guard !isProcessingPaste else { return }
        
        // Check if this is a paste operation (large text addition)
        let isPaste = abs(newValue.count - oldValue.count) > 10
        
        if newValue.count > DesignSystem.Text.maxCharacterCount {
            if isPaste {
                // For paste, truncate and show feedback
                isProcessingPaste = true
                let truncated = String(newValue.prefix(DesignSystem.Text.maxCharacterCount))
                internalText = truncated
                text = truncated
                
                // Provide haptic feedback for truncation
#if os(iOS)
                haptics.warning()
#endif
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(100))
                    isProcessingPaste = false
                }
            } else {
                // For typing, prevent the extra character
                internalText = oldValue
                text = oldValue
                
                // Light haptic feedback
#if os(iOS)
                haptics.tap()
#endif
            }
        } else {
            text = newValue
        }
    }
    
    // FIXED: Handle paste events specifically
    private func handlePasteEvent() {
        isProcessingPaste = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isProcessingPaste = false
        }
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
        text: $text, haptics: HapticEngine(),
        sentiment: .neutral,
        opacity: 1.0,
        isFocused: $isFocused
    )
}

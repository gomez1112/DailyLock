//
//  TodayContent.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/10/25.
//

#if canImport(JournalingSuggestions)
import JournalingSuggestions
#endif

import SwiftUI
import SwiftData

struct TodayContent: View {
    @State private var showSuggestionPicker = false
    @State private var journalingSuggestionVM = JournalingSuggestionViewModel()
    @Environment(\.isDark) private var isDark
    
    @Binding var currentText: String
    @Binding var selectedSentiment: Sentiment
    @Binding var showLockConfirmation: Bool
    
    let allEntries: [MomentumEntry]
    let isTextFieldFocused: FocusState<Bool>.Binding
    let haptics: HapticEngine
    let isInGracePeriod: Bool
    let inkOpacity: Double
    let characterCount: Int
    let progressToLimit: Double
    let currentStreak: Int
    let canLock: Bool
    let progressColor: TodayViewModel.ProgressColorStyle
    let updateInkOpacity: () -> ()
    
    var body: some View {
        VStack(spacing: AppSpacing.small) {
            // Writing Canvas
            ZStack {
                // Text Entry
                VStack(spacing: 0) {
                    TextView(
                        text: $currentText, reflectionPrompt: journalingSuggestionVM.firstReflectionPrompt, haptics: haptics,
                        sentiment: selectedSentiment,
                        opacity: inkOpacity,
                        isFocused: isTextFieldFocused
                    )
                    .accessibilityIdentifier("entryTextView")
                    .accessibilityLabel("Text entry for today")
                    .frame(height: textViewHeight)
                    .padding(.horizontal, horizontalPadding)
                    .onChange(of: currentText) { oldValue, newValue in
                        handleTextChange(oldValue: oldValue, newValue: newValue)
                    }
                    
                    Spacer()
                    CharacterProgressView(progress: Double(characterCount) / Double(DesignSystem.Text.maxCharacterCount), current: characterCount, limit: DesignSystem.Text.maxCharacterCount)
                        .accessibilityIdentifier("characterProgressView")
                        .accessibilityLabel("Characters used: \(characterCount) of \(DesignSystem.Text.maxCharacterCount)")
                        .padding(.horizontal, horizontalPadding)
                        .padding(.bottom, AppSpacing.medium)
                }
                .frame(height: innerContentHeight)
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("writingCanvas")
            .onPlatform { view in
                view.padding(.horizontal, AppSpacing.small)
            }
            
            // Sentiment Selection
            Picker("Sentiment", selection: $selectedSentiment.animation()) {
                ForEach(Sentiment.allCases) { sentiment in
                    Label(sentiment.rawValue.capitalized, systemImage: sentiment.symbol)
                        .tag(sentiment)
                }
            }
            .accessibilityIdentifier("sentimentPicker")
            .accessibilityLabel("Select sentiment")
            .pickerStyle(.segmented)
            .padding()
            
            // Grace Period Indicator
            if isInGracePeriod {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Complete today to maintain your \(currentStreak) day streak!")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                .accessibilityIdentifier("gracePeriodWarning")
                .accessibilityLabel("Grace period active. Complete today to maintain your streak.")
            }
            Button("Get Suggestion") {
                showSuggestionPicker = true
            }
            .buttonStyle(.bordered)
            Spacer()
            // Lock Button
            LockButton(
                canLock: canLock,
                action: {
                    if canLock {
                        showLockConfirmation = true
                    }
                }
            )
            .accessibilityIdentifier("lockEntryButton")
            .accessibilityLabel("Lock today's entry")
            .accessibilityHint("Locks your entry. This cannot be undone.")
            .padding(.horizontal, buttonPadding)
            .scaleEffect(showLockConfirmation ? AppAnimation.lockButtonScale : 1.0)
        }
        #if !os(macOS)
        .journalingSuggestionsPicker(isPresented: $showSuggestionPicker) { suggestion in
            if suggestion.items.contains(where: { $0.hasContent(ofType: JournalingSuggestion.Reflection.self) }) {
                journalingSuggestionVM.processSuggestion(suggestion)
            }
            
        }
        #endif
        .onPlatform { view in
            view.frame(maxWidth: AppLayout.entryMaxWidth)
        }
    }
    
    private func handleTextChange(oldValue: String, newValue: String) {
        withAnimation(.easeIn(duration: AppAnimation.inkFadeInDuration)) {
            if newValue.count > oldValue.count && newValue.count % DesignSystem.Text.hapticFeedbackInterval == 0 {
                haptics.tap()
            }
            updateInkOpacity()
        }
    }
    
    // Platform-specific sizing
    private var textViewHeight: CGFloat {
        platformValue(iOS: AppLayout.textViewHeight, macOS: AppLayout.textViewHeight)
    }
    private var horizontalPadding: CGFloat {
        platformValue(iOS: AppSpacing.xxLarge, macOS: AppSpacing.xLarge)
    }
    private var buttonPadding: CGFloat {
        platformValue(iOS: AppSpacing.xxLarge, macOS: AppSpacing.xxxLarge)
    }
    private var innerContentHeight: CGFloat {
        platformValue(iOS: AppLayout.innerContentHeight, macOS: AppLayout.innerContentHeight)
    }
}


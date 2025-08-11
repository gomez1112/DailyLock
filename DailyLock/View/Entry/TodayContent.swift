//
//  TodayContent.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/10/25.
//

import SwiftUI
import SwiftData

struct TodayContent: View {
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.isDark) private var isDark
    
    let allEntries: [MomentumEntry]
    let isTextFieldFocused: FocusState<Bool>.Binding
    let viewModel: EntryViewModel  // Now passed in, not created
    
    var body: some View {
        @Bindable var entryVM = viewModel
        VStack(spacing: AppSpacing.small) {
            // Writing Canvas
            ZStack {
                // Text Entry
                VStack(spacing: 0) {
                    TextView(
                        text: $entryVM.currentText,
                        sentiment: entryVM.selectedSentiment,
                        opacity: entryVM.inkOpacity,
                        isFocused: isTextFieldFocused
                    )
                    .accessibilityIdentifier("entryTextView")
                    .accessibilityLabel("Text entry for today")
                    .frame(height: textViewHeight)
                    .padding(.horizontal, horizontalPadding)
                    .onChange(of: entryVM.currentText) { oldValue, newValue in
                        handleTextChange(oldValue: oldValue, newValue: newValue)
                    }
                    
                    Spacer()
                    
                    // Character Progress inside the paper
                    CharacterProgressView(
                        current: entryVM.characterCount,
                        limit: DesignSystem.Text.maxCharacterCount,
                        progress: entryVM.progressToLimit,
                        progressColor: entryVM.progressColor(
                            progress: entryVM.progressToLimit,
                            isDark: isDark
                        )
                    )
                    .accessibilityIdentifier("characterProgressView")
                    .accessibilityLabel("Characters used: \(entryVM.characterCount) of \(DesignSystem.Text.maxCharacterCount)")
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
            Picker("Sentiment", selection: $entryVM.selectedSentiment.animation()) {
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
            if entryVM.isInGracePeriod {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Complete today to maintain your \(entryVM.currentStreak) day streak!")
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
            
            // Lock Button
            LockButton(
                canLock: entryVM.canLock,
                action: {
                    if entryVM.canLock {
                        entryVM.showLockConfirmation = true
                    }
                }
            )
            .accessibilityIdentifier("lockEntryButton")
            .accessibilityLabel("Lock today's entry")
            .accessibilityHint("Locks your entry. This cannot be undone.")
            .padding(.horizontal, buttonPadding)
            .scaleEffect(entryVM.showLockConfirmation ? AppAnimation.lockButtonScale : 1.0)
        }
        .onPlatform { view in
            view.frame(maxWidth: AppLayout.entryMaxWidth)
        }
    }
    
    private func handleTextChange(oldValue: String, newValue: String) {
        withAnimation(.easeIn(duration: AppAnimation.inkFadeInDuration)) {
            if newValue.count > oldValue.count && newValue.count % DesignSystem.Text.hapticFeedbackInterval == 0 {
                dependencies.haptics.tap()
            }
            viewModel.updateInkOpacity()
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


#Preview {
    @FocusState var isFocused: Bool
    TodayContent(
        allEntries: Array(repeating: MomentumEntry(), count: 5), isTextFieldFocused: $isFocused, viewModel: EntryViewModel())
}

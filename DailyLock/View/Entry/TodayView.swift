//
//  TodayView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftData
import SwiftUI

struct TodayView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.isDark) private var isDark
    @Environment(\.modelContext) private var modelContext
    
    @State private var entryVM = EntryViewModel()
    
    @Query(sort: \MomentumEntry.date, order: .reverse) private var allEntries: [MomentumEntry]
    @AppStorage("allowGracePeriod") private var allowGracePeriod = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        @Bindable var entryVM = entryVM
        GeometryReader { geometry in
            ZStack {
                Image(isDark ? .recycleDarkTexture : .recycleLightTexture)
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Date Header with handwritten style
                        dateHeader
                            .padding(.top, topPadding)
                            .padding(.bottom, AppSpacing.medium)
                        
                        if let entry = todayEntry, entry.isLocked {
                            // Locked Entry Display
                            LockedEntryView(entry: entry)
                                .accessibilityIdentifier("lockedEntryView")
                                .accessibilityLabel("Locked entry for today")
                                .transition(.asymmetric(
                                    insertion: .scale(scale: AppAnimation.lockAnimationScale).combined(with: .opacity),
                                    removal: .opacity
                                ))
                                .onPlatform { view in
                                    view.frame(maxWidth: AppLayout.entryMaxWidth)
                                }
                        } else {
                            TodayContent(
                                allEntries: allEntries,
                                isTextFieldFocused: $isTextFieldFocused,
                                viewModel: entryVM
                            )
                        }
                        Spacer(minLength: AppSpacing.xxxLarge)
                    }
                    .frame(maxWidth: .infinity)
                }
                .scrollBounceBehavior(.basedOnSize)
                .onTapGesture {
#if os(macOS)
                    // Don't dismiss keyboard on click for macOS
#else
                    if isTextFieldFocused {
                        isTextFieldFocused = false
                    }
#endif
                }
                .confirmationDialog("Lock this entry?", isPresented: $entryVM.showLockConfirmation) {
                    Button("Lock Entry", role: .destructive) {
                        lockEntry()
                    }
                    Button("Cancel", role: .cancel) {}
                }
                message: {
                    Text("Once locked, this entry cannot be edited. Your words will be preserved exactly as written.")
                }
                
                if entryVM.showConfetti {
                    ConfettiView(sentimentColors: Sentiment.allCases.flatMap { $0.gradient })
                        .accessibilityIdentifier("confettiView")
                        .accessibilityHidden(true)
                        .allowsHitTesting(false)
                }
                
                if entryVM.showStreakAchievement {
                    StreakAchievementView(streakCount: entryVM.currentStreak)
                        .accessibilityIdentifier("streakAchievementView")
                        .accessibilityLabel("Streak achievement: \(entryVM.currentStreak) days")
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            loadViewModelState()
        }
        .onChange(of: allEntries) { _, _ in
            updateStreakInfo()
        }
    }
    
    // MARK: - Private Properties
    
    private var todayEntry: MomentumEntry? {
        let today = Calendar.current.startOfDay(for: Date())
        return allEntries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    // MARK: - View State Management (moved from ViewModel)
    
    private func loadViewModelState() {
        // Load existing entry if it exists
        if let existingEntry = todayEntry, !existingEntry.isLocked {
            entryVM.loadExistingEntry(existingEntry)
        }
        
        // Update streak info
        updateStreakInfo()
    }
    
    private func updateStreakInfo() {
        let streakInfo = StreakCalculator.calculateStreak(
            from: allEntries,
            allowGracePeriod: allowGracePeriod
        )
        entryVM.updateStreakInfo(streakInfo)
    }
    
    private func lockEntry() {
        withAnimation(.spring(response: AppAnimation.springResponse, dampingFraction: AppAnimation.springDamping)) {
            let oldStreak = entryVM.currentStreak
            
            // Save the entry
            dependencies.dataService.lockEntry(
                text: entryVM.currentText,
                sentiment: entryVM.selectedSentiment,
                for: allEntries
            )
            
            // Haptic feedback
            dependencies.haptics.lock()
            dependencies.haptics.success()
            
            // Update streak info with optimistic update
            let optimisticEntry = MomentumEntry(
                text: entryVM.currentText,
                sentiment: entryVM.selectedSentiment,
                lockedAt: Date()
            )
            let optimisticEntries = allEntries + [optimisticEntry]
            let newStreakInfo = StreakCalculator.calculateStreak(
                from: optimisticEntries,
                allowGracePeriod: allowGracePeriod
            )
            
            entryVM.updateStreakInfo(newStreakInfo)
            
            // Check for achievement
            if entryVM.shouldShowAchievement(oldStreak: oldStreak, newStreak: newStreakInfo.count) {
                entryVM.triggerAchievementAnimation()
            }
        }
    }
    
    // MARK: - View Components
    
    private var dateHeader: some View {
        VStack {
            Text(Date().formatted(.dateTime.weekday(.wide)))
                .font(.dateScript)
                .foregroundStyle((isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor))
            
            Text(Date().formatted(.dateTime.month(.wide).day()))
                .font(.caption)
                .foregroundStyle(.secondary)
                .tracking(2)
        }
        .accessibilityIdentifier("dateHeader")
        .accessibilityLabel("Today's Date: " + Date().formatted(.dateTime.weekday(.wide)) + ", " + Date().formatted(.dateTime.month(.wide).day()))
    }
    
    private var topPadding: CGFloat {
        platformValue(iOS: AppSpacing.large, macOS: AppSpacing.small)
    }
}

#Preview(traits: .previewData) {
    TodayView()
}

#Preview(traits: .previewData) {
    TodayView()
}

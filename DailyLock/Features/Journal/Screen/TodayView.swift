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
    
    @State private var todayVM = TodayViewModel()
    
    @Query(sort: \MomentumEntry.date, order: .reverse) private var allEntries: [MomentumEntry]
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        @Bindable var todayVM = todayVM
        GeometryReader { geometry in
            ZStack {
                WritingPaper()
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        // Date Header with handwritten style
                        dateHeader
                            .padding(.top, topPadding)
                            .padding(.bottom, AppSpacing.medium)
                        
                        if let entry = todayVM.todayEntry(entries: allEntries), entry.isLocked {
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
                            TodayContent(currentText: $todayVM.currentText, selectedSentiment: $todayVM.selectedSentiment, showLockConfirmation: $todayVM.showLockConfirmation, allEntries: allEntries, isTextFieldFocused: $isTextFieldFocused, haptics: dependencies.haptics, isInGracePeriod: todayVM.isInGracePeriod, inkOpacity: todayVM.inkOpacity, characterCount: todayVM.characterCount, progressToLimit: todayVM.progressToLimit, currentStreak: todayVM.currentStreak, canLock: todayVM.canLock, progressColor: todayVM.progressColor(progress: todayVM.progressToLimit, isDark: isDark), updateInkOpacity: todayVM.updateInkOpacity)
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
                .confirmationDialog("Lock this entry?", isPresented: $todayVM.showLockConfirmation) {
                    Button("Lock Entry", role: .destructive) {
                        withAnimation(.spring(response: AppAnimation.springResponse, dampingFraction: AppAnimation.springDamping)) {
                            todayVM.lockEntry(entries: allEntries, allowGracePeriod: dependencies.syncedSetting.allowGracePeriod, dependencies: dependencies)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
                message: {
                    Text("Once locked, this entry cannot be edited. Your words will be preserved exactly as written.")
                }
                
                if todayVM.showConfetti {
                    ConfettiView(sentimentColors: Sentiment.allCases.flatMap { $0.gradient })
                        .accessibilityIdentifier("confettiView")
                        .accessibilityHidden(true)
                        .allowsHitTesting(false)
                }
                
                if todayVM.showStreakAchievement {
                    StreakAchievementView(streakCount: todayVM.currentStreak)
                        .accessibilityIdentifier("streakAchievementView")
                        .accessibilityLabel("Streak achievement: \(todayVM.currentStreak) days")
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            todayVM.loadViewModelState(entries: allEntries, allowGracePeriod: dependencies.syncedSetting.allowGracePeriod)
        }
        .onChange(of: allEntries) { _, _ in
            todayVM.updateStreakInfo(entries: allEntries, allowGracePeriod: dependencies.syncedSetting.allowGracePeriod)
        }
        .onChange(of: dependencies.syncedSetting.allowGracePeriod) { _, newValue in
            todayVM.updateStreakInfo(entries: allEntries, allowGracePeriod: newValue)
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

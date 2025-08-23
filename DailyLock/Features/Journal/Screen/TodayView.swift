//
//  TodayView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import AppIntents
import CoreSpotlight
import SwiftData
import SwiftUI

struct TodayView: View {
    
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.isDark) private var isDark
    @Environment(\.modelContext) private var modelContext
    
    @State private var indexingTask: Task<Void, Error>?
    @State var viewModel: TodayViewModel
    
    @Query(sort: \MomentumEntry.date, order: .reverse) private var allEntries: [MomentumEntry]
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        @Bindable var viewModel = viewModel
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
                        
                        if let entry = viewModel.todayEntry(entries: allEntries), entry.isLocked {
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
                            TodayContent(title: $viewModel.title, currentDetail: $viewModel.currentDetail, selectedSentiment: $viewModel.selectedSentiment, showLockConfirmation: $viewModel.showLockConfirmation, allEntries: allEntries, isTextFieldFocused: $isTextFieldFocused, haptics: dependencies.haptics, isInGracePeriod: viewModel.isInGracePeriod, inkOpacity: viewModel.inkOpacity, characterCount: viewModel.characterCount, progressToLimit: viewModel.progressToLimit, currentStreak: viewModel.currentStreak, canLock: viewModel.canLock, progressColor: viewModel.progressColor(progress: viewModel.progressToLimit, isDark: isDark), updateInkOpacity: viewModel.updateInkOpacity)
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
                .confirmationDialog("Lock this entry?", isPresented: $viewModel.showLockConfirmation) {
                    Button("Lock Entry", role: .destructive) {
                        withAnimation(.spring(response: AppAnimation.springResponse, dampingFraction: AppAnimation.springDamping)) {
                            // Call the new, simplified lock handler
                            viewModel.handleEntryLock()
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
                message: {
                    Text("Once locked, this entry cannot be edited. Your words will be preserved exactly as written.")
                }
                
                if viewModel.showConfetti {
                    ConfettiView(sentimentColors: Sentiment.allCases.flatMap { $0.gradient })
                        .accessibilityIdentifier("confettiView")
                        .accessibilityHidden(true)
                        .allowsHitTesting(false)
                }
                
                if viewModel.showStreakAchievement {
                    StreakAchievementView(streakCount: viewModel.currentStreak)
                        .accessibilityIdentifier("streakAchievementView")
                        .accessibilityLabel("Streak achievement: \(viewModel.currentStreak) days")
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            viewModel.loadViewModelState(entries: allEntries)
        }
        .onChange(of: allEntries) { _, newEntries in
            // The view now tells the view model to process the update.
            // This is the single source of truth for streak updates.
            viewModel.processEntriesUpdate(newEntries: newEntries)
            Task {
                await indexEntries(from: newEntries)
            }
        }
        .onChange(of: dependencies.syncedSetting.allowGracePeriod) {
            viewModel.updateStreakInfo(entries: allEntries)
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
    func indexEntries(from entries: [MomentumEntry]) async {
        indexingTask?.cancel() // Cancel any previous task
        indexingTask = Task {
            do {
                let entities = entries.map { MomentumEntryEntity(from: $0) }
                try await CSSearchableIndex.default().indexAppEntities(entities)
            } catch {
                // It's good practice to handle cancellation errors silently
                if error is CancellationError {
                    print("Indexing was cancelled.")
                } else {
                    print("Error indexing entries: \(error.localizedDescription)")
                }
            }
        }
    }
}




#Preview(traits: .previewData) {
    TodayView(viewModel: TodayViewModel(dataService: DataService(container: ModelContainerFactory.createEmptyContainer), haptics: HapticEngine(), syncedSetting: SyncedSetting()))
}

//
//  TodayView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftData
import SwiftUI

//
//  TodayView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftData
import SwiftUI

struct TodayView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Environment(HapticEngine.self) private var haptics: HapticEngine
    
    @Query(sort: \MomentumEntry.date, order: .reverse) private var allEntries: [MomentumEntry]
    
    @State private var currentText = ""
    @State private var selectedSentiment: Sentiment = .neutral
    @State private var showLockAnimation = false
    @State private var showLockConfirmation = false
    @State private var inkOpacity: Double = 0
    @State private var showConfetti = false
    @State private var showStreakAchievement = false
    @State private var currentStreak = 0
    
    @FocusState private var isTextFieldFocused: Bool
    
    private var todayEntry: MomentumEntry? {
        let today = Calendar.current.startOfDay(for: Date())
        return allEntries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    private var characterCount: Int {
        currentText.count
    }
    
    private var progressToLimit: Double {
        min(Double(characterCount) / 180.0, 1.0)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                PaperTextureView()
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        // Date Header with handwritten style
                        VStack(spacing: 4) {
                            Text(Date().formatted(.dateTime.weekday(.wide)))
                                .font(.dateScript)
                                .foregroundStyle((colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor))
                            
                            Text(Date().formatted(.dateTime.month(.wide).day()))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .tracking(2)
                        }
                        .padding(.top, 60)
                        .padding(.bottom, 40)
                        
                        if let entry = todayEntry, entry.isLocked {
                            // Locked Entry Display
                            LockedEntryView(entry: entry)
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        } else {
                            VStack(spacing: 20) {
                                // Writing Canvas
                                ZStack {
                                    // Paper with lines
                                    WritingPaper()
                                        .frame(height: 300)
                                    
                                    // Text Entry
                                    VStack(spacing: 0) {
                                        TextView(
                                            text: $currentText,
                                            sentiment: selectedSentiment,
                                            opacity: inkOpacity,
                                            isFocused: _isTextFieldFocused
                                        )
                                        .frame(height: 220)
                                        .padding(.horizontal, 40)
                                        .onChange(of: currentText) { _, _ in
                                            withAnimation(.easeIn(duration: 0.1)) {
                                                inkOpacity = min(Double(currentText.count) / 20.0, 1.0)
                                            }
                                            if currentText.count % 10 == 0 {
                                                haptics.tap()
                                            }
                                        }
                                        .onAppear {
                                            if let existingEntry = todayEntry, !existingEntry.isLocked {
                                                currentText = existingEntry.text
                                                selectedSentiment = existingEntry.sentiment
                                                inkOpacity = min(Double(currentText.count) / 180.0, 1.0)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        // Character Progress inside the paper
                                        CharacterProgressView(
                                            current: characterCount,
                                            limit: 180,
                                            progress: progressToLimit
                                        )
                                        .padding(.horizontal, 40)
                                        .padding(.bottom, 20)
                                    }
                                    .frame(height: 300)
                                }
                                .padding(.horizontal)
                                
                                // Sentiment Selection
                                Picker("Sentiment", selection: $selectedSentiment.animation()) {
                                    ForEach(Sentiment.allCases) { sentiment in
                                        Label(sentiment.rawValue.capitalized, systemImage: sentiment.symbol)
                                            .tag(sentiment)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal, 40)
                                
                                // Lock Button
                                LockButton(
                                    canLock: characterCount > 0 && characterCount <= 180,
                                    action: {
                                        if characterCount > 0 && characterCount <= 180 {
                                            showLockConfirmation = true
                                        }
                                    }
                                )
                                .padding(.horizontal, 40)
                                .scaleEffect(showLockAnimation ? 0.95 : 1.0)
                            }
                            .padding(.bottom, 40)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
                .onTapGesture {
                    if isTextFieldFocused {
                        isTextFieldFocused = false
                    }
                }
                .confirmationDialog("Lock this entry?", isPresented: $showLockConfirmation) {
                    Button("Lock Entry", role: .destructive) {
                        lockEntry()
                    }
                    Button("Cancel", role: .cancel) {}
                }
                message: {
                    Text("Once locked, this entry cannot be edited. Your words will be preserved exactly as written.")
                }
                
                if showConfetti {
                    ConfettiView(sentimentColors: Sentiment.allCases.flatMap { $0.gradient})
                        .allowsHitTesting(false)
                }
                
                if showStreakAchievement {
                    StreakAchievementView(streakCount: currentStreak)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            currentStreak = calculateStreak()
        }
    }
    
    private func lockEntry() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showLockAnimation = true
            
            if let existingEntry = todayEntry {
                existingEntry.text = currentText
                existingEntry.sentiment = selectedSentiment
                existingEntry.lockedAt = Date()
                existingEntry.wordCount = currentText.split(separator: " ").count
            } else {
                let newEntry = MomentumEntry(text: currentText, sentiment: selectedSentiment)
                newEntry.lockedAt = Date()
                modelContext.insert(newEntry)
            }
            
            haptics.lock()
            haptics.success()
            
            let newStreak = calculateStreak() + 1
            if newStreak >= 3 && newStreak % 3 == 0 {
                currentStreak = newStreak
                showConfetti = true
                showStreakAchievement = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    showConfetti = false
                }
                
                // Hide achievement after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    showStreakAchievement = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showLockAnimation = false
            }
        }
    }
    
    private func calculateStreak() -> Int {
        let calendar = Calendar.current
        let sortedEntries = allEntries
            .filter { $0.isLocked }
            .sorted { $0.date > $1.date }
        
        guard !sortedEntries.isEmpty else { return 0 }
        
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        
        // Check if today already has an entry
        let hasEntryToday = sortedEntries.contains { calendar.isDate($0.date, inSameDayAs: checkDate) }
        
        // If no entry today, start checking from yesterday
        if !hasEntryToday {
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        
        // Count consecutive days
        for entry in sortedEntries {
            if calendar.isDate(entry.date, inSameDayAs: checkDate) {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else if entry.date < checkDate {
                // Check if we skipped exactly one day (allowing for one missed day)
                let dayDifference = calendar.dateComponents([.day], from: entry.date, to: checkDate).day ?? 0
                if dayDifference > 1 {
                    break
                }
            }
        }
        
        return streak
    }
}

#Preview(traits: .previewData) {
    TodayView()
}

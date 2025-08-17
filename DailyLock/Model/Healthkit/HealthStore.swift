//
//  HealthKitStore.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/16/25.
//

import Foundation
import HealthKit
import Observation
import os

@Observable
@MainActor
final class HealthStore {
    // MARK: - Properties
    let store = HKHealthStore()
    private let errorState: ErrorState
    // Observable state
    var isAuthorized: Bool? = nil
    var isLoading = false
    var lastSyncDate: Date?
    var syncedEntriesCount = 0
    
    // Cached data
    private(set) var recentMoodEntries: [HealthMoodEntry] = []
    private(set) var moodSummary: HealthMoodSummary?
    
    // Configuration
    private let appIdentifier = "com.dailylock"
    
    // HealthKit types
    private var readTypes: Set<HKObjectType> {
        var types: Set<HKObjectType> = [HKObjectType.stateOfMindType()]
        
        // Add sleep analysis if available (iOS 16+)
        if #available(iOS 16.0, *) {
            types.insert(HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!)
        }
        
        // Add mindful minutes
        types.insert(HKObjectType.categoryType(forIdentifier: .mindfulSession)!)
        
        return types
    }
    
    private var shareTypes: Set<HKSampleType> {
        [HKObjectType.stateOfMindType()]
    }
    
    // MARK: - Initialization
    init(errorState: ErrorState) {
        self.errorState = errorState
        Task {
            await checkInitialAuthorizationStatus()
        }
    }
    
    // MARK: - Authorization
    
    /// Checks authorization status without prompting
    func checkInitialAuthorizationStatus() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            Log.healthKit.warning("HealthKit not available on this device")
            errorState.showHealthKitError(.notAvailable)
            isAuthorized = false
            return
        }
        
        do {
            let status = try await store.statusForAuthorizationRequest(
                toShare: shareTypes,
                read: readTypes
            )
            
            await MainActor.run {
                switch status {
                    case .unnecessary:
                        self.isAuthorized = true
                        Task { await self.loadRecentMoodData() }
                    case .shouldRequest:
                        self.isAuthorized = false
                    case .unknown:
                        self.isAuthorized = nil
                    @unknown default:
                        self.isAuthorized = nil
                }
            }
        } catch {
            Log.healthKit.error("Failed to check authorization: \(error)")
            errorState.showHealthKitError(.authorizationNotDetermined)
            isAuthorized = nil
        }
    }
    
    /// Requests authorization from the user
    func requestAuthorization() async throws -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else {
            errorState.showHealthKitError(.notAvailable)
            throw HealthKitError.notAvailable
        }
        
        do {
            try await store.requestAuthorization(toShare: shareTypes, read: readTypes)
            
            // Check actual authorization status after request
            let authorized = shareTypes.allSatisfy { type in
                store.authorizationStatus(for: type) == .sharingAuthorized
            }
            
            await MainActor.run {
                self.isAuthorized = authorized
            }
            
            if authorized {
                await loadRecentMoodData()
            }
            
            return authorized
        } catch {
            Log.healthKit.error("Authorization request failed: \(error)")
            errorState.showHealthKitError(.authorizationDenied)
            throw HealthKitError.authorizationDenied
        }
    }
    func requestAuthorizationTrigger() async throws {
        do {
            isLoading = true
            let authorized = try await requestAuthorization()
            isAuthorized = authorized
        } catch {
            Log.healthKit.error("Authorization trigger failed: \(error)")
            errorState.showHealthKitError(.authorizationDenied)
            isAuthorized = false
            throw error
        }
    }
    // MARK: - Writing Data
    
    /// Saves a mood entry to HealthKit
    func saveMoodEntry(
        date: Date,
        sentiment: Sentiment,
        text: String? = nil,
        keywords: [String] = []
    ) async throws {
        guard isAuthorized == true else {
            errorState.showHealthKitError(.authorizationNotDetermined)
            throw HealthKitError.authorizationNotDetermined
        }
        
        var metadata: [String: Any] = [
            HKMetadataKeyExternalUUID: UUID().uuidString,
            "AppIdentifier": appIdentifier
        ]
        
        if let text = text {
            metadata["EntryText"] = String(text.prefix(100)) // Store truncated text
        }
        
        if !keywords.isEmpty {
            metadata["Keywords"] = keywords.joined(separator: ",")
        }
        
        let stateOfMind = HKStateOfMind(
            date: date,
            kind: .dailyMood,
            valence: sentiment.valence,
            labels: [sentiment.label],
            associations: [.community, .currentEvents],
            metadata: metadata
        )
        
        do {
            try await store.save(stateOfMind)
            Log.healthKit.info("Successfully saved mood entry to HealthKit")
            await loadRecentMoodData() // Refresh cached data
        } catch {
            Log.healthKit.error("Failed to save mood: \(error)")
            errorState.showHealthKitError(.saveFailed("Failed to save mood: \(error.localizedDescription)"))
            throw HealthKitError.saveFailed(error.localizedDescription)
        }
    }
    
    /// Batch saves multiple entries
    func syncEntries(_ entries: [MomentumEntry]) async throws {
        guard isAuthorized == true else {
            errorState.showHealthKitError(.authorizationNotDetermined)
            throw HealthKitError.authorizationNotDetermined
        }
        
        isLoading = true
        defer { isLoading = false }
        
        var savedCount = 0
        
        for entry in entries where entry.isLocked {
            do {
                try await saveMoodEntry(
                    date: entry.lockedAt ?? entry.date,
                    sentiment: entry.sentiment,
                    text: entry.text,
                    keywords: entry.topKeywords ?? []
                )
                savedCount += 1
            } catch {
                Log.healthKit.warning("Failed to sync entry: \(error)")
                errorState.showHealthKitError(.syncFailed("Faile to sync entry: \(error)"))
            }
        }
        
        syncedEntriesCount = savedCount
        lastSyncDate = Date()
        Log.healthKit.info("Synced \(savedCount) entries to HealthKit")
    }
    
    // MARK: - Reading Data
    
    /// Loads recent mood data from HealthKit
    func loadRecentMoodData(days: Int = 30) async {
        guard isAuthorized == true else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: endDate)!
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictEndDate
        )
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        do {
            let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKStateOfMind], Error>) in
                let query = HKSampleQuery(
                    sampleType: HKObjectType.stateOfMindType(),
                    predicate: predicate,
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [sortDescriptor]
                ) { _, samples, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        let moods = (samples as? [HKStateOfMind]) ?? []
                        continuation.resume(returning: moods)
                    }
                }
                store.execute(query)
            }
            
            await MainActor.run {
                self.recentMoodEntries = samples.map { mood in
                    HealthMoodEntry(
                        date: mood.endDate,
                        valence: mood.valence,
                        labels: mood.labels,
                        kind: mood.kind,
                        associations: mood.associations,
                        metadata: mood.metadata
                    )
                }
                
                self.moodSummary = self.calculateSummary(from: self.recentMoodEntries)
            }
            
        } catch {
            Log.healthKit.error("Failed to load mood data: \(error)")
            errorState.showHealthKitError(.queryFailed("\(error.localizedDescription)"))
        }
    }
    
    /// Queries mood data for a specific date range
    func queryMoodData(
        from startDate: Date,
        to endDate: Date
    ) async throws -> [HealthMoodEntry] {
        guard isAuthorized == true else {
            errorState.showHealthKitError(.authorizationNotDetermined)
            throw HealthKitError.authorizationNotDetermined
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictEndDate
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: HKObjectType.stateOfMindType(),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: HealthKitError.queryFailed(error.localizedDescription))
                } else {
                    let moods = (samples as? [HKStateOfMind]) ?? []
                    DispatchQueue.main.async {
                        let entries = moods.map { mood in
                            HealthMoodEntry(
                                date: mood.startDate,
                                valence: mood.valence,
                                labels: mood.labels,
                                kind: mood.kind,
                                associations: mood.associations,
                                metadata: mood.metadata
                            )
                        }
                        continuation.resume(returning: entries)
                    }
                }
            }
            store.execute(query)
        }
    }
    
    // MARK: - Analytics
    
    /// Calculates mood trends over time
    func calculateMoodTrends(days: Int = 7) async -> [(date: Date, averageValence: Double)] {
        guard let entries = try? await queryMoodData(
            from: Calendar.current.date(byAdding: .day, value: -days, to: Date())!,
            to: Date()
        ) else { return [] }
        
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.date)
        }
        
        return grouped.map { date, dayEntries in
            let avgValence = dayEntries.reduce(0) { $0 + $1.valence } / Double(dayEntries.count)
            return (date: date, averageValence: avgValence)
        }.sorted { $0.date < $1.date }
    }
    
    /// Gets sleep quality correlation with mood
    @available(iOS 16.0, *)
    func getSleepMoodCorrelation() async throws -> Double? {
        // Implementation for sleep-mood correlation analysis
        // This would query both sleep and mood data and calculate correlation
        return nil
    }
    
    /// Gets mindfulness practice correlation with mood
    func getMindfulnessMoodCorrelation() async throws -> Double? {
        // Implementation for mindfulness-mood correlation analysis
        return nil
    }
    
    // MARK: - Private Helpers
    
    private func calculateSummary(from entries: [HealthMoodEntry]) -> HealthMoodSummary? {
        guard !entries.isEmpty else { return nil }
        
        let sortedEntries = entries.sorted { $0.date < $1.date }
        let dateRange = sortedEntries.first!.date...sortedEntries.last!.date
        
        let avgValence = entries.reduce(0) { $0 + $1.valence } / Double(entries.count)
        
        var distribution: [Sentiment: Int] = [:]
        for entry in entries {
            distribution[entry.sentiment, default: 0] += 1
        }
        
        // Calculate trend
        let recentAvg = entries.prefix(entries.count / 2).reduce(0) { $0 + $1.valence } / Double(entries.count / 2)
        let olderAvg = entries.suffix(entries.count / 2).reduce(0) { $0 + $1.valence } / Double(entries.count / 2)
        
        let trend: HealthMoodSummary.MoodTrend
        if recentAvg > olderAvg + 0.1 {
            trend = .improving
        } else if recentAvg < olderAvg - 0.1 {
            trend = .declining
        } else {
            trend = .stable
        }
        
        return HealthMoodSummary(
            averageValence: avgValence,
            totalEntries: entries.count,
            dateRange: dateRange,
            distribution: distribution,
            trend: trend
        )
    }
    
    // MARK: - Observation
    
    /// Sets up a long-running query to observe new mood entries
    func startObservingChanges() {
        guard isAuthorized == true else { return }
        
        let query = HKObserverQuery(
            sampleType: HKObjectType.stateOfMindType(),
            predicate: nil
        ) { [weak self] _, completionHandler, error in
            if let error = error {
                Log.healthKit.error("Observer query error: \(error)")
            } else {
                Task { @MainActor [weak self] in
                    await self?.loadRecentMoodData()
                }
            }
            completionHandler()
        }
        
        store.execute(query)
    }
    
    /// Deletes a mood entry from HealthKit
    func deleteMoodEntry(at date: Date) async throws {
        guard isAuthorized == true else {
            throw HealthKitError.authorizationNotDetermined
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: date.addingTimeInterval(-1),
            end: date.addingTimeInterval(1),
            options: .strictEndDate
        )
        
        try await store.deleteObjects(
            of: HKObjectType.stateOfMindType(),
            predicate: predicate
        )
    }
}


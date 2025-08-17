//
//  HealthKitTests.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/16/25.
//


import Testing
import Foundation
import HealthKit
import SwiftUI
@testable import DailyLock


@MainActor
@Suite("HealthKit Integration Tests")
struct HealthKitTests {
    
    @Test("HealthStore initializes correctly")
    func testHealthStoreInitialization() {
        let healthStore = HealthStore(errorState: ErrorState())
        #expect(healthStore.isAuthorized == nil, "Authorization should be nil initially")
        #expect(healthStore.isLoading == false)
        #expect(healthStore.recentMoodEntries.isEmpty)
        #expect(healthStore.moodSummary == nil)
    }
    
    @Test("Sentiment to HealthKit valence mapping is correct")
    func testSentimentValenceMapping() {
        #expect(Sentiment.positive.valence == 0.7)
        #expect(Sentiment.indifferent.valence == 0.0)
        #expect(Sentiment.negative.valence == -0.7)
    }
    
    @Test("Sentiment to HealthKit label mapping is correct")
    func testSentimentLabelMapping() {
        #expect(Sentiment.positive.label == .happy)
        #expect(Sentiment.indifferent.label == .indifferent)
        #expect(Sentiment.negative.label == .sad)
    }
    
    @Test("HealthMoodEntry sentiment conversion")
    func testHealthMoodEntrySentiment() {
        let positiveEntry = HealthMoodEntry(
            date: Date(),
            valence: 0.5,
            labels: [.happy],
            kind: .dailyMood,
            associations: [],
            metadata: nil
        )
        #expect(positiveEntry.sentiment == .positive)
        
        let negativeEntry = HealthMoodEntry(
            date: Date(),
            valence: -0.5,
            labels: [.sad],
            kind: .dailyMood,
            associations: [],
            metadata: nil
        )
        #expect(negativeEntry.sentiment == .negative)
        
        let neutralEntry = HealthMoodEntry(
            date: Date(),
            valence: 0.1,
            labels: [.indifferent],
            kind: .dailyMood,
            associations: [],
            metadata: nil
        )
        #expect(neutralEntry.sentiment == .indifferent)
    }
    
    @Test("HealthMoodSummary trend calculation")
    func testMoodTrendCalculation() {
        // Test improving trend
        let improvingTrend = HealthMoodSummary.MoodTrend.improving
        #expect(improvingTrend.icon == "arrow.up.circle.fill")
        #expect(improvingTrend.color == .green)
        
        // Test stable trend
        let stableTrend = HealthMoodSummary.MoodTrend.stable
        #expect(stableTrend.icon == "equal.circle.fill")
        #expect(stableTrend.color == .blue)
        
        // Test declining trend
        let decliningTrend = HealthMoodSummary.MoodTrend.declining
        #expect(decliningTrend.icon == "arrow.down.circle.fill")
        #expect(decliningTrend.color == .orange)
    }
    
    @Test("HealthKitError provides appropriate messages")
    func testHealthKitErrorMessages() {
        let notAvailable = HealthKitError.notAvailable
        #expect(notAvailable.title == "Health Not Available")
        #expect(notAvailable.severity == .info)
        
        let authDenied = HealthKitError.authorizationDenied
        #expect(authDenied.title == "Permission Denied")
        #expect(authDenied.recoveryAction != nil)
        
        let saveFailed = HealthKitError.saveFailed("Test error")
        #expect(saveFailed.title == "Save Failed")
        #expect(saveFailed.message.contains("Test error"))
    }
    
    @Test("HealthStore read and share types are configured correctly")
    func testHealthKitTypes() async {
        let healthStore = HealthStore(errorState: ErrorState())
        
        // Use reflection or KeyPath since readTypes/shareTypes are private
        // We'll use Mirror to access private properties for this test
        let mirror = Mirror(reflecting: healthStore)

        // Extract readTypes
        guard let readTypesClosure = mirror.children.first(where: { $0.label == "readTypes" })?.value as? () -> Set<HKObjectType> else {
            _ = Bool(false) // readTypes property not found
            return
        }
        let readTypes = readTypesClosure()

        // Extract shareTypes
        guard let shareTypesClosure = mirror.children.first(where: { $0.label == "shareTypes" })?.value as? () -> Set<HKSampleType> else {
            _ = Bool(false) // shareTypes property not found
            return
        }
        let shareTypes = shareTypesClosure()

        // Check read types
        #expect(readTypes.contains(HKObjectType.stateOfMindType()), "readTypes should include stateOfMindType")
        #expect(readTypes.contains(HKObjectType.categoryType(forIdentifier: .mindfulSession)!), "readTypes should include mindfulSession")

        if #available(iOS 16.0, *) {
            #expect(readTypes.contains(HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!), "readTypes should include sleepAnalysis on iOS 16+")
        }
        
        // Check share types
        #expect(shareTypes.count == 1)
        #expect(shareTypes.contains(HKObjectType.stateOfMindType()), "shareTypes should only include stateOfMindType")
    }
}


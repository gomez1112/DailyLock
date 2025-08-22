//
//  ModelAndServiceTests.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import Foundation
import Testing
import SwiftData
@testable import DailyLock

@MainActor
@Suite("Model and Service Tests")
struct ModelAndServiceTests {
    
    @MainActor
    @Suite("TipRecord Tests")
    struct TipRecordTests {
        @Test("isFromCurrentMonth logic is correct")
        func testIsFromCurrentMonth() {
            let currentMonthTip = TipRecord(transactionId: 1, date: Date(), amount: 1, productId: "", productName: "")
            
            // Note: This test is sensitive to the current date. For August 22, 2025, the previous month is July.
            let lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            let lastMonthTip = TipRecord(transactionId: 2, date: lastMonthDate, amount: 1, productId: "", productName: "")
            
            #expect(currentMonthTip.isFromCurrentMonth == true)
            #expect(lastMonthTip.isFromCurrentMonth == false)
        }
    }
    
    @MainActor
    @Suite("MomentumEntry Logic Tests")
    struct MomentumEntryLogicTests {
        @Test("calculateWordCount is accurate")
        func testWordCount() {
            #expect(MomentumEntry.calculateWordCount(from: "") == 0)
            #expect(MomentumEntry.calculateWordCount(from: "  ") == 0)
            #expect(MomentumEntry.calculateWordCount(from: "One two three.") == 3)
            #expect(MomentumEntry.calculateWordCount(from: "  Leading and trailing spaces.  ") == 4)
        }
        
        @Test("getRandomInkColor returns a valid color")
        func testRandomInkColor() {
            let validColors = ["#1a1a1a", "#2c3e50", "#34495e", "#16213e"]
            let generatedColor = MomentumEntry.getRandomInkColor()
            #expect(validColors.contains(generatedColor))
        }
    }
    
    @MainActor
    @Suite("ProductID Tests")
    struct ProductIDTests {
        @Test("Static collections are correct")
        func testCollections() {
            #expect(ProductID.textures.count == 4)
            #expect(ProductID.tips.count == 3)
            #expect(ProductID.subscriptions.count == 3)
            #expect(ProductID.all.count == 4 + 3 + 3 + 1) // textures + tips + subs + lifetime
        }
    }
    
    @MainActor
    @Suite("TipLedger Actor Tests")
    struct TipLedgerTests {
        @Test("Recording a tip succeeds and prevents duplicates")
        func testRecordTip() async throws {
            // ✅ Setup container and actor inside the test function
            let container = ModelContainerFactory.createEmptyContainer
            let ledger = TipLedger(modelContainer: container)
            
            let purchase = TipPurchase(
                transactionId: 12345,
                productID: ProductID.smallTip,
                productName: "Small Tip",
                amount: 1.99,
                date: Date()
            )
            
            // 1. Record the tip
            try await ledger.record(purchase)
            
            let fetchDescriptor = FetchDescriptor<TipRecord>()
            var tips = try container.mainContext.fetch(fetchDescriptor)
            #expect(tips.count == 1)
            #expect(tips.first?.transactionId == 12345)
            
            // 2. Try to record the same tip again
            try await ledger.record(purchase)
            
            tips = try container.mainContext.fetch(fetchDescriptor)
            #expect(tips.count == 1, "Duplicate transaction should not be recorded")
        }
    }
    
    @MainActor
    @Suite("DataService Tests")
    struct DataServiceTests {
        
        @Test("todayEntry finds entry for today")
        func testFindsTodayEntry() {
            // ✅ Setup container and service inside the test function
            let container = ModelContainerFactory.createEmptyContainer
            let dataService = DataService(container: container)
            
            let todayEntry = MomentumEntry(date: Date())
            let yesterdayEntry = MomentumEntry(date: Date().addingTimeInterval(-86400))
            let allEntries = [todayEntry, yesterdayEntry]
            
            let found = dataService.todayEntry(for: allEntries)
            #expect(found?.id == todayEntry.id)
        }
        
        @Test("lockEntry creates new entry when none exists")
        func testLockNewEntry() throws {
            // ✅ Setup container and service inside the test function
            let container = ModelContainerFactory.createEmptyContainer
            let dataService = DataService(container: container)
            
            
            dataService.lockEntry(text: "New", sentiment: .positive)
            
            let newAllEntries = try dataService.fetchAllEntries()
            #expect(newAllEntries.count == 1)
            #expect(newAllEntries.first?.text == "New")
            #expect(newAllEntries.first?.isLocked == true)
        }
        
        @Test("lockEntry updates existing entry")
        func testLockExistingEntry() throws {
            // ✅ Setup container and service inside the test function
            let container = ModelContainerFactory.createEmptyContainer
            let dataService = DataService(container: container)
            
            let existingEntry = MomentumEntry(text: "Old", sentiment: .negative)
            dataService.save(existingEntry)
            
            dataService.lockEntry(text: "Updated", sentiment: .positive)
            
            #expect(existingEntry.text == "Updated")
            #expect(existingEntry.sentiment == .positive)
            #expect(existingEntry.isLocked == true)
            #expect(existingEntry.wordCount == 1)
        }
    }
}


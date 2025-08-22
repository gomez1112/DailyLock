//
//  ErrorEnumsTests.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import Testing
import SwiftUI
@testable import DailyLock

@MainActor
@Suite("Error Handling Tests")
struct ErrorEnumsTests {
    
    @MainActor
    @Suite("StoreError Tests")
    struct StoreErrorTests {
        @Test("PurchaseFailed properties are correct")
        func testPurchaseFailed() {
            let error = StoreError.purchaseFailed("details")
            #expect(error.title == "Purchase Failed")
            #expect(error.message == "We couldn't complete your purchase. details")
            #expect(error.severity == .warning)
        }

        @Test("RestorationFailed properties are correct")
        func testRestorationFailed() {
            let error = StoreError.restorationFailed
            #expect(error.title == "Restoration Failed")
            #expect(error.severity == .error)
            #expect(error.icon == "xmark.circle.fill")
        }
        
        @Test("PaymentCancelled properties are correct")
        func testPaymentCancelled() {
            let error = StoreError.paymentCancelled
            #expect(error.title == "Payment Cancelled")
            #expect(error.severity == .info)
            #expect(error.icon == "xmark.circle")
        }
    }
    
    @MainActor
    @Suite("DatabaseError Tests")
    struct DatabaseErrorTests {
        @Test("SaveFailed properties are correct")
        func testSaveFailed() {
            let error = DatabaseError.saveFailed
            #expect(error.title == "Couldn't Save")
            #expect(error.message == "Your entry couldn't be saved. Don't worry, it's still in memory.")
            #expect(error.severity == .warning)
        }
        
        @Test("CorruptedData properties are correct")
        func testCorruptedData() {
            let error = DatabaseError.corruptedData
            #expect(error.title == "Data Issue")
            #expect(error.severity == .critical)
            #expect(error.icon == "exclamationmark.octagon.fill")
        }
    }
    
    @MainActor
    @Suite("NotificationError Tests")
    struct NotificationErrorTests {
        @Test("PermissionDenied properties are correct")
        func testPermissionDenied() {
            let error = NotificationError.permissionDenied
            #expect(error.title == "Notifications Disabled")
            #expect(error.message == "Enable notifications in Settings to receive daily reminders.")
            #expect(error.severity == .warning)
            #expect(error.icon == "bell.slash")
        }
    }
    
    @MainActor
    @Suite("IntelligenceError Tests")
    struct IntelligenceErrorTests {
        @Test("GenerationFailed properties are correct")
        func testGenerationFailed() {
            let error = IntelligenceError.generationFailed
            #expect(error.title == "Generation Failed")
            #expect(error.severity == .warning)
            #expect(error.icon == "sparkles")
        }
    }
    
    @MainActor
    @Suite("ErrorSeverity Tests")
    struct ErrorSeverityTests {
        @Test("Colors and icons are correct for all severities")
        func testSeverityProperties() {
            #expect(ErrorSeverity.info.color == .blue)
            #expect(ErrorSeverity.info.defaultIcon == "info.circle.fill")

            #expect(ErrorSeverity.warning.color == .orange)
            #expect(ErrorSeverity.warning.defaultIcon == "exclamationmark.triangle.fill")

            #expect(ErrorSeverity.error.color == .red)
            #expect(ErrorSeverity.error.defaultIcon == "xmark.circle.fill")
            
            #expect(ErrorSeverity.critical.color == .purple)
            #expect(ErrorSeverity.critical.defaultIcon == "exclamationmark.octagon.fill")
        }
    }
    
    @MainActor
    @Suite("ErrorRecoveryAction Tests")
    struct ErrorRecoveryActionTests {
        @Test("Labels and icons are correct for all actions")
        func testRecoveryActionProperties() {
            #expect(ErrorRecoveryAction.retry(action: {}).label == "Try Again")
            #expect(ErrorRecoveryAction.retry(action: {}).icon == "arrow.clockwise")
            
            #expect(ErrorRecoveryAction.settings.label == "Open Settings")
            #expect(ErrorRecoveryAction.settings.icon == "gear")

            #expect(ErrorRecoveryAction.upgrade.label == "Upgrade")
            #expect(ErrorRecoveryAction.upgrade.icon == "crown")

            #expect(ErrorRecoveryAction.contact.label == "Contact Support")
            #expect(ErrorRecoveryAction.contact.icon == "envelope")

            #expect(ErrorRecoveryAction.custom(label: "Custom", action: {}).label == "Custom")
            #expect(ErrorRecoveryAction.custom(label: "Custom", action: {}).icon == "hand.tap")
        }
    }
}

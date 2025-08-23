//
//  ErrorState.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import Foundation
import Observation
import os

@Observable
final class ErrorState {
    private(set) var currentError: (any AppError)?
    var isShowingError = false
    
    // Queue for managing multiple errors
    private var errorQueue: [any AppError] = []
    private var isProcessingQueue = false
    
    // Error history for debugging (only in DEBUG)
#if DEBUG
    private(set) var errorHistory: [(error: any AppError, timestamp: Date)] = []
#endif
    
    // MARK: - Public Methods
    
    func show(_ error: any AppError) {
#if DEBUG
        errorHistory.append((error, Date()))
        Log.app.error("Error: \(error.title) - \(error.message)")
#endif
        
        errorQueue.append(error)
        processNextError()
    }
    
    func dismiss() async {
        isShowingError = false
        
        try? await Task.sleep(for: .milliseconds(300))
        
        self.currentError = nil
        self.processNextError()
    }
    
    func clearAll() {
        errorQueue.removeAll()
        currentError = nil
        isShowingError = false
        isProcessingQueue = false
    }
    
    // MARK: - Private Methods
    
    private func processNextError() {
        guard !isProcessingQueue, !errorQueue.isEmpty else { return }
        guard currentError == nil else { return }
        
        isProcessingQueue = true
        currentError = errorQueue.removeFirst()
        isShowingError = true
        
        isProcessingQueue = false
    }
    
    // MARK: - Convenience Methods
    
    func showStoreError(_ message: String) {
        show(StoreError.purchaseFailed(message))
    }
    
    func showStoreError(_ type: StoreError) {
        show(type)
    }
    
    func showDatabaseError(_ type: DatabaseError) {
        show(type)
    }
    
    func showIntelligenceError(_ type: IntelligenceError) {
        show(type)
    }
    func showNotificationError(_ type: NotificationError) {
        show(type)
    }
    func showIntentError(_ type: IntentError) {
        show(type)
    }
}


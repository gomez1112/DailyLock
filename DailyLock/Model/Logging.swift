//
//  Logging.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/9/25.
//


import Foundation
import os

/// A centralized logging system based on os.Logger.
///
/// This enum provides categorized loggers for different subsystems of the app,
/// ensuring that log messages are organized, filterable, and efficient.
///
/// **Usage:**
/// ```
/// Log.app.info("Application did finish launching.")
/// Log.store.error("Failed to load products: \(error.localizedDescription, privacy: .public)")
/// Log.data.debug("Fetched \(entries.count) entries.")
/// ```
/// By default, logs are viewable in Xcode's console and the system's Console.app.
/// You can filter by subsystem (e.g., "com.dailylock.app") or by category (e.g., "Store").
nonisolated enum Log {
    private static let subsystem = "com.transfinite.DailyLock"

    /// Logs general application lifecycle events.
    static let app = Logger(subsystem: subsystem, category: "App")

    /// Logs events related to StoreKit, in-app purchases, and transactions.
    static let store = Logger(subsystem: subsystem, category: "Store")

    /// Logs events related to SwiftData, including fetches, saves, and deletions.
    static let data = Logger(subsystem: subsystem, category: "Data")

    /// Logs events related to UI, such as view appearances or complex layout calculations.
    static let ui = Logger(subsystem: subsystem, category: "UI")
    
    /// Logs events related to the AI/FoundationModels interactions.
    static let intelligence = Logger(subsystem: subsystem, category: "Intelligence")
    
    static let healthKit = Logger(subsystem: subsystem, category: "HealthKit")
}

//
//  Signpost.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/9/25.
//


import Foundation
import os

/// A utility for performance measurement using OSSignposter.
///
/// This enum provides categorized signposters and a convenient `measure` method
/// to wrap performance-critical code blocks. These measurements can be visualized
/// in Xcode's Instruments to identify performance bottlenecks.
///
/// **Usage:**
/// ```
/// try await Signpost.store.measure(name: "LoadProducts") {
///     // Code to measure, e.g., await Product.products(for:)
/// }
/// ```
/// The measured interval will appear in the "Signposts" instrument timeline.
enum Signpost: Sendable {
    private static let subsystem = "com.transfinite.DailyLock"

    /// Signposts for StoreKit and transaction-related operations.
    static let store = OSSignposter(subsystem: subsystem, category: "Store")

    /// Signposts for database operations (SwiftData).
    static let database = OSSignposter(subsystem: subsystem, category: "Database")

    /// Signposts for performance-critical UI updates or data processing for views.
    static let ui = OSSignposter(subsystem: subsystem, category: "UI")
    
    /// Signposts for AI model generation and processing.
    static let intelligence = OSSignposter(subsystem: subsystem, category: "Intelligence")
}

extension OSSignposter {
    /// Measures the execution time of a synchronous or asynchronous code block.
    ///
    /// This helper function simplifies using OSSignposter by handling the begin/end state
    /// and ensuring that intervals are correctly marked even if the block throws an error.
    ///
    /// - Parameters:
    ///   - name: A static string describing the measured interval. This name appears in Instruments.
    ///   - block: The code block to execute and measure.
    /// - Returns: The result of the code block.
    /// - Throws: Any error thrown by the code block.
    @inlinable
    func measure<T>(name: StaticString, _ block: () async throws -> T) async rethrows -> T {
        let state = beginInterval(name)
        do {
            let result = try await block()
            endInterval(name, state)
            return result
        } catch {
            endInterval(name, state) // End interval even on error
            throw error
        }
    }
}

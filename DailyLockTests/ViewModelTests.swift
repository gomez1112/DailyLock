//
//  ViewModelTests.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import Testing
import SwiftUI
@testable import DailyLock

@MainActor
@Suite("ViewModel Logic Tests")
struct ViewModelTests {
    
    @MainActor
    @Suite("SearchViewModel Tests")
    struct SearchViewModelTests {
        let allEntries = MomentumEntry.samples
        var viewModel = SearchViewModel()
        
        @Test("filterEntries returns empty for empty search text")
        mutating func testEmptySearch() {
            viewModel.searchText = ""
            viewModel.filterEntries(allEntries: allEntries)
            #expect(viewModel.filteredEntries.isEmpty)
        }
        
        @Test("filterEntries returns correct results for text search")
        mutating func testTextSearch() {
            viewModel.searchText = "recipe" // Should find one entry
            viewModel.filterEntries(allEntries: allEntries)
            #expect(viewModel.filteredEntries.count == 1)
            #expect(viewModel.filteredEntries.first?.detail.contains("recipe") ?? false)
        }
        
        @Test("filterEntries is case-insensitive")
        mutating func testCaseInsensitiveSearch() {
            viewModel.searchText = "RECIPE"
            viewModel.filterEntries(allEntries: allEntries)
            #expect(viewModel.filteredEntries.count == 1)
        }
        
        @Test("filterEntries returns correct results for sentiment search")
        mutating func testSentimentSearch() {
            viewModel.searchText = "positive"
            viewModel.filterEntries(allEntries: allEntries)
            let positiveCount = allEntries.filter { $0.sentiment == .positive }.count
            #expect(viewModel.filteredEntries.count == positiveCount)
        }
        
        @Test("filterEntries returns no results for non-matching query")
        mutating func testNoResults() {
            viewModel.searchText = "nonexistent_query_xyz"
            viewModel.filterEntries(allEntries: allEntries)
            #expect(viewModel.filteredEntries.isEmpty)
        }
    }
    
    @MainActor
    @Suite("TimelineViewModel Tests")
    struct TimelineViewModelTests {
        var viewModel = TimelineViewModel()
        
        @Test("toggleMonth adds and removes month from expanded set")
        mutating func testToggleMonth() {
            let month = "August 2025"
            #expect(viewModel.expandedMonths.isEmpty)
            viewModel.toggleMonth(month)
            #expect(viewModel.expandedMonths.contains(month))
            viewModel.toggleMonth(month)
            #expect(viewModel.expandedMonths.isEmpty)
        }
        
        @Test("groupedEntries correctly groups and sorts entries")
        func testGroupedEntries() {
            let entries = [
                MomentumEntry(date: Date(year: 2025, month: 8, day: 1)!),
                MomentumEntry(date: Date(year: 2025, month: 7, day: 15)!),
                MomentumEntry(date: Date(year: 2025, month: 8, day: 5)!)
            ]
            let grouped = viewModel.groupedEntries(for: entries)
            #expect(grouped.count == 2)
            #expect(grouped.first?.key == "August 2025")
            #expect(grouped.first?.value.count == 2)
            #expect(grouped.last?.key == "July 2025")
        }
    }
    
    @MainActor
    @Suite("ErrorState Tests")
    struct ErrorStateTests {
        var errorState = ErrorState()
        
        @Test("show() displays first error and queues others")
        mutating func testErrorQueueing() {
            let error1 = DatabaseError.saveFailed
            let error2 = StoreError.purchaseFailed("details")
            
            errorState.show(error1)
            #expect(errorState.isShowingError)
            #expect(errorState.currentError?.title == "Couldn't Save")
            
            errorState.show(error2)
            // Should still be showing the first error
            #expect(errorState.isShowingError)
            #expect(errorState.currentError?.title == "Couldn't Save")
        }
        
        @Test("dismiss() shows next error in queue")
        mutating func testErrorDismissal() async {
            let error1 = DatabaseError.saveFailed
            let error2 = StoreError.purchaseFailed("details")
            
            errorState.show(error1)
            errorState.show(error2)
            
            // Await the entire dismissal and re-processing logic
            await errorState.dismiss()
            
            #expect(errorState.isShowingError)
            #expect(errorState.currentError?.title == "Purchase Failed")
        }
    }
    
    @MainActor
    @Suite("JournalingSuggestionViewModel Tests")
    struct JournalingSuggestionViewModelTests {
        var viewModel = JournalingSuggestionViewModel()
        
        @Test("firstReflectionPrompt returns default when empty")
        func testDefaultPrompt() {
            let defaultPrompt = "Click 'Get Suggestion' to generate a new prompt."
            #expect(viewModel.firstReflectionPrompt == defaultPrompt)
        }
        
        @Test("firstReflectionPrompt returns first prompt when available")
        mutating func testFirstPrompt() {
            viewModel.reflectionPrompts = ["First", "Second"]
            #expect(viewModel.firstReflectionPrompt == "First")
        }
        
        @Test("firstReflectionColor returns default when empty")
        func testDefaultColor() {
            #expect(viewModel.firstReflectionColor == .orange)
        }
        
        @Test("firstReflectionColor returns first color when available")
        mutating func testFirstColor() {
            viewModel.reflectionColors = [.blue, .green]
            #expect(viewModel.firstReflectionColor == .blue)
        }
    }
}

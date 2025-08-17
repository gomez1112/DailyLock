//
//  JournalingSuggestionViewModel.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/16/25.
//

#if canImport(JournalingSuggestions)
import JournalingSuggestions
#endif
import Foundation
import Observation
import SwiftUI

@Observable
final class JournalingSuggestionViewModel {
   
    var suggestionTitle: String? = nil
    var reflectionPrompts: [String] = []
    var reflectionColors: [Color] = []
    
#if canImport(JournalingSuggestions)
    func processSuggestion(_ suggestion: JournalingSuggestion) {
        suggestionTitle = suggestion.title
        
        Task { @MainActor in
            // Fetch all content
            let reflections = await suggestion.content(forType: JournalingSuggestion.Reflection.self)
            
            // Extract value types
            self.reflectionPrompts = reflections.map { $0.prompt }
            
            // Convert Color to hex strings for storage
            self.reflectionColors = reflections.map { $0.color ?? .orange}
        }
    }
#endif
    
    var firstReflectionPrompt: String {
        reflectionPrompts.first ?? "Click 'Get Suggestion' to generate a new prompt."
    }
    
    var firstReflectionColor: Color {
        reflectionColors.first ?? .orange
    }
}

//
//  InsightGenerator.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/29/25.
//

import Foundation
import FoundationModels
import Observation
import Playgrounds

@Observable
final class InsightGenerator {
    
    private(set) var insight: WeeklyInsight.PartiallyGenerated?
    private let session: LanguageModelSession
    
    
    init(entries: [MomentumEntry])  {
        session = LanguageModelSession {
            "You are an empathetic journaling coach who is concise, supportive, and specific;"
            "You will be provided with a schema for a 'WeeklyInsight' and must generate content that fits it perfectly."
            """
            Here is an array of the user's journal entries from the last 7 days. You must base your summary on these entries:
            """
            entries.sorted { $0.date > $1.date }.prefix(7).map { $0.detail }.joined(separator: "\n---\n")
            
        }
    }
    
    func suggestWeeklyInsight() async throws {
        reset()
        let stream = session.streamResponse(generating: WeeklyInsight.self, includeSchemaInPrompt: true) {
            "Generate a weekly insight for the past 7 days."
            "Provide an encouraging title."
            "Synthesize the week into a single paragraph of about 6 sentences."
            "Offer two actionable, supportive suggestions phrased positibely. Each should be no more than 2 sentences"
            "Include one motivational quote that is a single sentence long"
            
            "Please use the following as a structural reference, but do not copy its content:"
            WeeklyInsight.example
        }
        for try await partialInsight in stream {
            insight = partialInsight.content
        }
    }
    func prewarm() {
        session.prewarm()
    }
    var isResponding: Bool {
        session.isResponding
    }
    func reset() {
        insight = nil
    }
}



import SwiftUI
import Testing
@testable import DailyLock

@MainActor
@Suite("Sentiment Enum Tests")
struct SentimentTests {
    
    @Test("Sentiment.allCases contains all cases")
    func testAllCases() {
        let cases = Sentiment.allCases
        #expect(cases.contains(.positive))
        #expect(cases.contains(.indifferent))
        #expect(cases.contains(.negative))
        #expect(cases.count == 3)
    }

    @Test("Sentiment gradients contain 3 colors each", arguments: Sentiment.allCases)
    func testGradients(sentiment: Sentiment) {
        #expect(sentiment.gradient.count == 3)
    }

    @Test("Sentiment inkIntensity values are correct")
    func testInkIntensity() {
        #expect(Sentiment.positive.inkIntensity == 3.0)
        #expect(Sentiment.indifferent.inkIntensity == 2.0)
        #expect(Sentiment.negative.inkIntensity == 1.0)
    }

    @Test("Sentiment.id returns itself")
    func testId() {
        for sentiment in Sentiment.allCases {
            #expect(sentiment.id == sentiment)
        }
    }

    @Test("Sentiment.color is first gradient color")
    func testColor() {
        for sentiment in Sentiment.allCases {
            #expect(sentiment.color == sentiment.gradient.first)
        }
    }
}

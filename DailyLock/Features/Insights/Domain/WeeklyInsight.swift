//
//  WeeklyInsight.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/29/25.
//

import Foundation
import FoundationModels

@Generable
struct WeeklyInsight: Equatable {
    
    @Guide(description: "An encouraging and concise title for the week's summary.")
    var title: String
    
    @Guide(description: "A 6-sentence paragraph synthesizing the user's week.")
    var summary: String
    
    @Guide(description: "Two actionable and supportive suggestions, phrased positively. Each should be 1-2 sentences.", .count(2))
    var actionItems: [String]
    
    @Guide(description: "A concise, motivational quote that is a single sentence long.")
    var quote: String
    
    static let example = WeeklyInsight(
        title: "A Week of Building Momentum",
        
        summary: "This week, you showed incredible dedication to your goals. You consistently tackled your most important tasks each morning, building a strong foundation for the days that followed. There was a notable increase in your productivity, particularly on Thursday when you completed the project brief ahead of schedule. You also made time for rest, which was crucial for maintaining your energy levels. This balance allowed you to approach challenges with a clear and focused mind. Your efforts this week have set a positive and sustainable pace for the weeks to come.",
        
        actionItems: [
            "1. Take a few moments to write down three small wins from this past week to acknowledge your progress.",
            "2. Consider scheduling a 20-minute walk without your phone to continue blending mindfulness with your routine."
        ],
        
        quote: "The secret of change is to focus all of your energy not on fighting the old, but on building the new."
    )
}

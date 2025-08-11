//
//  WeeklyInsight.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/29/25.
//

import Foundation
import FoundationModels

@Generable
struct WeeklyInsight {
    
    @Guide(description: "A encouraging title")
    var title: String
    
    @Guide(description: "6 sentence paragraph synthesizing the week.")
    var summary: String
    
    @Guide(description: "Actionable, supportive suggestions phrased positively. No more than 2 sentences.", .count(2))
    var actionsItems: [String]
    
    @Guide(description: "A motivational quote. Only 1 sentence long.")
    var quote: String
}

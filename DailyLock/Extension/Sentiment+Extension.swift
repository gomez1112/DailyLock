//
//  Sentiment+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
import Foundation



nonisolated extension Sentiment: AppEnum {
  
    static var typeDisplayRepresentation: TypeDisplayRepresentation { TypeDisplayRepresentation(stringLiteral: "Sentiment") }
    
    static let caseDisplayRepresentations: [Sentiment : DisplayRepresentation] =
        [
            .positive: DisplayRepresentation(title: "Positive", image: .init(systemName: "sun.max.fill")),
            .indifferent: DisplayRepresentation(title: "Indifferent", image: .init(systemName: "cloud.fill")),
            .negative: DisplayRepresentation(title: "Negative", image: .init(systemName: "cloud.rain.fill"))
        ]
    
}

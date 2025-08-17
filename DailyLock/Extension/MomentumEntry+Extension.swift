//
//  MomentumEntry+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/1/25.
//

import Foundation

extension MomentumEntry {
    static var samples: [MomentumEntry] {
        [
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 30*2), text: "Lost motivation and skipped tasks.", sentiment: .indifferent, lockedAt: Date().addingTimeInterval(-86400 * 30*2)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 9), text: "Started a new book and learned something insightful.", sentiment: .positive, lockedAt: Date().addingTimeInterval(-86400 * 9)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 8), text: "Work was challenging but I managed the stress.", sentiment: .indifferent,lockedAt: Date().addingTimeInterval(-86400 * 8)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 7), text: "Felt under the weather today, stayed in mostly.", sentiment: .negative, lockedAt: Date().addingTimeInterval(-86400 * 7)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 6), text: "Had an energizing workout in the morning!", sentiment: .positive, lockedAt: Date().addingTimeInterval(-86400 * 6)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 5), text: "Productive day with a few interruptions.", sentiment: .indifferent, lockedAt: Date().addingTimeInterval(-86400 * 5)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 4), text: "Argued with a friend, feeling regretful.", sentiment: .negative, lockedAt: Date().addingTimeInterval(-86400 * 4)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 3), text: "Tried a new recipe, it was delicious!", sentiment: .positive, lockedAt: Date().addingTimeInterval(-86400 * 3)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 2), text: "Average day, nothing much to note.", sentiment: .indifferent, lockedAt: Date().addingTimeInterval(-86400 * 2)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 1), text: "Lost motivation and skipped tasks.", sentiment: .negative, lockedAt: Date().addingTimeInterval(-86400 * 1)),
            MomentumEntry(date: Date(), text: "Lost motivation and skipped tasks.", sentiment: .negative, lockedAt: Date.now)
        ]
    }
}


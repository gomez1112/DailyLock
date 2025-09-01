//
//  DailyEntryIntent.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import AppIntents
import Foundation
import WidgetKit

struct DailyEntryIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Daily Entry"
    static let description = IntentDescription("Shows today's journal entry status")
}

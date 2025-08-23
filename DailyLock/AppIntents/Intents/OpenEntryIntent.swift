//
//  OpenEntryIntent.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents

struct OpenEntryIntent: OpenIntent, TargetContentProvidingIntent {
    
    static let title: LocalizedStringResource = "Open to Today"
    
    @Parameter(title: "Entry")
    var target: MomentumEntryEntity
}

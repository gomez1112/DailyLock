//
//  DailyLockEntryWidget.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import AppIntents
import SwiftUI
import WidgetKit

struct DailyLockEntryWidgetView: View {
    let entry: DailyEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: entry.hasEntry ? "checkmark.seal.fill" : "pencil.tip")
                    .font(.title2)
                    .foregroundStyle(entry.hasEntry ? .green : .accent)
                    .symbolEffect(.pulse, isActive: !entry.hasEntry)
                Spacer()
            }
            Text(entry.hasEntry ? "Captured" : "Write Today")
                .font(.headline)
                .foregroundStyle(.primary)
            
            if let momentumEntry = entry.entry {
                Text(momentumEntry.detail)
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
            } else {
                Button(intent: StartNewEntry()) {
                    Text("Tap to start")
                        .font(.caption)
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
    }
}


#Preview(as: .systemSmall) {
    DailyEntryWidget()
} timeline: {
    DailyEntry(date: Date(), hasEntry: true, entry: MomentumEntry(title: "Family", detail: "I love to be with my family!"))
    DailyEntry(date: Date(), hasEntry: false, entry: nil)
}

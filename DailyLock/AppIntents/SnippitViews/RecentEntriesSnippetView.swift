//
//  RecentEntriesSnippetView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import SwiftUI
struct RecentEntriesSnippetView: View {
    let entries: [MomentumEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(entries.prefix(3), id: \.date) { entry in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(entry.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Image(systemName: entry.sentiment.symbol)
                            .foregroundStyle(entry.sentiment.color)
                    }
                    
                    Text(entry.text)
                        .font(.system(.body))
                }
                .padding(.vertical, 4)
                
                if entry.date != entries.prefix(3).last?.date {
                    Divider()
                }
            }
        }
        .padding()
    }
}

//
//  JournalStatisticsSummary.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
import Foundation
import CoreTransferable
internal import UniformTypeIdentifiers

struct JournalStatisticsSummary: TransientAppEntity {
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Journal Summary")
    
    @Property var summaryStartDate: Date
    @Property var totalEntries: Int
    @Property var currentStreak: Int
    @Property var longestStreak: Int
    @Property var totalWordsWritten: Int
    
    init() {
        summaryStartDate = Date()
        totalEntries = 0
        currentStreak = 0
        longestStreak = 0
        totalWordsWritten = 0
    }
    var summaryStartDateFormatted: String {
        let calendar = Calendar.current
        let startDate = summaryStartDate
        let endDate = Date()
        
        let timeSpanText: String
        
        if calendar.isDate(startDate, equalTo: endDate, toGranularity: .month) {
            // Same month
            timeSpanText = "this month"
        } else if calendar.isDate(startDate, equalTo: endDate, toGranularity: .year) {
            // Same year, different month
            let monthDiff = calendar.dateComponents([.month], from: startDate, to: endDate).month ?? 0
            if monthDiff == 1 {
                timeSpanText = "over the past 2 months"
            } else {
                timeSpanText = "over the past \(monthDiff + 1) months"
            }
        } else {
            // Different years
            let components = calendar.dateComponents([.year, .month], from: startDate, to: endDate)
            let years = components.year ?? 0
            let months = components.month ?? 0
            
            if years == 1 && months == 0 {
                timeSpanText = "over the past year"
            } else if years > 0 {
                timeSpanText = "over the past \(years) year\(years == 1 ? "" : "s")"
            } else {
                timeSpanText = "over the past \(months) month\(months == 1 ? "" : "s")"
            }
        }
        return timeSpanText
    }
    var displayRepresentation: DisplayRepresentation {
        var image = "chart.bar.xaxis"
        var subtitle = LocalizedStringResource("You wrote \(totalEntries.formatted()) entries.")
        
        if totalEntries == 0 {
            image = "pencil"
            subtitle = LocalizedStringResource("No entries yet.")
        }
        return DisplayRepresentation(title: "Journal Summary", subtitle: subtitle, image: DisplayRepresentation.Image(systemName: image), synonyms: ["Journal Statistics Summary"])
    }
}

#if canImport(UIKit)
import UIKit
extension JournalStatisticsSummary: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .rtf) { summary in
            try summary.richTextRepresentation
        }
        FileRepresentation(exportedContentType: .png) { summary in
            SentTransferredFile(try summary.imageFileRepresentation, allowAccessingOriginalFile: true)
        }
    }
    
    private var formattedSummary: AttributedString {
        
        var string = AttributedString( """
            Journal Summary
            
            Total Entries Completed: \(totalEntries.formatted())
            Current Streak: \(currentStreak.formatted())
            Longest Streak: \(longestStreak.formatted())
            Average Words: \(totalWordsWritten.formatted())
            """)
        string.font = .systemFont(ofSize: 12, weight: .regular)
        
        if let range = string.range(of: "Journal Summary") {
            string[range].font = .systemFont(ofSize: 16, weight: .bold)
        }
        return string
    }
    private var richTextRepresentation: Data {
        get throws {
            let attributedString = NSAttributedString(formattedSummary)
            return try attributedString.data(from: NSRange(location: 0, length: attributedString.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf, .characterEncoding: String.Encoding.utf8])
        }
    }
    /// - Returns: A `UIImage` with the rendered summary.
    private func textToImage(drawText text: AttributedString) -> UIImage {
        let bounds = CGSize(width: 250, height: 100)
        
        let renderer = UIGraphicsImageRenderer(size: bounds)
        let img = renderer.image { ctx in
            let backgroundColor = #colorLiteral(red: 0.8259537816, green: 1, blue: 0.8045250773, alpha: 1)
            backgroundColor.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
            
            let attributedString = NSAttributedString(text)
            attributedString.draw(with: CGRect(x: 15, y: 15, width: bounds.width - 15, height: bounds.height - 15),
                                  options: .usesLineFragmentOrigin,
                                  context: nil)
        }
        return img
    }
    
    /// - Returns: A URL to an image file with the rendered summary.
    private var imageFileRepresentation: URL {
        get throws {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("journalsummary")
                .appendingPathExtension("png")
            
            let image = textToImage(drawText: formattedSummary)
            let data = image.pngData()
            try data?.write(to: url)
            return url
        }
    }
}
#endif

//
//  MomentumEntryEntity.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
import CoreSpotlight
import CoreTransferable
import SwiftUI

/// Represents a `MomentumEntry` within the App Intents framework (e.g., in Shortcuts).
///
/// This entity exposes key properties of a journal entry so they can be read, filtered,
/// and passed between actions in a shortcut.
struct MomentumEntryEntity: IndexedEntity {

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Journal Entry", numericFormat: "\(placeholder: .int) entries")
    }
    
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(date, format: .relative(presentation: .named))",
            subtitle: "\(title)"
        )
    }
    
    /// Defines how the system can query for `MomentumEntryEntity` objects.
    static let defaultQuery = MomentumEntryQuery()
    
    var attributeSet: CSSearchableItemAttributeSet {
        let attributeSet = defaultAttributeSet
        attributeSet.title = title
        attributeSet.contentDescription = detail
        attributeSet.addedDate = date
        return attributeSet
    }
    
   
    
    var id: UUID
    
    @Property(indexingKey: \.title)
    var title: String
    
    @Property(indexingKey: \.contentDescription)
    var detail: String
    
    @Property(indexingKey: \.addedDate)
    var date: Date
    
    @Property
    var sentiment: Sentiment
    
    @Property(title: "Is Locked")
    var isLocked: Bool
    
    @Property(title: "Word Count")
    var wordCount: Int
    
    init(from entry: MomentumEntry) {
        self.id = entry.id
        self.title = entry.title
        self.detail = entry.detail
        self.date = entry.date
        self.sentiment = entry.sentiment
        self.isLocked = entry.isLocked
        self.wordCount = entry.wordCount
    }
}

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension MomentumEntryEntity: Transferable {
   
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .pdf) { @MainActor entry in
            let url = URL.documentsDirectory.appending(path: "\(entry.sentiment.rawValue).pdf")
            
            let renderer = ImageRenderer(content: ZStack {
                Image(.brownLightTexture)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(entry.title)
            }
                .frame(width: 600))
            renderer.render { size, renderer in
                var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
                pdf.beginPDFPage(nil)
                renderer(pdf)
                pdf.endPDFPage()
                pdf.closePDF()
            }
            return .init(url)
        }
        DataRepresentation(exportedContentType: .image) { try $0.imageRepresentationData }
        DataRepresentation(exportedContentType: .plainText) {
            """
            Entry: \($0.title)
            Detail: \($0.detail)
            Date: \($0.date)
            Sentiment: \($0.sentiment.rawValue.capitalized)
            """.data(using: .utf8)!
        }
    }
    var imageRepresentationData: Data {
        get throws {
            try loadAssetData(named: "defaultLightPaper")
        }
    }
    
    var thumbnailRepresentationData: Data {
        get throws {
            try loadAssetData(named: "defaultLightPaper")
        }
    }
    
    private func loadAssetData(named name: String) throws -> Data {
        struct ImageCreationError: Error {}
#if canImport(UIKit)
        let image = UIImage(named: name)
        if let imageData = image?.pngData() {
            return imageData
        } else {
            throw ImageCreationError()
        }
#elseif canImport(AppKit)
        guard let image = NSImage(named: name) else {
            throw ImageCreationError()
        }
        guard let tiffData = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapImage.representation(using: .png, properties: [:]) else {
            throw ImageCreationError()
        }
        return pngData
#else
        throw ImageCreationError()
#endif
    }
}

extension MomentumEntryEntity {
    var sharePreview: SharePreview<Never, Image> {
        SharePreview(title, icon: Image("defaultDarkPaper"))
    }
}

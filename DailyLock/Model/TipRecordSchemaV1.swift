import Foundation
import SwiftData

typealias TipRecord = TipRecordSchemaV1.TipRecord

enum TipRecordSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [TipRecord.self]
    }
    
    @Model
    final class TipRecord {
        var date: Date
        var amount: Decimal
        var productId: String
        var productName: String
        
        init(date: Date = Date(), amount: Decimal, productId: String, productName: String) {
            self.date = date
            self.amount = amount
            self.productId = productId
            self.productName = productName
        }
        
        // Helper to check if tip is from current month
        var isFromCurrentMonth: Bool {
            let calendar = Calendar.current
            return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
        }
        
        // Helper to get month/year string
        var monthYearString: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        }
    }
}
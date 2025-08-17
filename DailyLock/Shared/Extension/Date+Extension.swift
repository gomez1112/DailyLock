
//
//  Date+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/23/25.
//

import Foundation

extension Date {
    
    /// Initializes a `Date` instance from the provided year, month, and day components using the current calendar.
    /// - Parameters:
    ///   - year: The year component of the date.
    ///   - month: The month component of the date.
    ///   - day: The day component of the date. Defaults to 1.
    /// - Returns: A `Date` instance representing the specified year, month, and day if valid; otherwise, `nil`.

    init?(year: Int, month: Int, day: Int = 1) {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)
        guard let date = calendar.date(from: components) else {
            return nil
        }
        self = date
    }

    /// A string representation of the current year using the user's current calendar.
    /// - Returns: The current year as a string without grouping separators.
    /// - Example: For the year 2025, this returns "2025".
    /// 
    static var currentYear: String {
        Calendar.current.component(.year, from: Date()).formatted(.number.grouping(.never))
    }
}

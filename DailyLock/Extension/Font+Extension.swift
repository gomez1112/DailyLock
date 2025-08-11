//
//  Font+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

extension Font {
    static let sentenceSerif = Font.custom("Georgia", size: DesignSystem.Text.Font.sentenceSerifSize)
    static let dateScript = Font.custom("Snell Roundhand", size: DesignSystem.Text.Font.dateScriptSize)
    static let uiRounded = Font.system(.body, design: .rounded)
}

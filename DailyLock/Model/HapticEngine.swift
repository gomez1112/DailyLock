//
//  HapticEngine.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Observation
#if canImport(UIKit)
import UIKit
#endif

@Observable
final class HapticEngine {
#if canImport(UIKit)
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let notificationFeedback = UINotificationFeedbackGenerator()
 
#endif
    
    init() {
#if canImport(UIKit)
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        selectionFeedback.prepare()
        notificationFeedback.prepare()
#endif
    }
    func warning() {
#if canImport(UIKit)
        notificationFeedback.notificationOccurred(.warning)
#endif
    }
    func tap() {
#if canImport(UIKit)
        impactLight.impactOccurred()
#endif
    }
    
    func select() {
#if canImport(UIKit)
        selectionFeedback.selectionChanged()
#endif
    }
    
    func lock() {
#if canImport(UIKit)
        impactHeavy.impactOccurred()
#else
        // Could play a sound on macOS if desired
#endif
    }
    
    func success() {
#if canImport(UIKit)
        notificationFeedback.notificationOccurred(.success)
#else
        // Could play a success sound on macOS if desired
#endif
    }
}

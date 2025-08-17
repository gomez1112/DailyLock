//
//  OnboardingStep.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/17/25.
//


enum OnboardingStep: Int, CaseIterable, Identifiable, Equatable {
    
    case welcome, concept, notifications, premium, getStarted
    var id: Int { rawValue }

    static var totalPages: Int { allCases.count }
}

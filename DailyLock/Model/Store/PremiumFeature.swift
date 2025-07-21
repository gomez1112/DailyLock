//
//  PremiumFeature.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation

enum PremiumFeature: String, CaseIterable {
        case unlimitedEntries = "Unlimited Daily Entries"
        case advancedInsights = "Mood & Keyword Trends"
        case aiSummaries = "Weekly AI Summaries"
        case streakRescue = "Streak Rescue (1/month)"
        case customThemes = "Premium Themes & Fonts"
        case smartReminders = "Smart Reminders"
        case secureBackup = "Encrypted Cloud Backup"
        case yearbook = "Annual Yearbook Generator"
        
        var icon: String {
            switch self {
            case .unlimitedEntries: return "infinity"
            case .advancedInsights: return "chart.line.uptrend.xyaxis"
            case .aiSummaries: return "sparkles"
            case .streakRescue: return "bandage"
            case .customThemes: return "paintbrush"
            case .smartReminders: return "bell.badge"
            case .secureBackup: return "lock.icloud"
            case .yearbook: return "book.closed"
            }
        }
    }

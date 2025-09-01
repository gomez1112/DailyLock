// MARK: - Configuration Intent (optional range)
// You can expand this later with more parameters if desired.
struct MoodWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Mood Widget" }
    static var description: IntentDescription { "Shows your mood distribution." }
    
    @Parameter(title: "Time Range", default: .last30Days)
    var range: MoodWidgetRange
}

enum MoodWidgetRange: String, AppEnum, CaseIterable, Identifiable {
    case last7Days
    case last30Days
    case allTime
    
    var id: Self { self }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Time Range"
    }
    
    static var caseDisplayRepresentations: [MoodWidgetRange : DisplayRepresentation] {
        [
            .last7Days: "Last 7 Days",
            .last30Days: "Last 30 Days",
            .allTime: "All Time"
        ]
    }
    
    // Use direct property reference; #Predicate doesn't support dynamic keyPath subscripts.
    func datePredicate() -> Predicate<MomentumEntry>? {
        switch self {
        case .allTime:
            return nil
        case .last7Days:
            let start = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date.distantPast
            return #Predicate { $0.date >= start }
        case .last30Days:
            let start = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date.distantPast
            return #Predicate { $0.date >= start }
        }
    }
    
    // Helper to compute a start date for simple in-memory filtering (used by the widget’s DataService path).
    func startDateForFilter() -> Date? {
        switch self {
        case .allTime:
            return nil
        case .last7Days:
            return Calendar.current.date(byAdding: .day, value: -7, to: Date())
        case .last30Days:
            return Calendar.current.date(byAdding: .day, value: -30, to: Date())
        }
    }
}
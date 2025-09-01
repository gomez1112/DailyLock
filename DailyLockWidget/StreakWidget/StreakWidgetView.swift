struct StreakWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: StreakEntry
    
    var body: some View {
        Button(intent: GetCurrentStreak()) {
            switch family {
            case .systemSmall:
                SmallStreakView(entry: entry)
            case .systemMedium:
                MediumStreakView(entry: entry)
            default:
                EmptyView()
            }
        }
        .buttonStyle(.plain)
    }
}
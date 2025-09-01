struct SmallStreakView: View {
    let entry: StreakEntry
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.largeTitle)
                .foregroundStyle(
                    LinearGradient(
                        colors: entry.isInGracePeriod ? [.orange, .yellow] : [.orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(.pulse.byLayer, isActive: entry.currentStreak > 0)
            
            Text("\(entry.currentStreak)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
            
            Text(entry.currentStreak == 1 ? "Day" : "Days")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if entry.isInGracePeriod {
                Text("Complete today!")
                    .font(.caption2)
                    .foregroundStyle(.orange)
            }
        }
        .widgetURL(URL(string: "dailylock://insights"))
    }
}
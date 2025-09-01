struct MediumStreakView: View {
    let entry: StreakEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Label("Current", systemImage: "flame.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(entry.currentStreak) days")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                
                if entry.isInGracePeriod {
                    Label("Grace period active", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Label("Best", systemImage: "trophy.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(entry.longestStreak) days")
                    .font(.title3)
                    .foregroundStyle(.primary)
                
                ProgressView(value: Double(entry.currentStreak), total: Double(max(entry.longestStreak, entry.currentStreak)))
                    .tint(.accent)
            }
        }
        .widgetURL(URL(string: "dailylock://insights"))
    }
}
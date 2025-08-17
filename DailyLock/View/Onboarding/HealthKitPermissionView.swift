//
//  HealthKitPermissionView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/16/25.
//


import SwiftUI
import HealthKit

struct HealthKitPermissionView: View {
    @Environment(AppDependencies.self) private var dependencies
    @State private var isRequesting = false
    @State private var permissionGranted = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    let onComplete: () -> Void
    
    var body: some View {
        OnboardingPageView {
            // Visual Panel
            visualContent
        } content: {
            // Content Panel
            contentPanel
        }
    }
    
    @ViewBuilder
    private var visualContent: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.pink.opacity(0.1),
                    Color.purple.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated health icons
            GeometryReader { geometry in
                ForEach(0..<5) { index in
                    HealthFloatingIcon(
                        index: index,
                        size: geometry.size
                    )
                }
            }
            
            // Central icon
            VStack {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.pink.opacity(0.2),
                                    Color.pink.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 20)
                    
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.pink, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .symbolEffect(.pulse, value: isRequesting)
                }
                
                if permissionGranted {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Connected")
                            .fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.green.opacity(0.1), in: Capsule())
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentPanel: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Text("Connect to Apple Health")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityIdentifier("healthKitTitle")
                
                Text("Sync your mood data with Apple Health to see how your emotions connect with your overall wellbeing")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("healthKitDescription")
            }
            
            // Benefits list
            VStack(alignment: .leading, spacing: 16) {
                HealthBenefit(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Track Mood Trends",
                    description: "See how your emotions change over time"
                )
                
                HealthBenefit(
                    icon: "brain.filled.head.profile",
                    title: "Holistic Insights",
                    description: "Connect mood with sleep, exercise & mindfulness"
                )
                
                HealthBenefit(
                    icon: "lock.shield.fill",
                    title: "Private & Secure",
                    description: "Your health data stays on your device"
                )
            }
            .padding(.vertical)
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 12) {
                Button {
                    Task {
                        await requestHealthKitPermission()
                    }
                } label: {
                    HStack {
                        if isRequesting {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.white)
                        } else if permissionGranted {
                            Image(systemName: "checkmark")
                        } else {
                            Image(systemName: "heart.fill")
                        }
                        
                        Text(permissionGranted ? "Connected!" : "Connect Health")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(permissionGranted ? Color.green : Color.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(isRequesting || permissionGranted)
                .accessibilityIdentifier("connectHealthButton")
                
                if !permissionGranted {
                    Button("Skip for Now") {
                        onComplete()
                    }
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("skipHealthButton")
                }
                
                if permissionGranted {
                    Button("Continue") {
                        onComplete()
                    }
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .accessibilityIdentifier("continueButton")
                }
            }
        }
        .padding(.horizontal, 40)
        .alert("Health Connection Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func requestHealthKitPermission() async {
        isRequesting = true
        
        do {
            let authorized = try await dependencies.healthStore.requestAuthorization()
            
            await MainActor.run {
                if authorized {
                    withAnimation(.spring()) {
                        permissionGranted = true
                    }
                    dependencies.haptics.success()
                    
                    // Auto-continue after a short delay
                    Task {
                        try? await Task.sleep(for: .seconds(1.5))
                        onComplete()
                    }
                } else {
                    errorMessage = "Permission denied. You can enable it later in Settings."
                    showError = true
                }
                isRequesting = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
                isRequesting = false
            }
        }
    }
}

// MARK: - Supporting Views

private struct HealthBenefit: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.accent)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct HealthFloatingIcon: View {
    let index: Int
    let size: CGSize
    @State private var offset = CGSize.zero
    @State private var opacity = 0.0
    
    private var icon: String {
        ["heart.fill", "brain", "figure.walk", "moon.fill", "sun.max.fill"][index % 5]
    }
    
    private var color: Color {
        [.pink, .purple, .blue, .indigo, .orange][index % 5]
    }
    
    var body: some View {
        Image(systemName: icon)
            .font(.title2)
            .foregroundStyle(color.opacity(opacity))
            .offset(offset)
            .onAppear {
                animateIcon()
            }
    }
    
    private func animateIcon() {
        let startX = CGFloat.random(in: 0...size.width)
        let startY = CGFloat.random(in: 0...size.height)
        let endX = CGFloat.random(in: 0...size.width)
        let endY = CGFloat.random(in: 0...size.height)
        
        offset = CGSize(width: startX, height: startY)
        
        withAnimation(.easeInOut(duration: Double.random(in: 8...12)).repeatForever(autoreverses: true)) {
            offset = CGSize(width: endX, height: endY)
        }
        
        withAnimation(.easeIn(duration: 1).delay(Double(index) * 0.2)) {
            opacity = 0.3
        }
    }
}

#Preview {
    HealthKitPermissionView(onComplete: {})
        .environment(AppDependencies(configuration: .preview))
}

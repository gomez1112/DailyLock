//
//  ErrorAlertModifier.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import Foundation
import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Environment(\.openURL) private var openURL
    @Environment(AppDependencies.self) private var dependencies
    
    func body(content: Content) -> some View {
        content
            .alert(
                dependencies.errorState.currentError?.title ?? "Error",
                isPresented: Bindable(dependencies.errorState).isShowingError
            ) {
                // Buttons
                if let recovery = dependencies.errorState.currentError?.recoveryAction {
                    recoveryButton(for: recovery)
                }
                
                Button("Dismiss", role: .cancel) {
                    Task {
                        await dependencies.errorState.dismiss()
                    }
                    
                }
            } message: {
                VStack {
                    Text(dependencies.errorState.currentError?.message ?? "An unexpected error occurred.")
                }
            }
            .onChange(of: dependencies.errorState.isShowingError) { _, isShowing in
                if isShowing {
                    // Haptic feedback based on severity
                    switch dependencies.errorState.currentError?.severity {
                        case .critical, .error:
                            dependencies.haptics.warning()
                        case .warning:
                            dependencies.haptics.tap()
                        default:
                            break
                    }
                }
            }
    }
    
    @ViewBuilder
    private func recoveryButton(for action: ErrorRecoveryAction) -> some View {
        switch action {
            case .retry(let retryAction):
                Button("Try Again") {
                    Task {
                        await retryAction()
                        await dependencies.errorState.dismiss()
                    }
                }
                
            case .settings:
                Button("Open Settings") {
#if !os(macOS)
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
#endif
                    Task {
                       await dependencies.errorState.dismiss()
                    }
                    
                }
                
            case .upgrade:
                Button("Upgrade") {
                    dependencies.navigation.presentedSheet = .paywall
                    Task {
                        await dependencies.errorState.dismiss()
                    }
                    
  
                }
                
            case .contact:
                Button("Contact Support") {
                    if let url = URL(string: "mailto:gerard@transfinite.cloud") {
                        openURL(url)
                    }
                    Task {
                     await dependencies.errorState.dismiss()
                    }
                    
                }
                
            case .custom(let label, let customAction):
                Button(label) {
                    Task {
                        await customAction()
                        await dependencies.errorState.dismiss()
                    }
                }
        }
    }
}

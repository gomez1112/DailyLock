//
//  MessageView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/6/25.
//


import SwiftUI

struct MessageView: View {
    let error: Error?
    let message: String?
    
    init(error: Error? = nil, message: String? = nil) {
        self.error = error
        self.message = message
    }
    var body: some View {
        VStack {
            Spacer()
            if let error {
                Text("\(error.localizedDescription)")
                    .foregroundStyle(.red)
                    .padding()
            } else if let message {
                Text("\(message)")
                    .foregroundStyle(.primary)
                    .font(.title3)
                    .padding()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cardBackground()
    }
}



//
//  SearchView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        ZStack {
            PaperTextureView()
                .ignoresSafeArea()
            Text("Searching...")
        }
    }
}

#Preview {
    SearchView()
}

//
//  BuzzerBeaterApp.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/22/26.
//

import SwiftUI

@main
struct BuzzerBeaterApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            ContentView()
                .opacity(showSplash ? 0 : 1)

            if showSplash {
                SplashView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

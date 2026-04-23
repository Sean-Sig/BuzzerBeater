//
//  SplashView.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/23/26.
//

import SwiftUI

struct SplashView: View {
  @State private var ballScale: CGFloat = 0.4
  @State private var ballOpacity: Double = 0
  @State private var titleOffset: CGFloat = 30
  @State private var titleOpacity: Double = 0
  @State private var subtitleOpacity: Double = 0
  @State private var glowRadius: CGFloat = 0
  @State private var ringScale: CGFloat = 0.6
  @State private var ringOpacity: Double = 0

  var body: some View {
    ZStack {
      // Background
      LinearGradient(
        colors: [Color(hex: "#0A1628"), Color(hex: "#1D2E4A"), Color(hex: "#0A1628")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      // Decorative ring
      Circle()
        .strokeBorder(
          LinearGradient(
            colors: [Color(hex: "#C8102E").opacity(0.6), Color(hex: "#1D428A").opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 1.5
        )
        .frame(width: 280, height: 280)
        .scaleEffect(ringScale)
        .opacity(ringOpacity)

      Circle()
        .strokeBorder(
          LinearGradient(
            colors: [Color(hex: "#1D428A").opacity(0.4), Color(hex: "#C8102E").opacity(0.2)],
            startPoint: .topTrailing,
            endPoint: .bottomLeading
          ),
          lineWidth: 1
        )
        .frame(width: 360, height: 360)
        .scaleEffect(ringScale * 0.92)
        .opacity(ringOpacity * 0.6)

      VStack(spacing: 24) {
        ZStack {
          // Glow
          Circle()
            .fill(Color(hex: "#C8102E").opacity(0.25))
            .frame(width: 120, height: 120)
            .blur(radius: glowRadius)

          // Ball
          Image(systemName: "basketball.fill")
            .font(.system(size: 80))
            .foregroundStyle(
              LinearGradient(
                colors: [Color(hex: "#C8102E"), Color(hex: "#A00020")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .shadow(color: Color(hex: "#C8102E").opacity(0.5), radius: 20)
        }
        .scaleEffect(ballScale)
        .opacity(ballOpacity)

        VStack(spacing: 8) {
          Text("BuzzerBeater")
            .font(.system(size: 36, weight: .black, design: .rounded))
            .foregroundStyle(.white)
            .offset(y: titleOffset)
            .opacity(titleOpacity)

          Text("NBA PLAYOFFS TRACKER")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color(hex: "#C8102E"))
            .kerning(3)
            .opacity(subtitleOpacity)
        }
      }
    }
    .onAppear { animate() }
  }

  private func animate() {
    // Ring expands in
    withAnimation(.spring(duration: 1.0, bounce: 0.3)) {
      ringScale = 1.0
      ringOpacity = 1.0
    }

    // Ball drops in
    withAnimation(.spring(duration: 0.7, bounce: 0.5).delay(0.2)) {
      ballScale = 1.0
      ballOpacity = 1.0
    }

    // Glow pulses
    withAnimation(.easeOut(duration: 0.6).delay(0.5)) {
      glowRadius = 30
    }

    // Title slides up
    withAnimation(.spring(duration: 0.6, bounce: 0.3).delay(0.55)) {
      titleOffset = 0
      titleOpacity = 1.0
    }

    // Subtitle fades in
    withAnimation(.easeOut(duration: 0.5).delay(0.85)) {
      subtitleOpacity = 1.0
    }
  }
}

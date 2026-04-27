//
//  ContentView.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/22/26.
//

import SwiftUI

struct ContentView: View {
    @State var store = NBAStore()

    var body: some View {
        TabView {
            ScoresView(store: store)
                .tabItem { Label("Scores", systemImage: "basketball.fill") }
            NewsView(store: store)
                .tabItem { Label("News", systemImage: "newspaper.fill") }
            RankingsView(store: store)
                .tabItem { Label("Rankings", systemImage: "list.number") }
        }
    }
}

struct ScoresView: View {
    var store: NBAStore
    @Environment(\.colorScheme) var colorScheme
    @State private var showProfile = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // MARK: Live Games
                    if !store.liveGames.isEmpty {
                        SectionHeader(
                            title: "Live Now",
                            systemImage: "dot.radiowaves.left.and.right",
                            tint: .red
                        )
                        VStack(spacing: 14) {
                            ForEach(store.liveGames) { game in
                                NavigationLink(
                                    destination: GameDetailView(game: game)
                                ) {
                                    LiveGameCard(game: game)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: Upcoming Games
                    if !store.upcomingGames.isEmpty {
                        SectionHeader(
                            title: "Upcoming",
                            systemImage: "calendar",
                            tint: .blue
                        )
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(store.upcomingGames) { game in
                                    NavigationLink(
                                        destination: GameDetailView(game: game)
                                    ) {
                                        UpcomingGameCard(game: game)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // MARK: Past Games
                    if !store.pastGames.isEmpty {
                        SectionHeader(
                            title: "Results",
                            systemImage: "flag.checkered",
                            tint: .secondary
                        )
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(store.pastGames) { game in
                                    NavigationLink(
                                        destination: GameDetailView(game: game)
                                    ) {
                                        PastGameCard(game: game)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    Spacer(minLength: 32)
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("NBA Playoffs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showProfile = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.primary)
                    }
                    .accessibilityLabel("Settings")
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileSheetView()
            }
        }
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    var title: String
    var systemImage: String
    var tint: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .foregroundStyle(tint)
                .font(.subheadline.weight(.semibold))
            Text(title)
                .font(.title2.weight(.bold))
        }
        .padding(.horizontal)
    }
}

// MARK: - Card Background Modifier

struct CardBackground: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(
                color: colorScheme == .dark
                    ? .black.opacity(0.4) : .black.opacity(0.08),
                radius: colorScheme == .dark ? 12 : 8,
                y: colorScheme == .dark ? 4 : 3
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        Color.white.opacity(colorScheme == .dark ? 0.06 : 0),
                        lineWidth: 1
                    )
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardBackground())
    }
}

// MARK: - Live Game Card

struct LiveGameCard: View {
    var game: PlayoffGame

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TeamScoreColumn(
                    team: game.awayTeam,
                    isWinning: game.awayTeam.score > game.homeTeam.score
                )
                VStack(spacing: 4) {
                    LiveBadge()
                    Text(game.quarter)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.secondary)
                    Text(game.clock)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 70)
                TeamScoreColumn(
                    team: game.homeTeam,
                    isWinning: game.homeTeam.score > game.awayTeam.score
                )
            }
            .padding(.vertical, 16)

            Divider()

            HStack {
                Label(game.seriesLabel, systemImage: "trophy.fill")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.orange)
                Spacer()
                Text(game.broadcast)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("· \(game.round.rawValue)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .cardStyle()
    }
}

struct TeamScoreColumn: View {
    var team: TeamScore
    var isWinning: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Color(hex: team.primaryColor).opacity(0.2))
                    .frame(width: 46, height: 46)
                Text(team.abbreviation)
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(Color(hex: team.primaryColor))
            }
            Text(
                team.name.components(separatedBy: " ").last ?? team.abbreviation
            )
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.secondary)
            .lineLimit(1)
            Text("\(team.score)")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundStyle(isWinning ? .primary : .tertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct LiveBadge: View {
    @State private var pulse = false

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(.red)
                .frame(width: 7, height: 7)
                .scaleEffect(pulse ? 1.4 : 1)
                .animation(
                    .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                    value: pulse
                )
                .onAppear { pulse = true }
            Text("LIVE")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.red)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.red.opacity(0.15))
        .clipShape(Capsule())
    }
}

// MARK: - Upcoming Game Card

struct UpcomingGameCard: View {
    var game: PlayoffGame

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(game.round.rawValue)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(.blue)
                .clipShape(Capsule())

            HStack(spacing: 10) {
                CompactTeamBadge(team: game.awayTeam)
                Text("@")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                CompactTeamBadge(team: game.homeTeam)
            }

            Text(game.seriesLabel)
                .font(.caption.weight(.medium))
                .foregroundStyle(.orange)

            Spacer()

            Divider()

            VStack(alignment: .leading, spacing: 3) {
                Label(game.tipoff, systemImage: "clock")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                Label(game.broadcast, systemImage: "tv")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(width: 200, height: 185)
        .cardStyle()
    }
}

struct CompactTeamBadge: View {
    var team: TeamScore

    var body: some View {
        VStack(spacing: 3) {
            ZStack {
                Circle()
                    .fill(Color(hex: team.primaryColor).opacity(0.2))
                    .frame(width: 36, height: 36)
                Text(team.abbreviation)
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(Color(hex: team.primaryColor))
            }
            Text("\(team.seed)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Past Game Card

struct PastGameCard: View {
    var game: PlayoffGame

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(game.round.rawValue)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Gm \(game.gameNumber)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                FinalTeamRow(
                    team: game.awayTeam,
                    isWinner: game.awayTeam.score > game.homeTeam.score
                )
                Spacer()
                Text("FINAL")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Spacer()
                FinalTeamRow(
                    team: game.homeTeam,
                    isWinner: game.homeTeam.score > game.awayTeam.score
                )
            }

            Spacer()

            Divider()

            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(.orange)
                    .font(.caption)
                Text(game.seriesLabel)
                    .font(.caption.weight(.medium))
                Spacer()
                Text(game.tipoff)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(width: 240, height: 165)
        .cardStyle()
    }
}

struct FinalTeamRow: View {
    var team: TeamScore
    var isWinner: Bool

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color(hex: team.primaryColor).opacity(0.2))
                    .frame(width: 34, height: 34)
                Text(team.abbreviation)
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(Color(hex: team.primaryColor))
            }
            Text("\(team.score)")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundStyle(isWinner ? .primary : .tertiary)
        }
    }
}

// MARK: - Color Helper

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

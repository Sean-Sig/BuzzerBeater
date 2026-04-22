//
//  GameDetailView.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/22/26.
//

import SwiftUI

struct GameDetailView: View {
    var game: PlayoffGame
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Score / Status hero
                VStack(spacing: 16) {
                    Text(game.round.rawValue)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(.blue)
                        .clipShape(Capsule())

                    HStack(spacing: 0) {
                        DetailTeamColumn(
                            team: game.awayTeam,
                            isHome: false,
                            isWinning: game.awayTeam.score
                                > game.homeTeam.score,
                            showScore: game.status != .upcoming
                        )
                        VStack(spacing: 6) {
                            switch game.status {
                            case .live:
                                LiveBadge()
                                Text(game.quarter)
                                    .font(.headline.weight(.bold))
                                Text(game.clock)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            case .upcoming:
                                Image(systemName: "basketball.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color(hex: "#C8102E"))
                                Text("VS")
                                    .font(.headline.weight(.black))
                            case .final_:
                                Text("FINAL")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(width: 80)
                        DetailTeamColumn(
                            team: game.homeTeam,
                            isHome: true,
                            isWinning: game.homeTeam.score
                                > game.awayTeam.score,
                            showScore: game.status != .upcoming
                        )
                    }

                    HStack(spacing: 8) {
                        seriesIndicator(wins: game.awayTeam.seriesWins)
                        Text(game.seriesLabel)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.orange)
                        seriesIndicator(wins: game.homeTeam.seriesWins)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            Color.white.opacity(
                                colorScheme == .dark ? 0.07 : 0
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: colorScheme == .dark
                        ? .black.opacity(0.5) : .black.opacity(0.08),
                    radius: colorScheme == .dark ? 14 : 8,
                    y: 4
                )
                .padding(.horizontal)

                // Game info
                VStack(spacing: 0) {
                    InfoRow(
                        label: "Arena",
                        value: game.arena,
                        icon: "mappin.circle.fill"
                    )
                    Divider().padding(.leading, 48)
                    InfoRow(
                        label: "Tipoff",
                        value: game.tipoff,
                        icon: "clock.fill"
                    )
                    Divider().padding(.leading, 48)
                    InfoRow(label: "TV", value: game.broadcast, icon: "tv.fill")
                    Divider().padding(.leading, 48)
                    InfoRow(
                        label: "Game",
                        value: "Game \(game.gameNumber)",
                        icon: "number.circle.fill"
                    )
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            Color.white.opacity(
                                colorScheme == .dark ? 0.07 : 0
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: colorScheme == .dark
                        ? .black.opacity(0.4) : .black.opacity(0.07),
                    radius: colorScheme == .dark ? 10 : 6,
                    y: 2
                )
                .padding(.horizontal)

                // Team records
                VStack(alignment: .leading, spacing: 0) {
                    Text("Team Records")
                        .font(.headline)
                        .padding()
                    Divider()
                    HStack {
                        VStack(spacing: 4) {
                            Text(game.awayTeam.abbreviation)
                                .font(.title3.weight(.black))
                                .foregroundStyle(
                                    Color(hex: game.awayTeam.primaryColor)
                                )
                            Text(game.awayTeam.record)
                                .font(.title2.weight(.bold))
                            Text("Record")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        Divider().frame(height: 60)
                        VStack(spacing: 4) {
                            Text(game.homeTeam.abbreviation)
                                .font(.title3.weight(.black))
                                .foregroundStyle(
                                    Color(hex: game.homeTeam.primaryColor)
                                )
                            Text(game.homeTeam.record)
                                .font(.title2.weight(.bold))
                            Text("Record")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            Color.white.opacity(
                                colorScheme == .dark ? 0.07 : 0
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: colorScheme == .dark
                        ? .black.opacity(0.4) : .black.opacity(0.07),
                    radius: colorScheme == .dark ? 10 : 6,
                    y: 2
                )
                .padding(.horizontal)

                Spacer(minLength: 32)
            }
            .padding(.top, 12)
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Game \(game.gameNumber)")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func seriesIndicator(wins: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(
                        i < wins ? Color.orange : Color.secondary.opacity(0.25)
                    )
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct DetailTeamColumn: View {
    var team: TeamScore
    var isHome: Bool
    var isWinning: Bool
    var showScore: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(hex: team.primaryColor).opacity(0.2))
                    .frame(width: 58, height: 58)
                Text(team.abbreviation)
                    .font(.system(size: 16, weight: .black))
                    .foregroundStyle(Color(hex: team.primaryColor))
            }
            Text(
                team.name.components(separatedBy: " ").last ?? team.abbreviation
            )
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            Text(isHome ? "HOME" : "AWAY")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.tertiary)
            if showScore {
                Text("\(team.score)")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundStyle(isWinning ? .primary : .tertiary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct InfoRow: View {
    var label: String
    var value: String
    var icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 24)
                .padding(.leading, 12)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
        }
        .padding(.vertical, 13)
        .padding(.trailing, 16)
    }
}

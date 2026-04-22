//
//  GameDetailView.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/22/26.
//

import SwiftUI

struct GameDetailView: View {
    var game: PlayoffGame

    var body: some View {
        ScrollView {
            VStack(spacing: 20.0) {

                VStack(spacing: 16.0) {
                    Text(game.round.rawValue)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12.0)
                        .padding(.vertical, 5.0)
                        .background(Color(hex: "#1D428A"))
                        .clipShape(Capsule())

                    HStack(spacing: .zero) {
                        DetailTeamColumn(
                            team: game.awayTeam,
                            isHome: false,
                            isWinning: game.awayTeam.score
                                > game.homeTeam.score,
                            showScore: game.status != .upcoming
                        )
                        VStack(spacing: 6.0) {
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
                        .frame(width: 80.0)
                        DetailTeamColumn(
                            team: game.homeTeam,
                            isHome: true,
                            isWinning: game.homeTeam.score
                                > game.awayTeam.score,
                            showScore: game.status != .upcoming
                        )
                    }

                    // Series status
                    HStack(spacing: 8.0) {
                        seriesIndicator(wins: game.awayTeam.seriesWins)
                        Text(game.seriesLabel)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.orange)
                        seriesIndicator(wins: game.homeTeam.seriesWins)
                    }
                }
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .shadow(color: .black.opacity(0.08), radius: 8.0, y: 3.0)
                .padding(.horizontal)

                // Game info
                VStack(spacing: .zero) {
                    InfoRow(
                        label: "Arena",
                        value: game.arena,
                        icon: "mappin.circle.fill"
                    )
                    Divider().padding(.leading, 48.0)
                    InfoRow(
                        label: "Tipoff",
                        value: game.tipoff,
                        icon: "clock.fill"
                    )
                    Divider().padding(.leading, 48.0)
                    InfoRow(label: "TV", value: game.broadcast, icon: "tv.fill")
                    Divider().padding(.leading, 48.0)
                    InfoRow(
                        label: "Game",
                        value: "Game \(game.gameNumber)",
                        icon: "number.circle.fill"
                    )
                }
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 16.0))
                .shadow(color: .black.opacity(0.07), radius: 6.0, y: 2.0)
                .padding(.horizontal)

                // Team records
                VStack(alignment: .leading, spacing: .zero) {
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
                        Divider().frame(height: 60.0)
                        VStack(spacing: 4.0) {
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
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 16.0))
                .shadow(color: .black.opacity(0.07), radius: 6.0, y: 2.0)
                .padding(.horizontal)

                Spacer(minLength: 32.0)
            }
            .padding(.top, 12.0)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Game \(game.gameNumber)")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    func seriesIndicator(wins: Int) -> some View {
        HStack(spacing: 4.0) {
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(
                        i < wins ? Color.orange : Color.secondary.opacity(0.3)
                    )
                    .frame(width: 8.0, height: 8)
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
        VStack(spacing: 8.0) {
            ZStack {
                Circle()
                    .fill(Color(hex: team.primaryColor).opacity(0.15))
                    .frame(width: 58.0, height: 58.0)
                Text(team.abbreviation)
                    .font(.system(size: 16.0, weight: .black))
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
                    .font(.system(size: 40.0, weight: .black, design: .rounded))
                    .foregroundStyle(isWinning ? .primary : .secondary)
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
        HStack(spacing: 12.0) {
            Image(systemName: icon)
                .foregroundStyle(Color(hex: "#1D428A"))
                .frame(width: 24.0)
                .padding(.leading, 12.0)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
        }
        .padding(.vertical, 13.0)
        .padding(.trailing, 16.0)
    }
}

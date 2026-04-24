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
    @State private var selectedTeam: TeamSide = .home

    enum TeamSide { case home, away }

    var activeBoxScore: TeamBoxScore {
        selectedTeam == .home ? game.homeBoxScore : game.awayBoxScore
    }

    var activeTeam: TeamScore {
        selectedTeam == .home ? game.homeTeam : game.awayTeam
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // MARK: Score Hero
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
                .cardSection(colorScheme: colorScheme, radius: 20)
                .padding(.horizontal)

                // MARK: Game Info
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
                .cardSection(colorScheme: colorScheme)
                .padding(.horizontal)

                // MARK: Box Score
                if !game.homeBoxScore.players.isEmpty {
                    VStack(alignment: .leading, spacing: 0) {

                        // Team picker
                        HStack {
                            Text("Box Score")
                                .font(.headline)
                            Spacer()
                            Picker("Team", selection: $selectedTeam) {
                                Text(game.awayTeam.abbreviation).tag(
                                    TeamSide.away
                                )
                                Text(game.homeTeam.abbreviation).tag(
                                    TeamSide.home
                                )
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 130)
                        }
                        .padding()

                        Divider()

                        // Stat header
                        StatHeaderRow(
                            teamColor: Color(hex: activeTeam.primaryColor)
                        )

                        Divider()

                        // Starters
                        if !activeBoxScore.starters.isEmpty {
                            SectionLabel(title: "STARTERS")
                            ForEach(activeBoxScore.starters) { player in
                                PlayerStatRow(
                                    stat: player,
                                    teamColor: Color(
                                        hex: activeTeam.primaryColor
                                    )
                                )
                                if player.id != activeBoxScore.starters.last?.id
                                {
                                    Divider().padding(.leading, 16)
                                }
                            }
                        }

                        // Bench
                        if !activeBoxScore.bench.isEmpty {
                            Divider()
                            SectionLabel(title: "BENCH")
                            ForEach(activeBoxScore.bench) { player in
                                PlayerStatRow(
                                    stat: player,
                                    teamColor: Color(
                                        hex: activeTeam.primaryColor
                                    )
                                )
                                if player.id != activeBoxScore.bench.last?.id {
                                    Divider().padding(.leading, 16)
                                }
                            }
                        }

                        // Team totals
                        Divider()
                        TeamTotalsRow(
                            boxScore: activeBoxScore,
                            teamColor: Color(hex: activeTeam.primaryColor)
                        )
                    }
                    .cardSection(colorScheme: colorScheme)
                    .padding(.horizontal)
                }

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

// MARK: - Box Score Subviews

struct SectionLabel: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.caption2.weight(.bold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.tertiarySystemGroupedBackground))
    }
}

struct StatHeaderRow: View {
    var teamColor: Color
    var body: some View {
        HStack(spacing: 0) {
            Text("PLAYER")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            Group {
                Text("MIN").frame(width: 36)
                Text("PTS").frame(width: 36)
                Text("REB").frame(width: 36)
                Text("AST").frame(width: 36)
                Text("STL").frame(width: 30)
                Text("BLK").frame(width: 30)
                Text("TO").frame(width: 30)
                Text("FG").frame(width: 44).padding(.trailing, 8)
            }
        }
        .font(.caption2.weight(.bold))
        .foregroundStyle(.secondary)
        .padding(.vertical, 7)
    }
}

struct PlayerStatRow: View {
    var stat: PlayerGameStat
    var teamColor: Color

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 1) {
                Text(stat.name.components(separatedBy: " ").last ?? stat.name)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                Text(stat.position)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)

            Group {
                Text(stat.minutes).frame(width: 36)
                Text("\(stat.points)")
                    .fontWeight(stat.points >= 20 ? .bold : .regular)
                    .foregroundStyle(stat.points >= 20 ? teamColor : .primary)
                    .frame(width: 36)
                Text("\(stat.rebounds)").frame(width: 36)
                Text("\(stat.assists)").frame(width: 36)
                Text("\(stat.steals)").frame(width: 30)
                Text("\(stat.blocks)").frame(width: 30)
                Text("\(stat.turnovers)").frame(width: 30)
                Text("\(stat.fgm)/\(stat.fga)")
                    .foregroundStyle(.secondary)
                    .frame(width: 44)
                    .padding(.trailing, 8)
            }
        }
        .font(.caption)
        .padding(.vertical, 10)
    }
}

struct TeamTotalsRow: View {
    var boxScore: TeamBoxScore
    var teamColor: Color

    var totPts: Int { boxScore.players.reduce(0) { $0 + $1.points } }
    var totReb: Int { boxScore.players.reduce(0) { $0 + $1.rebounds } }
    var totAst: Int { boxScore.players.reduce(0) { $0 + $1.assists } }
    var totStl: Int { boxScore.players.reduce(0) { $0 + $1.steals } }
    var totBlk: Int { boxScore.players.reduce(0) { $0 + $1.blocks } }
    var totTO: Int { boxScore.players.reduce(0) { $0 + $1.turnovers } }
    var totFGM: Int { boxScore.players.reduce(0) { $0 + $1.fgm } }
    var totFGA: Int { boxScore.players.reduce(0) { $0 + $1.fga } }

    var body: some View {
        HStack(spacing: 0) {
            Text("TOTALS")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            Group {
                Text("—").frame(width: 36)
                Text("\(totPts)").foregroundStyle(teamColor).frame(width: 36)
                Text("\(totReb)").frame(width: 36)
                Text("\(totAst)").frame(width: 36)
                Text("\(totStl)").frame(width: 30)
                Text("\(totBlk)").frame(width: 30)
                Text("\(totTO)").frame(width: 30)
                Text("\(totFGM)/\(totFGA)")
                    .foregroundStyle(.secondary)
                    .frame(width: 44)
                    .padding(.trailing, 8)
            }
        }
        .font(.caption.weight(.semibold))
        .padding(.vertical, 10)
        .background(Color(.tertiarySystemGroupedBackground))
    }
}

// MARK: - Reusable Supporting Views

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

// MARK: - Card Style Helper

struct CardSectionModifier: ViewModifier {
    var colorScheme: ColorScheme
    var radius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .strokeBorder(
                        Color.white.opacity(colorScheme == .dark ? 0.07 : 0),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: colorScheme == .dark
                    ? .black.opacity(0.4) : .black.opacity(0.07),
                radius: colorScheme == .dark ? 10 : 6,
                y: 2
            )
    }
}

extension View {
    func cardSection(colorScheme: ColorScheme, radius: CGFloat = 16)
        -> some View
    {
        modifier(CardSectionModifier(colorScheme: colorScheme, radius: radius))
    }
}

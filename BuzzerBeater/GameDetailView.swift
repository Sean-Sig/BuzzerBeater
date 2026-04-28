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
    @State private var selectedTab: GameTab = .overview
    @State private var selectedTeam: TeamSide = .home

    enum GameTab: String, CaseIterable {
        case overview = "Overview"
        case boxScore = "Box Score"
        case chat = "Chat"
    }

    enum TeamSide { case home, away }

    var activeBoxScore: TeamBoxScore {
        selectedTeam == .home ? game.homeBoxScore : game.awayBoxScore
    }

    var activeTeam: TeamScore {
        selectedTeam == .home ? game.homeTeam : game.awayTeam
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Sticky score header
            ScoreHeroView(game: game)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .overlay(alignment: .bottom) { Divider() }

            // MARK: Tab picker
            HStack(spacing: 0) {
                ForEach(GameTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.snappy) { selectedTab = tab }
                    } label: {
                        VStack(spacing: 6) {
                            Text(tab.rawValue)
                                .font(
                                    .subheadline.weight(
                                        selectedTab == tab
                                            ? .semibold : .regular
                                    )
                                )
                                .foregroundStyle(
                                    selectedTab == tab ? .primary : .secondary
                                )
                            Rectangle()
                                .fill(
                                    selectedTab == tab
                                        ? Color(hex: "#C8102E") : .clear
                                )
                                .frame(height: 2)
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 2)
            .background(Color(.secondarySystemGroupedBackground))
            .overlay(alignment: .bottom) { Divider() }

            // MARK: Tab content
            switch selectedTab {
            case .overview:
                OverviewTab(game: game, colorScheme: colorScheme)
            case .boxScore:
                BoxScoreTab(
                    game: game,
                    colorScheme: colorScheme,
                    selectedTeam: $selectedTeam,
                    activeBoxScore: activeBoxScore,
                    activeTeam: activeTeam
                )
            case .chat:
                ChatTab(game: game, colorScheme: colorScheme)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(
            "\(game.awayTeam.abbreviation) vs \(game.homeTeam.abbreviation)"
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Score Hero

struct ScoreHeroView: View {
    var game: PlayoffGame

    var body: some View {
        VStack(spacing: 12) {
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
                    isWinning: game.awayTeam.score > game.homeTeam.score,
                    showScore: game.status != .upcoming
                )
                VStack(spacing: 6) {
                    switch game.status {
                    case .live:
                        LiveBadge()
                        Text(game.quarter).font(.headline.weight(.bold))
                        Text(game.clock).font(.subheadline).foregroundStyle(
                            .secondary
                        )
                    case .upcoming:
                        Image(systemName: "basketball.fill").font(.title2)
                            .foregroundStyle(Color(hex: "#C8102E"))
                        Text("VS").font(.headline.weight(.black))
                    case .final_:
                        Text("FINAL").font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 80)
                DetailTeamColumn(
                    team: game.homeTeam,
                    isHome: true,
                    isWinning: game.homeTeam.score > game.awayTeam.score,
                    showScore: game.status != .upcoming
                )
            }

            HStack(spacing: 8) {
                seriesIndicator(wins: game.awayTeam.seriesWins)
                Text(game.seriesLabel).font(.subheadline.weight(.semibold))
                    .foregroundStyle(.orange)
                seriesIndicator(wins: game.homeTeam.seriesWins)
            }
        }
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

// MARK: - Overview Tab

struct OverviewTab: View {
    var game: PlayoffGame
    var colorScheme: ColorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
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
                            Text(game.awayTeam.record).font(
                                .title2.weight(.bold)
                            )
                            Text("Record").font(.caption).foregroundStyle(
                                .secondary
                            )
                        }
                        .frame(maxWidth: .infinity)
                        Divider().frame(height: 60)
                        VStack(spacing: 4) {
                            Text(game.homeTeam.abbreviation)
                                .font(.title3.weight(.black))
                                .foregroundStyle(
                                    Color(hex: game.homeTeam.primaryColor)
                                )
                            Text(game.homeTeam.record).font(
                                .title2.weight(.bold)
                            )
                            Text("Record").font(.caption).foregroundStyle(
                                .secondary
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
                .cardSection(colorScheme: colorScheme)
                .padding(.horizontal)

                Spacer(minLength: 32)
            }
            .padding(.top, 16)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Box Score Tab

struct BoxScoreTab: View {
    var game: PlayoffGame
    var colorScheme: ColorScheme
    @Binding var selectedTeam: GameDetailView.TeamSide
    var activeBoxScore: TeamBoxScore
    var activeTeam: TeamScore

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if game.homeBoxScore.players.isEmpty {
                    ContentUnavailableView(
                        "No Box Score",
                        systemImage: "tablecells",
                        description: Text(
                            "Stats will appear once the game begins."
                        )
                    )
                    .padding(.top, 40)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Box Score").font(.headline)
                            Spacer()
                            Picker("Team", selection: $selectedTeam) {
                                Text(game.awayTeam.abbreviation).tag(
                                    GameDetailView.TeamSide.away
                                )
                                Text(game.homeTeam.abbreviation).tag(
                                    GameDetailView.TeamSide.home
                                )
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 130)
                        }
                        .padding()
                        Divider()
                        StatHeaderRow(
                            teamColor: Color(hex: activeTeam.primaryColor)
                        )
                        Divider()
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
            .padding(.top, 16)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Chat Tab
struct ChatTab: View {
    var game: PlayoffGame
    var colorScheme: ColorScheme
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = seedMessages

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { msg in
                            ChatBubble(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 16)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: messages.count) { _, _ in
                    if let last = messages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            HStack(spacing: 10) {
                TextField("Message…", text: $messageText, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Button {
                    send()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(
                            messageText.trimmingCharacters(in: .whitespaces)
                                .isEmpty ? .secondary : Color(hex: "#C8102E")
                        )
                }
                .disabled(
                    messageText.trimmingCharacters(in: .whitespaces).isEmpty
                )
                .sensoryFeedback(
                    .impact(weight: .light),
                    trigger: messages.count
                )
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemGroupedBackground))
        }
    }

    private func send() {
        let trimmed = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        messages.append(
            ChatMessage(
                author: "You",
                avatarColor: "#C8102E",
                text: trimmed,
                timeAgo: "Now",
                isMe: true
            )
        )
        messageText = ""
    }
}

struct ChatBubble: View {
    var message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isMe { Spacer(minLength: 48) }

            if !message.isMe {
                Circle()
                    .fill(Color(hex: message.avatarColor))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text(String(message.author.prefix(1)))
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                    )
            }

            VStack(alignment: message.isMe ? .trailing : .leading, spacing: 3) {
                if !message.isMe {
                    Text(message.author)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.leading, 4)
                }
                Text(message.text)
                    .font(.subheadline)
                    .foregroundStyle(message.isMe ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        message.isMe
                            ? Color(hex: "#C8102E")
                            : Color(.tertiarySystemGroupedBackground)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                Text(message.timeAgo)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 4)
            }

            if !message.isMe { Spacer(minLength: 48) }
        }
    }
}

let seedMessages: [ChatMessage] = [
    ChatMessage(
        author: "HoopHead22",
        avatarColor: "#007AC1",
        text: "SGA is LOCKED IN tonight 🔥",
        timeAgo: "8m ago",
        isMe: false
    ),
    ChatMessage(
        author: "CelticsNation",
        avatarColor: "#007A33",
        text: "Tatum needs to wake up in the 4th",
        timeAgo: "7m ago",
        isMe: false
    ),
    ChatMessage(
        author: "MavsFan4Life",
        avatarColor: "#00538C",
        text: "Luka's ankle looks fine to me honestly",
        timeAgo: "6m ago",
        isMe: false
    ),
    ChatMessage(
        author: "HoopHead22",
        avatarColor: "#007AC1",
        text: "38 points and we still talking about Luka?? 💀",
        timeAgo: "5m ago",
        isMe: false
    ),
    ChatMessage(
        author: "BballStats",
        avatarColor: "#6B3FA0",
        text: "OKC defense holding DAL to 38% FG in Q3",
        timeAgo: "4m ago",
        isMe: false
    ),
    ChatMessage(
        author: "CelticsNation",
        avatarColor: "#007A33",
        text: "This series is going 7 no doubt",
        timeAgo: "2m ago",
        isMe: false
    ),
]

// MARK: - Shared Subviews

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
            Text("PLAYER").frame(maxWidth: .infinity, alignment: .leading)
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
                    .font(.caption.weight(.semibold)).lineLimit(1)
                Text(stat.position).font(.caption2).foregroundStyle(.secondary)
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
                Text("\(stat.fgm)/\(stat.fga)").foregroundStyle(.secondary)
                    .frame(width: 44).padding(.trailing, 8)
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
            Text("TOTALS").font(.caption2.weight(.bold)).foregroundStyle(
                .secondary
            )
            .frame(maxWidth: .infinity, alignment: .leading).padding(
                .leading,
                16
            )
            Group {
                Text("—").frame(width: 36)
                Text("\(totPts)").foregroundStyle(teamColor).frame(width: 36)
                Text("\(totReb)").frame(width: 36)
                Text("\(totAst)").frame(width: 36)
                Text("\(totStl)").frame(width: 30)
                Text("\(totBlk)").frame(width: 30)
                Text("\(totTO)").frame(width: 30)
                Text("\(totFGM)/\(totFGA)").foregroundStyle(.secondary).frame(
                    width: 44
                ).padding(.trailing, 8)
            }
        }
        .font(.caption.weight(.semibold))
        .padding(.vertical, 10)
        .background(Color(.tertiarySystemGroupedBackground))
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
                Circle().fill(Color(hex: team.primaryColor).opacity(0.2)).frame(
                    width: 58,
                    height: 58
                )
                Text(team.abbreviation).font(.system(size: 16, weight: .black))
                    .foregroundStyle(Color(hex: team.primaryColor))
            }
            Text(
                team.name.components(separatedBy: " ").last ?? team.abbreviation
            )
            .font(.caption.weight(.semibold)).foregroundStyle(.secondary)
            Text(isHome ? "HOME" : "AWAY").font(.caption2.weight(.bold))
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
            Image(systemName: icon).foregroundStyle(.blue).frame(width: 24)
                .padding(.leading, 12)
            Text(label).font(.subheadline).foregroundStyle(.secondary)
            Spacer()
            Text(value).font(.subheadline.weight(.medium))
        }
        .padding(.vertical, 13)
        .padding(.trailing, 16)
    }
}

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

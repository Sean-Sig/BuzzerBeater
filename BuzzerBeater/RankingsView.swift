//
//  RankingsView.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/23/26.
//

import SwiftUI

struct RankingsView: View {
    var store: NBAStore
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.players) { player in
                        NavigationLink(
                            destination: PlayerDetailView(
                                player: player,
                                store: store
                            )
                        ) {
                            PlayerRow(player: player, store: store)
                        }
                        .buttonStyle(.plain)

                        if player.id != store.players.last?.id {
                            Divider().padding(.leading, 80)
                        }
                    }
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
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Player Rankings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct PlayerRow: View {
    var player: NBAPlayer
    var store: NBAStore
    @State private var bounce = false

    var body: some View {
        HStack(spacing: 14) {
            // Rank
            Text("\(player.rank)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .frame(width: 20, alignment: .center)

            // Avatar
            PlayerAvatar(player: player, size: 46)

            // Name & team
            VStack(alignment: .leading, spacing: 2) {
                Text(player.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                HStack(spacing: 4) {
                    Text(player.position.rawValue)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Color(hex: player.teamColor))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Text(player.team)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // PPG stat
            VStack(spacing: 1) {
                Text(String(format: "%.1f", player.ppg))
                    .font(.subheadline.weight(.bold))
                Text("PPG")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 36)

            // Follow button
            Button {
                bounce = true
                store.toggleFollow(player)
            } label: {
                Image(
                    systemName: store.isFollowing(player)
                        ? "checkmark.circle.fill" : "plus.circle"
                )
                .font(.title2)
                .foregroundStyle(store.isFollowing(player) ? .green : .blue)
                .symbolEffect(.bounce, value: bounce)
            }
            .buttonStyle(.plain)
            .padding(.leading, 4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

struct PlayerAvatar: View {
    var player: NBAPlayer
    var size: CGFloat

    var initials: String {
        let parts = player.name.components(separatedBy: " ")
        let first = parts.first?.first.map(String.init) ?? ""
        let last = parts.last?.first.map(String.init) ?? ""
        return first + last
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: player.teamColor),
                            Color(hex: player.teamColor).opacity(0.6),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
            Text(initials)
                .font(.system(size: size * 0.35, weight: .black))
                .foregroundStyle(.white)
        }
    }
}

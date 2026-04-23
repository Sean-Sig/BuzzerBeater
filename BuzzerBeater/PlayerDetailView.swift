//
//  PlayerDetailView.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/23/26.
//

import SwiftUI

struct PlayerDetailView: View {
    var player: NBAPlayer
    var store: NBAStore
    @Environment(\.colorScheme) var colorScheme
    @State private var bounce = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Hero card
                VStack(spacing: 16) {
                    PlayerAvatar(player: player, size: 90)

                    VStack(spacing: 4) {
                        Text(player.name)
                            .font(.title2.weight(.bold))
                        HStack(spacing: 6) {
                            Text(player.nationality)
                            Text(player.team)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("·")
                                .foregroundStyle(.secondary)
                            Text(player.position.rawValue)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color(hex: player.teamColor))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .font(.subheadline)
                    }

                    Button {
                        bounce = true
                        store.toggleFollow(player)
                    } label: {
                        Label(
                            store.isFollowing(player) ? "Following" : "Follow",
                            systemImage: store.isFollowing(player)
                                ? "checkmark.circle.fill" : "plus.circle.fill"
                        )
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(
                            store.isFollowing(player) ? .green : .white
                        )
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(
                            store.isFollowing(player)
                                ? Color.green.opacity(0.15)
                                : Color(hex: player.teamColor)
                        )
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .symbolEffect(.bounce, value: bounce)
                    .sensoryFeedback(.impact(weight: .medium), trigger: bounce)
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
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

                // Stats
                VStack(alignment: .leading, spacing: 0) {
                    Text("2024–25 Stats")
                        .font(.headline)
                        .padding()
                    Divider()
                    HStack(spacing: 0) {
                        StatCell(
                            value: String(format: "%.1f", player.ppg),
                            label: "PPG"
                        )
                        Divider().frame(height: 60)
                        StatCell(
                            value: String(format: "%.1f", player.rpg),
                            label: "RPG"
                        )
                        Divider().frame(height: 60)
                        StatCell(
                            value: String(format: "%.1f", player.apg),
                            label: "APG"
                        )
                    }
                    .padding(.vertical, 8)
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

                // Bio
                VStack(alignment: .leading, spacing: 12) {
                    Text("About")
                        .font(.headline)
                    Text(player.bio)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineSpacing(5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
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

                // Profile info
                VStack(spacing: 0) {
                    ProfileRow(
                        label: "Age",
                        value: "\(player.age)",
                        icon: "person.fill"
                    )
                    Divider().padding(.leading, 48)
                    ProfileRow(
                        label: "Height",
                        value: player.height,
                        icon: "ruler.fill"
                    )
                    Divider().padding(.leading, 48)
                    ProfileRow(
                        label: "Draft Year",
                        value: "\(player.draftYear)",
                        icon: "calendar"
                    )
                    Divider().padding(.leading, 48)
                    ProfileRow(
                        label: "College / Origin",
                        value: player.college,
                        icon: "graduationcap.fill"
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

                Spacer(minLength: 32)
            }
            .padding(.top, 12)
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(player.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatCell: View {
    var value: String
    var label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title.weight(.black).monospacedDigit())
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

struct ProfileRow: View {
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

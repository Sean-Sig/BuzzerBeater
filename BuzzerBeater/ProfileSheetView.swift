//
//  ProfileSheetView.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/24/26.
//

import SwiftUI

struct ProfileSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var showSettings = false
    @State private var showAbout = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // MARK: Profile Card
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "#C8102E"),
                                            Color(hex: "#1D428A"),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 64, height: 64)
                            Text("BB")
                                .font(.system(size: 22, weight: .black))
                                .foregroundStyle(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("BuzzerBeater Fan")
                                .font(.title3.weight(.bold))
                            Text("Member since April 2025")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
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

                    // MARK: Menu List
                    VStack(spacing: 0) {
                        Button {
                            showSettings = true
                        } label: {
                            MenuRow(
                                icon: "gearshape.fill",
                                label: "Settings",
                                iconColor: .gray
                            )
                        }
                        .buttonStyle(.plain)

                        Divider().padding(.leading, 52)

                        Button {
                            showAbout = true
                        } label: {
                            MenuRow(
                                icon: "info.circle.fill",
                                label: "About",
                                iconColor: Color(hex: "#1D428A")
                            )
                        }
                        .buttonStyle(.plain)
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
                }
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }
}

// MARK: - Menu Row

struct MenuRow: View {
    var icon: String
    var label: String
    var iconColor: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor)
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
            Text(label)
                .font(.body)
                .foregroundStyle(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var notificationsEnabled = true
    @State private var liveScoreAlerts = true
    @State private var favTeamAlerts = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 0) {
                        SettingsToggleRow(
                            icon: "bell.fill",
                            iconColor: .red,
                            label: "Notifications",
                            isOn: $notificationsEnabled
                        )
                        Divider().padding(.leading, 52)
                        SettingsToggleRow(
                            icon: "basketball.fill",
                            iconColor: Color(hex: "#C8102E"),
                            label: "Live Score Alerts",
                            isOn: $liveScoreAlerts
                        )
                        Divider().padding(.leading, 52)
                        SettingsToggleRow(
                            icon: "star.fill",
                            iconColor: .orange,
                            label: "Favorite Team Alerts",
                            isOn: $favTeamAlerts
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
                }
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

struct SettingsToggleRow: View {
    var icon: String
    var iconColor: Color
    var label: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor)
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
            Text(label)
                .font(.body)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

// MARK: - About View

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var showTerms = false
    @State private var showPrivacy = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // App identity
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "#C8102E"),
                                            Color(hex: "#1D428A"),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            Image(systemName: "basketball.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(.white)
                        }
                        Text("BuzzerBeater")
                            .font(.title2.weight(.bold))
                        Text("Version 1.0")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
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

                    VStack(spacing: 0) {
                        AboutRow(
                            icon: "basketball.fill",
                            iconColor: Color(hex: "#C8102E"),
                            label: "Live Scores",
                            value: "Real-time"
                        )
                        Divider().padding(.leading, 52)
                        AboutRow(
                            icon: "trophy.fill",
                            iconColor: .orange,
                            label: "Coverage",
                            value: "NBA Playoffs"
                        )
                        Divider().padding(.leading, 52)
                        AboutRow(
                            icon: "newspaper.fill",
                            iconColor: .blue,
                            label: "News",
                            value: "Daily updates"
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

                    // Legal
                    VStack(spacing: 0) {
                        Button {
                            showTerms = true
                        } label: {
                            MenuRow(
                                icon: "doc.text.fill",
                                label: "Terms & Conditions",
                                iconColor: .gray
                            )
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.leading, 52)
                        Button {
                            showPrivacy = true
                        } label: {
                            MenuRow(
                                icon: "hand.raised.fill",
                                label: "Privacy Policy",
                                iconColor: .green
                            )
                        }
                        .buttonStyle(.plain)
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
                }
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showTerms) {
                LegalView(title: "Terms & Conditions", content: termsContent)
            }
            .sheet(isPresented: $showPrivacy) {
                LegalView(title: "Privacy Policy", content: privacyContent)
            }
        }
    }
}

struct AboutRow: View {
    var icon: String
    var iconColor: Color
    var label: String
    var value: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor)
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }
            Text(label)
                .font(.body)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Legal View

struct LegalView: View {
    var title: String
    var content: [LegalSection]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(content) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.heading)
                                .font(.headline)
                            Text(section.body)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineSpacing(5)
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

struct LegalSection: Identifiable {
    var id = UUID()
    var heading: String
    var body: String
}

let termsContent: [LegalSection] = [
    LegalSection(
        heading: "Acceptance of Terms",
        body:
            "By downloading or using BuzzerBeater, you agree to be bound by these Terms & Conditions. If you do not agree to these terms, please do not use the app."
    ),
    LegalSection(
        heading: "Use of the App",
        body:
            "BuzzerBeater is intended for personal, non-commercial use. You may not reproduce, redistribute, or exploit any content from the app for commercial purposes without prior written consent."
    ),
    LegalSection(
        heading: "Content & Data",
        body:
            "All NBA scores, statistics, news, and related content are provided for informational purposes only. BuzzerBeater makes no guarantees regarding the accuracy, completeness, or timeliness of the data presented."
    ),
    LegalSection(
        heading: "Intellectual Property",
        body:
            "All app design, code, and original content are the property of BuzzerBeater. NBA team names, logos, and related marks are the property of the National Basketball Association and its member teams."
    ),
    LegalSection(
        heading: "Limitation of Liability",
        body:
            "BuzzerBeater is provided on an \"as is\" basis without warranties of any kind. We shall not be liable for any indirect, incidental, or consequential damages arising from your use of the app."
    ),
    LegalSection(
        heading: "Changes to Terms",
        body:
            "We reserve the right to update these Terms & Conditions at any time. Continued use of the app after changes constitutes acceptance of the revised terms."
    ),
    LegalSection(
        heading: "Contact",
        body:
            "For questions about these terms, please contact support@buzzerbeater.app."
    ),
]

let privacyContent: [LegalSection] = [
    LegalSection(
        heading: "Information We Collect",
        body:
            "BuzzerBeater does not collect personally identifiable information. The app may collect anonymous usage data such as feature interactions and crash reports to help improve the experience."
    ),
    LegalSection(
        heading: "Data Storage",
        body:
            "User preferences such as followed players and notification settings are stored locally on your device using iOS standard storage mechanisms. This data never leaves your device."
    ),
    LegalSection(
        heading: "Third-Party Services",
        body:
            "BuzzerBeater may use third-party analytics tools to understand app performance. These services may collect anonymized data in accordance with their own privacy policies."
    ),
    LegalSection(
        heading: "Notifications",
        body:
            "If you enable push notifications, we may send you alerts about live game scores and breaking news. You can disable notifications at any time in your device's Settings app."
    ),
    LegalSection(
        heading: "Children's Privacy",
        body:
            "BuzzerBeater is not directed at children under the age of 13. We do not knowingly collect personal information from children."
    ),
    LegalSection(
        heading: "Your Rights",
        body:
            "You have the right to opt out of any data collection at any time by adjusting your settings within the app or on your device. You may also delete the app to remove all locally stored data."
    ),
    LegalSection(
        heading: "Changes to This Policy",
        body:
            "We may update this Privacy Policy periodically. We will notify you of significant changes through an in-app notice. Your continued use of the app constitutes acceptance of the updated policy."
    ),
    LegalSection(
        heading: "Contact",
        body:
            "If you have any questions or concerns about our privacy practices, please reach out at privacy@buzzerbeater.app."
    ),
]

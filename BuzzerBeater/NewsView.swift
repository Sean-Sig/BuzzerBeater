//
//  NewsView.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/24/26.
//

import SwiftUI

struct NewsView: View {
    var store: NBAStore
    @State private var selectedCategory: NewsCategory = .all
    @Environment(\.colorScheme) var colorScheme

    var filtered: [NewsArticle] {
        selectedCategory == .all
            ? store.articles
            : store.articles.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Category filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(NewsCategory.allCases, id: \.self) { cat in
                                CategoryChip(
                                    label: cat.rawValue,
                                    isSelected: selectedCategory == cat
                                ) {
                                    withAnimation(.snappy) {
                                        selectedCategory = cat
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }

                    // Featured article (first in list)
                    if let featured = filtered.first {
                        NavigationLink(
                            destination: ArticleDetailView(article: featured)
                        ) {
                            FeaturedArticleCard(article: featured)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }

                    // Remaining articles
                    VStack(spacing: 0) {
                        ForEach(filtered.dropFirst()) { article in
                            NavigationLink(
                                destination: ArticleDetailView(article: article)
                            ) {
                                ArticleRow(article: article)
                            }
                            .buttonStyle(.plain)

                            if article.id != filtered.last?.id {
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
                    .padding(.horizontal)

                    Spacer(minLength: 32)
                }
                .padding(.top, 4)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("NBA News")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    var label: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected
                        ? Color(hex: "#C8102E")
                        : Color(.secondarySystemGroupedBackground)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Featured Card

struct FeaturedArticleCard: View {
    var article: NewsArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image area
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: article.accentColor),
                                Color(hex: article.accentColor).opacity(0.6),
                                Color(hex: "#0A1628"),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)

                // Pattern overlay
                HStack(spacing: 0) {
                    ForEach(0..<6, id: \.self) { _ in
                        Image(systemName: article.symbolName)
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.06))
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 200)
                .clipped()

                // Large icon
                Image(systemName: article.symbolName)
                    .font(.system(size: 72))
                    .foregroundStyle(.white.opacity(0.18))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 24)
                    .padding(.bottom, 16)

                VStack(alignment: .leading, spacing: 6) {
                    CategoryTag(category: article.category)
                    Text(article.headline)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .shadow(color: .black.opacity(0.4), radius: 4)
                }
                .padding(16)
            }
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 16,
                    topTrailingRadius: 16
                )
            )

            // Footer
            HStack {
                Text(article.source)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color(hex: article.accentColor))
                Spacer()
                Text(article.timeAgo)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(
                UnevenRoundedRectangle(
                    bottomLeadingRadius: 16,
                    bottomTrailingRadius: 16
                )
            )
        }
        .shadow(
            color: Color(hex: article.accentColor).opacity(0.25),
            radius: 16,
            y: 6
        )
    }
}

// MARK: - Article Row

struct ArticleRow: View {
    var article: NewsArticle

    var body: some View {
        HStack(spacing: 14) {
            // Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: article.accentColor),
                                Color(hex: article.accentColor).opacity(0.6),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                Image(systemName: article.symbolName)
                    .font(.system(size: 26))
                    .foregroundStyle(.white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    CategoryTag(category: article.category)
                    Spacer()
                    Text(article.timeAgo)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                Text(article.headline)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                    .foregroundStyle(.primary)
                Text(article.source)
                    .font(.caption)
                    .foregroundStyle(Color(hex: article.accentColor))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

// MARK: - Category Tag

struct CategoryTag: View {
    var category: NewsCategory

    var color: Color {
        switch category {
        case .playoffs: return .orange
        case .trades: return .purple
        case .injury: return .red
        case .analysis: return .blue
        case .all: return .gray
        }
    }

    var body: some View {
        Text(category.rawValue.uppercased())
            .font(.caption2.weight(.bold))
            .foregroundStyle(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// MARK: - Article Detail

struct ArticleDetailView: View {
    var article: NewsArticle
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Hero image
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: article.accentColor),
                                    Color(hex: article.accentColor).opacity(
                                        0.5
                                    ),
                                    Color(hex: "#050D1A"),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 220)

                    Image(systemName: article.symbolName)
                        .font(.system(size: 100))
                        .foregroundStyle(.white.opacity(0.12))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        CategoryTag(category: article.category)
                        Text(article.headline)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.5), radius: 6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)
                .padding(.top, 12)

                // Meta bar
                HStack {
                    Label(article.source, systemImage: "newspaper.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color(hex: article.accentColor))
                    Spacer()
                    Label(article.timeAgo, systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)

                Divider()
                    .padding(.horizontal, 16)

                // Body
                Text(article.summary)
                    .font(.body)
                    .lineSpacing(7)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                // Extended section
                VStack(alignment: .leading, spacing: 12) {
                    Text("What This Means Going Forward")
                        .font(.headline)
                        .padding(.top, 8)
                    Text(
                        "The implications of tonight's game extend well beyond this series. With the conference semifinals approaching, teams will need to evaluate their rotations and manage player minutes carefully in a compressed playoff schedule. Coaching adjustments at halftime proved decisive, and the ability to make in-game adaptations will continue to separate contenders from pretenders."
                    )
                    .font(.body)
                    .lineSpacing(7)
                    .foregroundStyle(.secondary)

                    Text(
                        "The matchup has exposed certain defensive vulnerabilities that opposing coaches will look to exploit in future rounds. Ball movement, transition defense, and rebounding margins remain the three pillars that analytics departments across the league continue to emphasize as the strongest predictors of playoff success."
                    )
                    .font(.body)
                    .lineSpacing(7)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(article.source)
        .navigationBarTitleDisplayMode(.inline)
    }
}

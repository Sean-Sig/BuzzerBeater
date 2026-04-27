//
//  NotificationsView.swift
//  BuzzerBeater
//
//  Created by Sean Siggard on 4/27/26.
//

import SwiftUI

struct NotificationsView: View {
  var store: NBAStore
  @Environment(\.dismiss) var dismiss
  @Environment(\.colorScheme) var colorScheme

  var unread: [AppNotification] { store.notifications.filter { !$0.isRead } }
  var read: [AppNotification]   { store.notifications.filter {  $0.isRead } }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 20) {

          if store.notifications.isEmpty {
            ContentUnavailableView(
              "No Notifications",
              systemImage: "bell.slash.fill",
              description: Text("You're all caught up.")
            )
            .padding(.top, 60)
          } else {

            // Unread
            if !unread.isEmpty {
              VStack(alignment: .leading, spacing: 0) {
                SectionLabel2(title: "NEW")
                ForEach(unread) { n in
                  NotificationRow(notification: n)
                    .onTapGesture { store.markRead(n) }
                  if n.id != unread.last?.id {
                    Divider().padding(.leading, 62)
                  }
                }
              }
              .background(Color(.secondarySystemGroupedBackground))
              .clipShape(RoundedRectangle(cornerRadius: 16))
              .overlay(
                RoundedRectangle(cornerRadius: 16)
                  .strokeBorder(Color.white.opacity(colorScheme == .dark ? 0.07 : 0), lineWidth: 1)
              )
              .shadow(
                color: colorScheme == .dark ? .black.opacity(0.4) : .black.opacity(0.07),
                radius: colorScheme == .dark ? 10 : 6, y: 2
              )
              .padding(.horizontal)
            }

            // Read / Earlier
            if !read.isEmpty {
              VStack(alignment: .leading, spacing: 0) {
                SectionLabel2(title: "EARLIER")
                ForEach(read) { n in
                  NotificationRow(notification: n)
                  if n.id != read.last?.id {
                    Divider().padding(.leading, 62)
                  }
                }
              }
              .background(Color(.secondarySystemGroupedBackground))
              .clipShape(RoundedRectangle(cornerRadius: 16))
              .overlay(
                RoundedRectangle(cornerRadius: 16)
                  .strokeBorder(Color.white.opacity(colorScheme == .dark ? 0.07 : 0), lineWidth: 1)
              )
              .shadow(
                color: colorScheme == .dark ? .black.opacity(0.4) : .black.opacity(0.07),
                radius: colorScheme == .dark ? 10 : 6, y: 2
              )
              .padding(.horizontal)
            }
          }

          Spacer(minLength: 32)
        }
        .padding(.top, 8)
      }
      .background(Color(.systemGroupedBackground))
      .navigationTitle("Notifications")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          if store.unreadCount > 0 {
            Button("Mark All Read") {
              withAnimation { store.markAllRead() }
            }
            .font(.subheadline)
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") { dismiss() }
            .fontWeight(.semibold)
        }
      }
    }
  }
}

struct SectionLabel2: View {
  var title: String
  var body: some View {
    Text(title)
      .font(.caption2.weight(.bold))
      .foregroundStyle(.secondary)
      .padding(.horizontal, 16)
      .padding(.vertical, 7)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color(.tertiarySystemGroupedBackground))
  }
}

struct NotificationRow: View {
  var notification: AppNotification

  var iconName: String {
    switch notification.kind {
    case .liveGame:      return "basketball.fill"
    case .injury:        return "cross.circle.fill"
    case .trade:         return "arrow.left.arrow.right"
    case .news:          return "newspaper.fill"
    case .followedPlayer: return "person.fill"
    }
  }

  var iconColor: Color {
    switch notification.kind {
    case .liveGame:       return .red
    case .injury:         return .orange
    case .trade:          return .purple
    case .news:           return .blue
    case .followedPlayer: return .green
    }
  }

  var body: some View {
    HStack(alignment: .top, spacing: 14) {
      ZStack {
        Circle()
          .fill(iconColor.opacity(notification.isRead ? 0.12 : 0.2))
          .frame(width: 38, height: 38)
        Image(systemName: iconName)
          .font(.system(size: 16, weight: .semibold))
          .foregroundStyle(iconColor.opacity(notification.isRead ? 0.5 : 1))
      }

      VStack(alignment: .leading, spacing: 3) {
        HStack(alignment: .firstTextBaseline) {
          Text(notification.title)
            .font(.subheadline.weight(notification.isRead ? .regular : .semibold))
            .foregroundStyle(notification.isRead ? .secondary : .primary)
          Spacer()
          Text(notification.timeAgo)
            .font(.caption2)
            .foregroundStyle(.tertiary)
        }
        Text(notification.body)
          .font(.caption)
          .foregroundStyle(.secondary)
          .lineLimit(2)
          .fixedSize(horizontal: false, vertical: true)
      }

      if !notification.isRead {
        Circle()
          .fill(.blue)
          .frame(width: 8, height: 8)
          .padding(.top, 5)
      }
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 12)
    .contentShape(Rectangle())
  }
}

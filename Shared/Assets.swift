//
//  Assets.swift
//  NekoPlayer
//
//  Asset catalog and resource management
//

import SwiftUI

// MARK: - Color Scheme

extension Color {
    /// NekoPlayer primary color (Pink)
    static let nekoPrimary = Color(red: 1.0, green: 0.6, blue: 0.8)

    /// NekoPlayer secondary color (Purple)
    static let nekoSecondary = Color(red: 0.6, green: 0.4, blue: 0.9)

    /// NekoPlayer accent color (Mint)
    static let nekoAccent = Color(red: 0.3, green: 0.9, blue: 0.7)

    /// Background color
    static let nekoBackground = Color(red: 0.95, green: 0.95, blue: 0.98)

    /// Card background color
    static let nekoCardBackground = Color.white

    /// Text color
    static let nekoText = Color(red: 0.2, green: 0.2, blue: 0.25)

    /// Text secondary color
    static let nekoTextSecondary = Color(red: 0.5, green: 0.5, blue: 0.55)

    /// Success color
    static let nekoSuccess = Color(red: 0.3, green: 0.8, blue: 0.5)

    /// Error color
    static let nekoError = Color(red: 0.9, green: 0.3, blue: 0.3)

    /// Warning color
    static let nekoWarning = Color(red: 1.0, green: 0.7, blue: 0.2)
}

// MARK: - Gradient

extension LinearGradient {
    /// NekoPlayer primary gradient
    static let nekoPrimaryGradient = LinearGradient(
        colors: [.nekoPrimary, .nekoSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// NekoPlayer accent gradient
    static let nekoAccentGradient = LinearGradient(
        colors: [.nekoAccent, .nekoSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - SF Symbols

enum NekoIcon: String {
    // Tab Bar
    case folder = "folder.fill"
    case play = "play.fill"
    case settings = "gearshape.fill"

    // Controls
    case pause = "pause.fill"
    case skipBack = "gobackward.15"
    case skipForward = "goforward.15"
    case volume = "speaker.wave.3.fill"
    case volumeMute = "speaker.slash.fill"
    case fullscreen = "arrow.up.left.and.arrow.down.right"
    case pip = "pip"

    // Files
    case file = "doc.fill"
    case video = "video.fill"
    case audio = "waveform"
    case subtitle = "captions.bubble.fill"

    // Network
    case wifi = "wifi"
    case server = "server.rack"
    case cloud = "icloud.fill"
    case webdav = "link"

    // Anime4K
    case sparkle = "sparkles"
    case enhance = "wand.and.stars"

    // UI
    case search = "magnifyingglass"
    case add = "plus.circle.fill"
    case remove = "minus.circle.fill"
    case edit = "pencil.circle.fill"
    case delete = "trash.circle.fill"
    case checkmark = "checkmark.circle.fill"
    case close = "xmark.circle.fill"
    case info = "info.circle.fill"
    case warning = "exclamationmark.triangle.fill"
    case error = "xmark.octagon.fill"
    case success = "checkmark.seal.fill"

    var image: Image {
        Image(systemName: rawValue)
    }
}

// MARK: - Emoji

enum NekoEmoji: String {
    case cat = "🐱"
    case play = "▶️"
    case pause = "⏸️"
    case stop = "⏹️"
    case forward = "⏩"
    case backward = "⏪"
    case sparkle = "✨"
    case star = "⭐"
    case heart = "❤️"
    case fire = "🔥"
    case cloud = "☁️"
    case wifi = "📶"
    case success = "✅"
    case error = "❌"
    case warning = "⚠️"
    case info = "ℹ️"
    case settings = "⚙️"
    case file = "📁"
    case video = "🎬"
    case music = "🎵"
    case tv = "📺"

    var text: Text {
        Text(rawValue)
    }
}

// MARK: - Typography

struct NekoTypography {
    // Headings
    static let largeTitle = Font.system(size: 34, weight: .bold)
    static let title1 = Font.system(size: 28, weight: .bold)
    static let title2 = Font.system(size: 22, weight: .bold)
    static let title3 = Font.system(size: 20, weight: .semibold)

    // Body
    static let headline = Font.system(size: 17, weight: .semibold)
    static let body = Font.system(size: 17, weight: .regular)
    static let callout = Font.system(size: 16, weight: .regular)
    static let subheadline = Font.system(size: 15, weight: .regular)
    static let footnote = Font.system(size: 13, weight: .regular)

    // Special
    static let caption1 = Font.system(size: 12, weight: .regular)
    static let caption2 = Font.system(size: 11, weight: .regular)
}

// MARK: - Spacing

struct NekoSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - Corner Radius

struct NekoCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
}

// MARK: - Shadows

struct NekoShadow {
    static let small = Shadow(
        color: Color.black.opacity(0.1),
        radius: 4,
        x: 0,
        y: 2
    )

    static let medium = Shadow(
        color: Color.black.opacity(0.15),
        radius: 8,
        x: 0,
        y: 4
    )

    static let large = Shadow(
        color: Color.black.opacity(0.2),
        radius: 16,
        x: 0,
        y: 8
    )

    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}

// MARK: - Animation

struct NekoAnimation {
    static let fast = Animation.easeInOut(duration: 0.2)
    static let normal = Animation.easeInOut(duration: 0.3)
    static let slow = Animation.easeInOut(duration: 0.5)
    static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.5)
}

// MARK: - View Modifiers

extension View {
    /// Apply Neko card style
    func nekoCard() -> some View {
        self
            .background(Color.nekoCardBackground)
            .cornerRadius(NekoCornerRadius.large)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    /// Apply Neko button style
    func nekoButton() -> some View {
        self
            .padding(.horizontal, NekoSpacing.xl)
            .padding(.vertical, NekoSpacing.lg)
            .background(
                LinearGradient.nekoPrimaryGradient
            )
            .foregroundColor(.white)
            .cornerRadius(NekoCornerRadius.medium)
            .shadow(color: Color.nekoPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
    }

    /// Apply Neko secondary button style
    func nekoSecondaryButton() -> some View {
        self
            .padding(.horizontal, NekoSpacing.xl)
            .padding(.vertical, NekoSpacing.lg)
            .background(Color.nekoCardBackground)
            .foregroundColor(.nekoPrimary)
            .cornerRadius(NekoCornerRadius.medium)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    /// Apply Neko input field style
    func nekoInputField() -> some View {
        self
            .padding(.horizontal, NekoSpacing.lg)
            .padding(.vertical, NekoSpacing.md)
            .background(Color.nekoBackground)
            .cornerRadius(NekoCornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: NekoCornerRadius.medium)
                    .stroke(Color.nekoTextSecondary.opacity(0.3), lineWidth: 1)
            )
    }
}

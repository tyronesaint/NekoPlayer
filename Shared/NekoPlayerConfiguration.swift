//
//  NekoPlayerConfiguration.swift
//  NekoPlayer
//
//  App configuration and constants
//

import Foundation

// MARK: - App Information

struct AppInfo {
    static let name = "NekoPlayer"
    static let version = "1.0.0"
    static let buildNumber = "1"
    static let bundleIdentifier = "com.nekoplayer.app"
    static let copyright = "© 2024 NekoPlayer Contributors"

    static let gitHubURL = "https://github.com/your-username/NekoPlayer"
    static let issueTrackerURL = "\(gitHubURL)/issues"
    static let documentationURL = "\(gitHubURL)/blob/main/README.md"

    static let supportEmail = "support@nekoplayer.app"
}

// MARK: - Platform Requirements

struct PlatformRequirements {
    static let minIOSVersion = "15.0"
    static let minMacOSVersion = "12.0"
    static let minTVOSVersion = "15.0"

    static let recommendedIOSVersion = "16.0"
    static let recommendedMacOSVersion = "13.0"
    static let recommendedTVOSVersion = "16.0"
}

// MARK: - Video Support

struct VideoSupport {
    /// Supported video formats
    static let supportedFormats = [
        "mp4", "mov", "m4v", "avi", "mkv", "webm", "flv", "wmv"
    ]

    /// Supported video codecs
    static let supportedCodecs = [
        "h264", "h265", "hevc", "vp8", "vp9", "av1"
    ]

    /// Supported resolutions
    static let supportedResolutions = [
        "360p", "480p", "720p", "1080p", "1440p", "2160p"
    ]

    /// Maximum resolution for Anime4K
    static let maxAnime4KResolution = "2160p"

    /// Recommended resolution for best Anime4K performance
    static let recommendedAnime4KResolution = "1080p"
}

// MARK: - Anime4K Settings

struct Anime4KSettings {
    /// Default Anime4K mode
    static let defaultMode = Anime4KMode.modeB

    /// Anime4K modes with descriptions
    static let modes: [Anime4KMode: String] = [
        .modeA: "Standard - Balanced enhancement for most anime",
        .modeB: "Bilibili - Enhanced line restoration",
        .modeC: "Average - Best for compressed sources",
        .modeD: "Strength - Maximum enhancement for low quality",
        .fast: "Fast - Real-time playback optimization"
    ]

    /// Default intensity (0.0 - 1.0)
    static let defaultIntensity: Float = 0.7

    /// Maximum intensity
    static let maxIntensity: Float = 1.0

    /// Minimum intensity
    static let minIntensity: Float = 0.1

    /// Performance profiles
    enum PerformanceProfile {
        case balanced
        case quality
        case performance

        var name: String {
            switch self {
            case .balanced: return "Balanced"
            case .quality: return "Quality"
            case .performance: return "Performance"
            }
        }
    }
}

// MARK: - WebDAV Settings

struct WebDAVSettings {
    /// Default timeout in seconds
    static let defaultTimeout: TimeInterval = 30

    /// Maximum timeout in seconds
    static let maxTimeout: TimeInterval = 120

    /// Buffer size for streaming (in MB)
    static let defaultBufferSize: Int = 10

    /// Maximum buffer size (in MB)
    static let maxBufferSize: Int = 50

    /// Retry count for failed connections
    static let defaultRetryCount: Int = 3

    /// Connection pool size
    static let connectionPoolSize: Int = 5

    /// User agent string
    static let userAgent = "NekoPlayer/\(AppInfo.version)"
}

// MARK: - Playback Settings

struct PlaybackSettings {
    /// Default playback speed
    static let defaultPlaybackSpeed: Float = 1.0

    /// Supported playback speeds
    static let supportedPlaybackSpeeds: [Float] = [
        0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0
    ]

    /// Default seek interval in seconds
    static let defaultSeekInterval: TimeInterval = 10

    /// Auto-play next video
    static let autoPlayNext = true

    /// Loop playback
    static let loopPlayback = false

    /// Shuffle playback
    static let shufflePlayback = false

    /// Remember playback position
    static let rememberPosition = true
}

// MARK: - UI Settings

struct UISettings {
    /// Default theme
    static let defaultTheme = AppTheme.light

    /// Supported themes
    static let supportedThemes: [AppTheme] = [
        .light,
        .dark,
        .automatic
    ]

    /// Default language
    static let defaultLanguage = "en"

    /// Supported languages
    static let supportedLanguages = [
        "en": "English",
        "zh-Hans": "简体中文",
        "zh-Hant": "繁體中文",
        "ja": "日本語",
        "ko": "한국어"
    ]
}

// MARK: - Storage Settings

struct StorageSettings {
    /// Maximum cache size (in GB)
    static let maxCacheSize: Int = 10

    /// Default cache directory
    static let cacheDirectory = "NekoPlayerCache"

    /// Temp directory
    static let tempDirectory = "NekoPlayerTemp"

    /// Logs directory
    static let logsDirectory = "NekoPlayerLogs"
}

// MARK: - Network Settings

struct NetworkSettings {
    /// Enable network monitoring
    static let enableNetworkMonitoring = true

    /// Network timeout check interval (in seconds)
    static let networkCheckInterval: TimeInterval = 5

    /// Minimum required bandwidth for streaming (in Mbps)
    static let minBandwidthForStreaming: Double = 5.0

    /// Adaptive streaming enabled
    static let adaptiveStreamingEnabled = true
}

// MARK: - Feature Flags

struct FeatureFlags {
    /// Enable Anime4K
    static let anime4KEnabled = true

    /// Enable WebDAV
    static let webDAVEnabled = true

    /// Enable subtitles
    static let subtitlesEnabled = true

    /// Enable picture-in-picture
    static let pipEnabled = true

    /// Enable AirPlay
    static let airPlayEnabled = true

    /// Enable background playback
    static let backgroundPlaybackEnabled = true

    /// Enable screenshots
    static let screenshotsEnabled = true

    /// Enable recordings
    static let recordingsEnabled = false // Planned for future

    /// Enable playlists
    static let playlistsEnabled = true

    /// Enable favorites
    static let favoritesEnabled = true

    /// Enable history
    static let historyEnabled = true
}

// MARK: - Debug Settings

struct DebugSettings {
    /// Enable debug logging
    #if DEBUG
    static let debugLoggingEnabled = true
    #else
    static let debugLoggingEnabled = false
    #endif

    /// Enable performance profiling
    #if DEBUG
    static let performanceProfilingEnabled = true
    #else
    static let performanceProfilingEnabled = false
    #endif

    /// Enable network debugging
    #if DEBUG
    static let networkDebuggingEnabled = true
    #else
    static let networkDebuggingEnabled = false
    #endif

    /// Log level
    enum LogLevel: Int {
        case none = 0
        case error = 1
        case warning = 2
        case info = 3
        case debug = 4
        case verbose = 5
    }

    static let currentLogLevel: LogLevel = {
        #if DEBUG
        return .debug
        #else
        return .error
        #endif
    }()
}

// MARK: - App Theme

enum AppTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case automatic = "automatic"

    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .automatic: return "Automatic"
        }
    }
}

// MARK: - Anime4K Mode

enum Anime4KMode: String, CaseIterable {
    case modeA = "Mode A"
    case modeB = "Mode B"
    case modeC = "Mode C"
    case modeD = "Mode D"
    case fast = "Fast"

    var displayName: String {
        return rawValue
    }

    var shaderName: String {
        switch self {
        case .modeA: return "Anime4K_3DNN_VL_ModeA"
        case .modeB: return "Anime4K_3DNN_VL_ModeB"
        case .modeC: return "Anime4K_3DNN_VL_ModeC"
        case .modeD: return "Anime4K_3DNN_VL_ModeD"
        case .fast: return "Anime4K_Fast"
        }
    }
}

// MARK: - Constants

struct Constants {
    static let appGroup = "group.com.nekoplayer.app"
    static let keychainService = "com.nekoplayer.keychain"
    static let userDefaultsSuite = "com.nekoplayer.preferences"
}

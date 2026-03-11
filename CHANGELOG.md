# Changelog

All notable changes to NekoPlayer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned Features
- [ ] Play history and resume playback
- [ ] Custom keyboard shortcuts
- [ ] Dark mode support
- [ ] Picture-in-Picture mode
- [ ] AirPlay support
- [ ] Cloud storage integration (Google Drive, Dropbox)
- [ ] Subtitle synchronization
- [ ] Video rotation and mirroring
- [ ] Network speed indicator
- [ ] Batch download from WebDAV

## [1.0.0] - 2024-01-XX

### Added
- Initial release of NekoPlayer
- Anime4K Metal shader support with 5 enhancement modes (A/B/C/D/Fast)
- WebDAV integration for remote file access
- Multi-platform support (iOS 15.0+, macOS 12.0+, tvOS 15.0+)
- Neko-themed UI design
- Video playback controls (play/pause, seek, volume)
- File browser with local and WebDAV support
- Settings panel for customization
- Anime4K mode selection and intensity adjustment
- WebDAV server management
- GitHub Actions CI/CD pipeline
- Comprehensive documentation (README, USAGE_GUIDE, DEVELOPER.md)
- GitHub setup script

### Features
- **Anime4K Enhancement**
  - Mode A: Standard Anime4K mode
  - Mode B: AA-Mode + Bilibili
  - Mode C: A-Average + Bilibili
  - Mode D: Strength mode for low quality sources
  - Fast mode for real-time playback

- **WebDAV Support**
  - Multiple server management
  - Username/password authentication
  - Directory browsing
  - File streaming
  - Support for popular WebDAV services (Synology, Nextcloud, ownCloud)

- **Video Playback**
  - MP4, MOV, M4V, AVI, MKV support
  - Hardware accelerated decoding
  - Metal-based rendering
  - Smooth playback with low latency

- **User Interface**
  - Three-tab navigation (Files, Player, Settings)
  - Intuitive controls
  - Dark theme (planned for future release)
  - Responsive design

### Technical Details
- Built with Swift 5.9+ and Xcode 15.0+
- Uses Metal framework for GPU-accelerated rendering
- Anime4K shaders converted from GLSL to Metal
- Supports iPhone, iPad, Mac, and Apple TV
- Minimum iOS version: 15.0
- Minimum macOS version: 12.0
- Minimum tvOS version: 15.0

### Known Issues
- WebDAV streaming may have initial buffering on slow networks
- Anime4K Fast mode may reduce quality on low-end devices
- Some video codecs may not be fully supported
- Subtitle support is limited to SRT format

### Dependencies
- Anime4K (Git Submodule)
- Metal Framework
- AVFoundation
- Swift Standard Library

## [0.9.0-beta] - 2024-01-XX

### Added
- Beta release with core features
- Basic video playback
- Anime4K Mode A implementation
- WebDAV file browsing
- Initial UI design

## Future Roadmap

### Version 1.1.0
- Play history and resume playback
- Custom keyboard shortcuts (macOS)
- Dark mode support
- Picture-in-Picture mode (iOS)

### Version 1.2.0
- AirPlay support
- Subtitle synchronization
- Video rotation and mirroring
- Network speed indicator

### Version 2.0.0
- Cloud storage integration (Google Drive, Dropbox, OneDrive)
- Advanced subtitle support (ASS, SSA, VTT)
- Video library management
- Playlist sharing
- Multi-language support

---

## Version Format

NekoPlayer follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html):
- **MAJOR**: Incompatible API changes
- **MINOR**: Backwards-compatible functionality additions
- **PATCH**: Backwards-compatible bug fixes

### Pre-release Tags
- **alpha**: Early development, may contain bugs
- **beta**: Feature-complete, testing phase
- **rc**: Release candidate, stable features

---

## Contributing

See [DEVELOPER.md](DEVELOPER.md) for contribution guidelines.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

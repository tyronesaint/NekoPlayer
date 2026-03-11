<div align="center">

# 🐱 NekoPlayer

**基于 Anime4K 的跨平台视频播放器**

[![Swift](https://img.shields.io/badge/Swift-5.9-orange)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-15.0-blue)](https://developer.apple.com/xcode)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS%20%7C%20tvOS-lightgrey)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue)](LICENSE)
[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/your-username/NekoPlayer/build.yml)](https://github.com/your-username/NekoPlayer/actions)

</div>

---

## ✨ 简介

**NekoPlayer** 是一款基于 **Anime4K** 技术的跨平台视频播放器，专为动漫爱好者打造。通过 Metal GPU 加速的 Anime4K 着色器，让您的低分辨率动漫视频呈现高清画质。

### 🎯 核心特性

- **🎨 Anime4K 增强**: 5 种增强模式（A/B/C/D/Fast），实时提升视频画质
- **🌐 WebDAV 支持**: 支持远程文件访问，兼容 Synology、Nextcloud、ownCloud
- **📱 多平台**: 统一代码库，支持 iOS、macOS、tvOS
- **⚙️ 性能优化**: Metal GPU 加速，流畅播放不卡顿
- **🐱 可爱主题**: 粉紫色调的 Neko 主题设计
- **🎬 完整控制**: 播放、暂停、快进、快退、音量调节等

---

## 📸 预览

### 主界面

*三标签导航设计，简洁优雅*

- **文件**: 浏览本地和 WebDAV 文件
- **播放**: 视频播放和控制
- **设置**: 个性化配置

### Anime4K 效果对比

| 原始画质 (720p) | Anime4K 增强后 |
|----------------|---------------|
| ![Original](docs/images/original.png) | ![Enhanced](docs/images/enhanced.png) |

---

## 🚀 快速开始

### 前置要求

- **macOS**: 14.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+

### 安装步骤

#### 方法 1: 使用快速开始脚本（推荐）

```bash
# 克隆仓库
git clone https://github.com/your-username/NekoPlayer.git
cd NekoPlayer

# 初始化子模块
git submodule update --init --recursive

# 运行快速开始脚本
bash quick_start.sh
```

#### 方法 2: 手动构建

```bash
# 1. 克隆仓库
git clone https://github.com/your-username/NekoPlayer.git
cd NekoPlayer

# 2. 初始化子模块
git submodule update --init --recursive

# 3. 打开 Xcode 项目
open NekoPlayer.xcodeproj

# 4. 选择目标设备并运行
#    - iOS: iPhone 15 模拟器
#    - macOS: My Mac
#    - tvOS: Apple TV 模拟器
```

### 命令行构建

#### 方法 1：使用自适应构建脚本（推荐）

```bash
# 自动检测并使用最佳模拟器
bash scripts/build_ios.sh
```

脚本会自动：
- ✅ 检测当前环境可用的模拟器
- ✅ 选择最佳模拟器（优先 iPhone 16 → 15 → 14）
- ✅ 自动适配 iOS 版本
- ✅ 执行构建

#### 方法 2：手动指定模拟器

```bash
# Debug 构建
xcodebuild -project NekoPlayer.xcodeproj \
  -scheme "NekoPlayer (iOS)" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  clean build

# Release 构建
xcodebuild -project NekoPlayer.xcodeproj \
  -scheme "NekoPlayer (iOS)" \
  -configuration Release \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  clean build
```

> 💡 **提示**：手动构建前可以使用 `xcrun simctl list devices available iOS | grep iPhone` 查看可用的模拟器。

#### GitHub Actions 自动构建

推送到 GitHub 后，会自动触发构建：

```bash
git push origin main
```

构建系统会自动选择最佳的模拟器，无需手动配置。

详细信息请查看 [BUILD_SYSTEM.md](BUILD_SYSTEM.md)。

---

## 🔧 自适应构建系统

NekoPlayer 采用智能模拟器选择机制，能够自动适应不同的 Xcode 版本和运行环境：

### 特性

✅ **智能模拟器选择**：根据优先级自动选择最佳模拟器
✅ **跨版本兼容**：支持 iOS 15.0+ 和 tvOS 15.0+
✅ **自适应环境**：适应不同的 Xcode 版本和 GitHub Actions runner
✅ **零维护成本**：无需手动更新模拟器配置

### 工作原理

构建系统会按优先级选择模拟器：

1. **设备优先级**：iPhone 16 → 15 → 14 → 13 → SE
2. **iOS 版本优先级**：18.0 → 17.x → 16.x → 15.x
3. **自动回退**：如果优先级设备不可用，使用第一个可用设备

### 使用方法

```bash
# 本地构建（自动选择模拟器）
bash scripts/build_ios.sh

# 测试模拟器选择逻辑
bash scripts/test_simulators.sh

# GitHub Actions（推送后自动触发）
git push origin main
```

详细文档请查看 [BUILD_SYSTEM.md](BUILD_SYSTEM.md)。

---

## 📖 使用指南

### Anime4K 模式

| 模式 | 描述 | 适用场景 |
|------|------|----------|
| **Mode A** | 标准 Anime4K | 大多数动漫 |
| **Mode B** | AA-Mode + Bilibili | 新番，线条恢复 |
| **Mode C** | A-Average + Bilibili | 高压缩源 |
| **Mode D** | Strength 模式 | 低质量源 |
| **Fast** | 快速模式 | 实时播放 |

### WebDAV 配置

1. 进入"设置" → "WebDAV 服务器"
2. 点击"添加服务器"
3. 填写服务器信息：
   - **名称**: 服务器昵称
   - **URL**: WebDAV 服务器地址
   - **用户名**: 可选
   - **密码**: 可选

#### 示例配置

**Synology NAS:**
```
URL: https://your-nas-ip:5006/webdav/
用户名: your-username
密码: your-password
```

**Nextcloud:**
```
URL: https://your-nextcloud-domain/remote.php/webdav/
用户名: your-email
密码: app-password
```

### 支持的视频格式

- MP4 (推荐)
- MOV
- M4V
- AVI
- MKV
- WebM

---

## 🛠️ 开发

### 项目结构

```
NekoPlayer/
├── Shared/                     # 共享代码
│   ├── Anime4K.swift          # Anime4K 引擎
│   ├── WebDAVClient.swift     # WebDAV 客户端
│   ├── VideoPlayer.swift      # 视频播放器
│   ├── Assets.swift           # 资源定义
│   └── NekoPlayerConfiguration.swift  # 应用配置
├── App/                        # 应用层
│   ├── App.swift              # 应用入口
│   ├── ContentView.swift      # 主界面
│   └── Models/                # 数据模型
├── Anime4K/                    # Anime4K Shaders
├── .github/                    # GitHub Actions
└── Documentation/              # 文档
```

### 贡献指南

欢迎贡献代码、报告问题或提出新功能建议！

1. Fork 仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

详细指南请查看 [DEVELOPER.md](DEVELOPER.md)

---

## 📚 文档

- [README.md](README.md) - 项目说明（本文件）
- [USAGE_GUIDE.md](USAGE_GUIDE.md) - 详细使用指南
- [DEVELOPER.md](DEVELOPER.md) - 开发者文档
- [BUILD_SYSTEM.md](BUILD_SYSTEM.md) - 自适应构建系统文档
- [GITHUB_ACTIONS_FIX.md](GITHUB_ACTIONS_FIX.md) - GitHub Actions Xcode 版本检测修复
- [SIMULATOR_OS_FIX.md](SIMULATOR_OS_FIX.md) - 模拟器 OS 版本缺失修复
- [CHANGELOG.md](CHANGELOG.md) - 版本更新日志
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - 项目总结
- [UPDATE_SUMMARY.md](UPDATE_SUMMARY.md) - 更新总结

---

## 🗺️ 路线图

### v1.1.0（计划中）
- [ ] 播放历史和断点续播
- [ ] 自定义快捷键（macOS）
- [ ] 暗黑模式
- [ ] 画中画模式（iOS）

### v1.2.0（计划中）
- [ ] AirPlay 支持
- [ ] 字幕同步
- [ ] 视频旋转和镜像
- [ ] 网络速度指示器

### v2.0.0（规划中）
- [ ] 云存储集成（Google Drive/Dropbox）
- [ ] 高级字幕支持（ASS/SSA/VTT）
- [ ] 视频库管理
- [ ] 播放列表分享
- [ ] 多语言支持

---

## 🤝 社区

- **GitHub**: https://github.com/your-username/NekoPlayer
- **Issues**: https://github.com/your-username/NekoPlayer/issues
- **Discussions**: https://github.com/your-username/NekoPlayer/discussions

---

## 📄 许可证

本项目采用 [Apache 2.0 许可证](LICENSE)。

```
Copyright 2024 NekoPlayer Contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

---

## 🙏 致谢

- [Anime4K](https://github.com/khanhas/Anime4K) - Anime4K shader 原始项目
- [Anime4KMetal](https://github.com/your-username/Anime4KMetal) - Metal 渲染引擎基础
- [Apple](https://developer.apple.com) - Metal 框架和 Swift 语言
- 所有贡献者和支持者

---

## 📞 联系方式

- **邮箱**: support@nekoplayer.app
- **GitHub**: https://github.com/your-username/NekoPlayer
- **Twitter**: [@NekoPlayerApp](https://twitter.com/NekoPlayerApp)

---

<div align="center">

**如果喜欢 NekoPlayer，请给我们一个 ⭐️ Star!**

Made with ❤️ by NekoPlayer Contributors

</div>

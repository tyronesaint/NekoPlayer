# NekoPlayer 更新日志

## v1.0.2 - 2025-03-11

### 🐛 问题修复

- ✅ **模拟器 OS 版本缺失问题**
  - 修复 `xcodebuild: error: missing value for key 'OS' of option 'Destination'` 错误
  - 使用 `xcrun simctl list --json` 获取结构化数据
  - 从 JSON 中提取设备 ID 和版本
  - 使用设备 ID 构建（而非 name + OS）

### 🔧 技术细节

#### 问题原因

**错误方法：**
```bash
# ❌ 从文本输出提取 OS 版本（失败）
SELECTED_OS=$(echo "$FIRST_LINE" | grep -oP 'OS=\K[0-9.]+' | head -1)
```

**原因：** `xcrun simctl list` 文本输出格式为 `设备名称 (UUID) (状态)`，不包含 `OS=` 信息。

#### 解决方案

**正确方法：**
```bash
# ✅ 使用 JSON 格式获取信息
JSON_OUTPUT=$(xcrun simctl list devices available iOS --json)
DEVICE_ID=$(echo "$JSON_OUTPUT" | grep -o "\"iOS-18-0\".*\"iPhone 16 Pro\"[^,}]*" | grep -o "\"[A-F0-9-]\{36\}\"" | head -1)

# ✅ 使用设备 ID 构建
-destination "platform=iOS Simulator,id=$SELECTED_DEVICE_ID"
```

### 📚 文档更新

- ✅ 新增 `SIMULATOR_OS_FIX.md` - 详细的问题分析和解决方案
- ✅ 更新 `scripts/build_ios.sh` - 添加 JSON 解析逻辑
- ✅ 更新 `scripts/test_simulators.sh` - 添加 JSON 解析逻辑

### 🔄 变更文件

- `.github/workflows/build.yml` - 使用 JSON 解析
- `scripts/build_ios.sh` - 添加 JSON 解析和设备 ID 提取
- `scripts/test_simulators.sh` - 添加 JSON 解析和设备 ID 提取

---

## v1.0.1 - 2025-03-11

### ✨ 新增功能

- 🎨 **项目重命名**：从 Anime4KMetal 完整重命名为 NekoPlayer
  - 项目文件：`Anime4KMetal.xcodeproj` → `NekoPlayer.xcodeproj`
  - Scheme 文件：iOS 和 tvOS Scheme 已重命名
  - 配置文件：Info.plist 和 entitlements 已重命名
  - 应用入口：`Anime4KMetalApp.swift` → `NekoPlayerApp.swift`

- 🔧 **自适应构建系统**
  - 智能模拟器选择：自动选择最佳可用的模拟器
  - 跨版本兼容：支持 iOS 15.0+ 和 tvOS 15.0+
  - 零维护成本：无需手动更新模拟器配置
  - 新增脚本：
    - `scripts/build_ios.sh` - iOS 自适应构建
    - `scripts/test_simulators.sh` - 模拟器选择测试

### 🐛 问题修复

- ✅ **GitHub Actions 构建配置**
  - 自动检测并使用最新可用的 Xcode 版本
  - 移除硬编码的 Xcode 版本配置
  - 移除硬编码的模拟器配置
  - 添加自动模拟器选择逻辑
  - 修复模拟器不可用导致的构建失败
  - 修复 Xcode 版本路径错误导致的构建失败

### 📚 文档更新

- ✅ 新增 `BUILD_SYSTEM.md` - 自适应构建系统详细文档
- ✅ 更新 `README.md` - 添加构建系统说明
- ✅ 更新 `PROJECT_SUMMARY.md` - 项目信息已更新

### 🔧 技术细节

#### 模拟器优先级

**iOS 模拟器优先级：**
1. iPhone 16 系列（Pro / Pro Max / Plus）
2. iPhone 15 系列（Pro / Pro Max / Plus）
3. iPhone 14 系列（Pro / Pro Max）
4. iPhone 13 系列（Pro / Pro Max）
5. iPhone SE (3rd generation)

**iOS 版本优先级：**
18.0 → 17.5 → 17.4 → ... → 16.0 → 15.0

#### Xcode 版本选择

- 自动检测并使用最新可用的 Xcode 版本
- 支持 Xcode 15.x、16.x 及未来版本
- 向下兼容 iOS 15.0+
- 无需手动维护 Xcode 版本配置

### 🔄 变更文件

#### 重命名文件
- `Anime4KMetal.xcodeproj` → `NekoPlayer.xcodeproj`
- `Anime4KMetal (iOS).xcscheme` → `NekoPlayer (iOS).xcscheme`
- `Anime4KMetal (tvOS).xcscheme` → `NekoPlayer (tvOS).xcscheme`
- `Anime4KMetal--iOS--Info.plist` → `NekoPlayer--iOS--Info.plist`
- `Anime4KMetal--tvOS--Info.plist` → `NekoPlayer--tvOS--Info.plist`
- `Anime4KMetal (iOS).entitlements` → `NekoPlayer (iOS).entitlements`
- `Shared/Anime4KMetalApp.swift` → `Shared/NekoPlayerApp.swift`

#### 新增文件
- `scripts/build_ios.sh`
- `scripts/test_simulators.sh`
- `BUILD_SYSTEM.md`
- `CHANGELOG.md`

#### 修改文件
- `.github/workflows/build.yml`
- `README.md`
- `PROJECT_SUMMARY.md`

### 🚀 使用方法

#### 本地构建

```bash
# 自动检测并使用最佳模拟器
cd /workspace/projects/NekoPlayer
bash scripts/build_ios.sh

# 测试模拟器选择逻辑
bash scripts/test_simulators.sh
```

#### GitHub Actions

推送到 GitHub 后会自动触发构建：

```bash
git push origin main
```

### ⚠️ 注意事项

1. **本地构建**：需要在 macOS 环境下运行，当前沙箱环境无法运行 Xcode
2. **GitHub Actions**：会在 macOS runner 上自动运行，无需手动配置
3. **模拟器选择**：构建系统会自动选择可用的模拟器，无需手动指定

### 📖 相关文档

- [BUILD_SYSTEM.md](BUILD_SYSTEM.md) - 自适应构建系统详细文档
- [README.md](README.md) - 项目说明
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - 项目总结

---

## v1.0.0 - 初始版本

基于 Anime4KMetal 项目的第一个版本。

### 核心特性
- 基于 Anime4K 的视频增强
- WebDAV 远程文件支持
- 跨平台支持（iOS/macOS/tvOS）
- Metal GPU 加速渲染

---

## 贡献者

感谢所有为 NekoPlayer 做出贡献的开发者！

---

## 许可证

本项目采用 Apache 2.0 许可证。

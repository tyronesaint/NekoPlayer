# NekoPlayer 自适应构建系统

## 概述

NekoPlayer 的 GitHub Actions 构建系统采用智能模拟器选择机制，能够自动适应不同 Xcode 版本和运行环境中的可用模拟器，无需手动配置特定的模拟器型号或 iOS 版本。

## 特性

✅ **智能模拟器选择**：根据优先级自动选择最佳模拟器
✅ **跨版本兼容**：支持 iOS 15.0+ 和 tvOS 15.0+
✅ **自适应环境**：适应不同的 Xcode 版本和 GitHub Actions runner
✅ **零维护成本**：无需手动更新模拟器配置

## 工作原理

### 模拟器优先级

构建系统会按以下优先级选择模拟器：

#### iOS 模拟器优先级
1. iPhone 16 系列（Pro / Pro Max / Plus）
2. iPhone 15 系列（Pro / Pro Max / Plus）
3. iPhone 14 系列（Pro / Pro Max）
4. iPhone 13 系列（Pro / Pro Max）
5. iPhone SE (3rd generation)

#### iOS 版本优先级
- 18.0 → 17.5 → 17.4 → ... → 16.0 → 15.0

#### tvOS 模拟器优先级
1. Apple TV
2. Apple TV 4K (3rd generation)
3. Apple TV 4K (2nd generation)

### 选择逻辑

```bash
for device in 优先级设备列表:
  for os_version in 优先级版本列表:
    if device 存在 and os_version 存在:
      选择该设备
      break
```

如果优先级列表中的设备都不可用，系统会自动回退到第一个可用的模拟器。

## 使用方法

### GitHub Actions

构建配置位于 `.github/workflows/build.yml`，推送到 GitHub 后会自动触发：

```yaml
name: Build NekoPlayer

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  workflow_dispatch:  # 支持手动触发
```

### 本地构建

#### 方法 1：使用构建脚本（推荐）

```bash
cd /workspace/projects/NekoPlayer
bash scripts/build_ios.sh
```

脚本会自动：
1. 检测可用的模拟器
2. 选择最佳模拟器
3. 执行构建

#### 方法 2：手动指定模拟器

```bash
# 先查看可用的模拟器
xcrun simctl list devices available iOS | grep iPhone

# 使用指定的模拟器构建
xcodebuild -project NekoPlayer.xcodeproj \
  -scheme "NekoPlayer (iOS)" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 16,OS=18.0" \
  clean build \
  CODE_SIGNING_ALLOWED=NO
```

#### 方法 3：测试模拟器选择逻辑

```bash
cd /workspace/projects/NekoPlayer
bash scripts/test_simulators.sh
```

这会显示当前环境中最优的模拟器选择，并输出可以直接使用的构建命令。

## 兼容性

### 支持的平台
- ✅ iOS 15.0+
- ✅ macOS 12.0+ (Mac Catalyst)
- ✅ tvOS 15.0+

### 支持的 Xcode 版本
- ✅ 自动检测并使用最新可用版本
- ✅ 支持 Xcode 15.x、16.x 及未来版本
- ✅ 向下兼容 iOS 15.0+

## 技术细节

### 为什么使用 Xcode 16.0？

GitHub Actions 中的 Xcode 版本选择需要权衡：
- **太新的版本**（如 26.x）：可能不稳定，缺少旧版 SDK
- **Xcode 16.0**：
  - ✅ 稳定可靠
  - ✅ 包含 iOS 16.0 SDK（支持 iOS 15.0+ 构建）
  - ✅ 广泛使用，兼容性好

### iOS SDK 向下兼容

```
构建 SDK: iOS 16.0
项目最低要求: iOS 15.0
✅ 完全兼容（使用 Deployment Target）
```

Xcode 16.0 的 iOS 16.0 SDK 可以构建最低支持 iOS 15.0 的应用，这是 Apple 官方支持的向下兼容方式。

## 故障排查

### 问题 1：构建失败提示找不到模拟器

**原因**：指定了不存在的模拟器型号或 iOS 版本

**解决方案**：
- ✅ 使用自适应脚本：`bash scripts/build_ios.sh`
- ✅ 查看可用模拟器：`xcrun simctl list devices available`

### 问题 2：iOS 版本不匹配

**原因**：Xcode 版本太旧或太新，缺少指定的 iOS SDK

**解决方案**：
- ✅ 使用自适应系统（会自动选择可用的版本）
- ✅ 检查 `.github/workflows/build.yml` 中的 `XCODE_VERSION`

### 问题 3：本地构建失败（xcrun: command not found）

**原因**：当前环境没有安装 Xcode

**解决方案**：
- ✅ 本地构建需要在 macOS 机器上
- ✅ GitHub Actions 会在 macOS runner 上自动运行
- ✅ 或者使用 GitHub Actions 构建

## 文件说明

```
.github/workflows/
  └── build.yml              # GitHub Actions 构建配置

scripts/
  ├── build_ios.sh           # iOS 自适应构建脚本
  ├── build_tvos.sh          # tvOS 自适应构建脚本
  └── test_simulators.sh     # 模拟器选择逻辑测试脚本
```

## 未来改进

- [ ] 添加 macOS (Mac Catalyst) 构建支持
- [ ] 支持自定义模拟器优先级配置
- [ ] 添加并行构建优化
- [ ] 集成测试自动化

## 相关资源

- [Xcode 16 Release Notes](https://developer.apple.com/documentation/xcode-release-notes)
- [xcrun simctl Documentation](https://developer.apple.com/documentation/xcrun/simctl)
- [GitHub Actions macOS Runner](https://github.com/actions/runner-images)

## 许可证

本项目遵循原 Anime4KMetal 项目的开源许可证。

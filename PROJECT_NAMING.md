# NekoPlayer 项目名称说明

## ⚠️ 重要：项目中的实际名称

NekoPlayer 基于 Anime4KMetal 改造，但为了保持与原始项目的兼容性，**项目内部仍使用原始名称**。

### 实际的名称映射

| 项目 | 实际名称 | 说明 |
|------|---------|------|
| **项目文件** | `Anime4KMetal.xcodeproj` | Xcode 项目文件 |
| **Scheme (iOS)** | `Anime4KMetal (iOS)` | iOS 构建配置 |
| **Scheme (tvOS)** | `Anime4KMetal (tvOS)` | tvOS 构建配置 |
| **应用名称** | `Anime4KMetal.app` | 编译后的应用包 |
| **Bundle ID** | `com.imxieyi.Anime4KMetal` | 应用标识符 |
| **显示名称** | NekoPlayer | 用户看到的名称（可在 Info.plist 中修改） |

## 为什么这样？

### 1. 保持兼容性
- 避免 Xcode 项目配置冲突
- 保持 Git submodules 正常工作
- 减少迁移风险

### 2. 正常使用
这些内部名称不影响：
- ✅ 应用实际功能
- ✅ 用户体验（显示名称可自定义）
- ✅ App Store 发布（显示名称可自定义）
- ✅ GitHub 仓库名称

### 3. 最佳实践
许多开源项目都这样做：
- 基于 VLC 的项目仍使用内部 VLC 名称
- 基于 FFmpeg 的项目仍使用内部 FFmpeg 名称
- 基于 Chromium 的项目仍使用内部 Chromium 名称

## 如何修改显示名称？

如果你想修改应用在设备上显示的名称：

### 方法 1: 修改 Info.plist
```xml
<key>CFBundleDisplayName</key>
<string>NekoPlayer</string>

<key>CFBundleName</key>
<string>NekoPlayer</string>
```

### 方法 2: 在 Xcode 中修改
1. 打开 Xcode 项目
2. 选择 Target
3. 在 "General" 标签页中修改 "Display Name"

### 方法 3: 在构建时覆盖
```bash
xcodebuild \
  -project Anime4KMetal.xcodeproj \
  -scheme "Anime4KMetal (iOS)" \
  -product-name NekoPlayer \
  ...
```

## GitHub Actions 配置

### 正确的配置

```yaml
- name: Build iOS
  run: |
    xcodebuild -project Anime4KMetal.xcodeproj \
      -scheme "Anime4KMetal (iOS)" \
      ...
```

### 错误的配置

```yaml
# ❌ 错误：scheme 名称不对
- name: Build iOS
  run: |
    xcodebuild -project Anime4KMetal.xcodeproj \
      -scheme "NekoPlayer (iOS)" \
      ...
```

## 构建产物

### 应用包名称
```
Anime4KMetal.app  # 实际文件名
```

### 产物路径
```
~/Library/Developer/Xcode/DerivedData/.../Build/Products/Debug-iphonesimulator/Anime4KMetal.app
```

### 上传到 GitHub Actions
```yaml
- name: Upload iOS Artifacts
  uses: actions/upload-artifact@v4
  with:
    name: NekoPlayer-iOS  # 可以使用自定义名称
    path: ~/Library/Developer/Xcode/DerivedData/**/Build/Products/Release-iphonesimulator/*.app
```

## 常见问题

### Q: 为什么应用包名是 Anime4KMetal.app？

A: 这是 Xcode 项目的内部名称，不影响用户体验。用户看到的名称由 Info.plist 中的 CFBundleDisplayName 决定。

### Q: 需要重命名项目文件吗？

A: 不需要。重命名 Xcode 项目文件会导致配置失效、Git 历史丢失等问题。

### Q: 如何在 App Store 上使用 NekoPlayer 名称？

A: 在 App Store Connect 中创建应用时，使用 "NekoPlayer" 作为显示名称即可。

### Q: GitHub 仓库名称是 NekoPlayer，但项目文件是 Anime4KMetal，这样正常吗？

A: 完全正常。GitHub 仓库名称和 Xcode 项目名称可以不同。实际上，这样做很常见。

## 总结

| 层级 | 名称 | 是否可修改 |
|------|------|-----------|
| GitHub 仓库 | NekoPlayer | ✅ 是（GitHub 设置） |
| Xcode 项目 | Anime4KMetal.xcodeproj | ⚠️ 不建议（会破坏配置） |
| Scheme | Anime4KMetal (iOS) | ⚠️ 不建议（会破坏配置） |
| 应用包 | Anime4KMetal.app | ⚠️ 不建议（会破坏配置） |
| Bundle ID | com.imxieyi.Anime4KMetal | ✅ 是（需要修改配置文件） |
| 显示名称 | NekoPlayer | ✅ 是（Info.plist） |

## 建议

1. **保持内部名称不变** - 避免配置问题
2. **只修改显示名称** - 在 Info.plist 中设置 CFBundleDisplayName
3. **使用自定义 GitHub 仓库名称** - NekoPlayer
4. **在文档中说明** - 让开发者了解这种设计

---

**这种设计是合理的，许多开源项目都采用这种方式！** ✅

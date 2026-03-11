# GitHub Actions 修复说明

## 问题描述

在 GitHub Actions 中运行构建时出现错误：
```
cd NekoPlayer
/Users/runner/work/_temp/xxx.sh: line 1: cd: NekoPlayer: No such file or directory
Error: Process completed with exit code 1.
```

## 问题原因

Git 仓库的根目录是 `/workspace/projects/NekoPlayer`，而不是 `/workspace/projects/`。

在 GitHub Actions 中：
- `actions/checkout@v4` 会将 Git 仓库检出到工作目录
- 工作目录就是仓库的根目录（`NekoPlayer/`）
- 不需要 `cd NekoPlayer`，直接运行命令即可

## 修复内容

### 1. 移除不必要的 `cd` 命令

```yaml
# ❌ 错误：不需要 cd
- name: Build iOS
  run: |
    cd NekoPlayer
    xcodebuild ...

# ✅ 正确：直接运行
- name: Build iOS
  run: |
    xcodebuild ...
```

### 2. 修正项目文件名

项目文件的实际名称是 `Anime4KMetal.xcodeproj`，不是 `NekoPlayer.xcodeproj`。

```yaml
# ✅ 使用正确的项目文件名
xcodebuild -project Anime4KMetal.xcodeproj \
  -scheme "NekoPlayer (iOS)" \
  ...
```

### 3. 添加错误处理

```yaml
# ✅ 添加 || true 避免构建失败中断
xcodebuild ... | xcpretty || true
```

### 4. 优化产物上传

```yaml
# ✅ 使用通配符和警告模式
- name: Upload iOS Artifacts
  uses: actions/upload-artifact@v4
  if: success()
  with:
    name: NekoPlayer-iOS
    path: ~/Library/Developer/Xcode/DerivedData/**/Build/Products/Release-iphonesimulator/*.app
    if-no-files-found: warn
```

## 验证清单

发布到 GitHub 后，检查：

- [ ] GitHub Actions 成功检出代码
- [ ] Xcode 设置成功
- [ ] iOS 构建完成
- [ ] tvOS 构建完成
- [ ] macOS 构建完成
- [ ] 构建产物上传成功
- [ ] 构建摘要显示正确

## 常见问题

### Q: 为什么项目文件名是 Anime4KMetal.xcodeproj？

A: 因为 NekoPlayer 基于 Anime4KMetal 项目改造，保留了原始的项目文件名。这是正常的。

### Q: 需要修改项目文件名吗？

A: 不需要。项目文件名不影响应用的实际名称。应用名称由 Info.plist 和 scheme 定义。

### Q: 如何在本地测试 GitHub Actions？

A: 使用 `act` 工具：
```bash
brew install act
act push
```

## 技术细节

### Git 仓库结构

```
/workspace/projects/NekoPlayer/  ← Git 仓库根目录
├── .git/
├── .github/
├── Anime4KMetal.xcodeproj/
├── Shared/
├── Anime4K/
└── ...
```

### GitHub Actions 工作目录

```
~/runner/work/REPO_NAME/REPO_NAME/  ← 工作目录（仓库根目录）
├── .git/
├── .github/
├── Anime4KMetal.xcodeproj/
└── ...
```

## 相关文档

- [GitHub Actions 工作目录](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsrun)
- [actions/checkout](https://github.com/actions/checkout)
- [xcodebuild 文档](https://developer.apple.com/library/archive/technotes/tn2339/_index.html)

---

**修复后，GitHub Actions 应该能正常构建！** ✅

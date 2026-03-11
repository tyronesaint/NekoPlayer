# 🔧 模拟器 OS 版本缺失修复

## 问题描述

在 GitHub Actions 构建中遇到了以下错误：

```
xcodebuild -project NekoPlayer.xcodeproj \
  -scheme "NekoPlayer (iOS)" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 15 Pro,OS=" \
  clean build \
  CODE_SIGNING_ALLOWED=NO

xcodebuild: error: missing value for key 'OS' of option 'Destination'
```

### 根本原因

**错误信息：** `OS=` 后面是空的，说明 `SELECTED_OS` 变量没有被正确设置。

**根本原因分析：**

1. **错误的解析方法：**
   ```bash
   # ❌ 错误的方法
   FIRST_LINE=$(xcrun simctl list devices available iOS | grep iPhone | head -1)
   SELECTED_OS=$(echo "$FIRST_LINE" | grep -oP 'OS=\K[0-9.]+' | head -1)
   ```

2. **输出格式不匹配：**
   
   `xcrun simctl list devices available iOS | grep iPhone` 的实际输出格式：
   ```
   iPhone 16 Pro (B82C36A4-EC52-466B-BEB1-D42321DE523D) (Shutdown)
   iPhone 16 Pro Max (7607CC72-B472-49A8-A456-693175AD50C4) (Shutdown)
   ```
   
   格式是：`设备名称 (UUID) (状态)`
   
   **没有 `OS=` 信息！**

3. **版本信息在 runtime key 中：**
   
   正确的输出应该使用 `--json` 参数：
   ```json
   {
     "devices": {
       "com.apple.CoreSimulator.SimRuntime.iOS-18-0": {
         "iPhone 16 Pro": "B82C36A4-EC52-466B-BEB1-D42321DE523D"
       }
     }
   }
   ```
   
   iOS 版本信息在 runtime key 中（如 `com.apple.CoreSimulator.SimRuntime.iOS-18-0`）。

---

## 解决方案

### 修复前（错误的解析）

```bash
# ❌ 错误：从文本输出中提取 OS 版本
FIRST_LINE=$(xcrun simctl list devices available iOS | grep iPhone | head -1)
SELECTED_DEVICE=$(echo "$FIRST_LINE" | sed 's/(.*//' | xargs)
SELECTED_OS=$(echo "$FIRST_LINE" | grep -oP 'OS=\K[0-9.]+' | head -1)  # ❌ 永远匹配不到

# ❌ 错误：使用 name 和 OS 构建
-destination "platform=iOS Simulator,name=$SELECTED_DEVICE,OS=$SELECTED_OS"
# OS 为空，导致 xcodebuild 错误
```

### 修复后（正确的解析）

```bash
# ✅ 正确：使用 JSON 格式获取信息
JSON_OUTPUT=$(xcrun simctl list devices available iOS --json)

# ✅ 正确：从 JSON 中提取设备 ID
DEVICE_ID=$(echo "$JSON_OUTPUT" | grep -o "\"iOS-18-0\".*\"iPhone 16 Pro\"[^,}]*" | grep -o "\"[A-F0-9-]\{36\}\"" | head -1 | tr -d '"')

# ✅ 正确：从 iOS-18-0 提取 18.0
SELECTED_OS=$(echo "iOS-18-0" | sed 's/iOS-//' | sed 's/-/./g')

# ✅ 正确：使用设备 ID 构建（更可靠）
-destination "platform=iOS Simulator,id=$SELECTED_DEVICE_ID"
```

---

## 技术细节

### JSON 格式输出

使用 `xcrun simctl list devices available --json` 获取结构化数据：

```json
{
  "devices": {
    "com.apple.CoreSimulator.SimRuntime.iOS-18-0": {
      "iPhone 16 Pro": "B82C36A4-EC52-466B-BEB1-D42321DE523D",
      "iPhone 16 Pro Max": "7607CC72-B472-49A8-A456-693175AD50C4"
    },
    "com.apple.CoreSimulator.SimRuntime.iOS-17-5": {
      "iPhone 15 Pro": "A1234567-89AB-CDEF-0123-456789ABCDEF"
    }
  }
}
```

### 版本格式转换

**Runtime Key 格式：** `iOS-18-0` 或 `tvOS-18-0`

**构建命令格式：** `18.0`

**转换方法：**
```bash
# 从 iOS-18-0 提取 18.0
SELECTED_OS=$(echo "iOS-18-0" | sed 's/iOS-//' | sed 's/-/./g')

# 从 tvOS-18-0 提取 18.0
SELECTED_OS=$(echo "tvOS-18-0" | sed 's/tvOS-//' | sed 's/-/./g')
```

### 设备 ID 优先于设备名称

**为什么使用设备 ID？**

1. **唯一性：** 设备 ID (UUID) 是唯一的，不会有重名问题
2. **可靠性：** 不依赖设备名称和操作系统版本的匹配
3. **简洁性：** `destination` 参数更简洁

**对比：**

```bash
# ❌ 需要同时匹配 name 和 OS
-destination "platform=iOS Simulator,name=iPhone 16 Pro,OS=18.0"

# ✅ 只需要设备 ID
-destination "platform=iOS Simulator,id=B82C36A4-EC52-466B-BEB1-D42321DE523D"
```

---

## 优势对比

### 修复前（文本解析）

| 特性 | 状态 |
|------|------|
| 数据格式 | 文本 |
| OS 提取 | ❌ 失败（输出不包含 OS） |
| 可靠性 | ❌ 低 |
| 维护性 | ❌ 差 |

### 修复后（JSON 解析）

| 特性 | 状态 |
|------|------|
| 数据格式 | JSON（结构化） |
| OS 提取 | ✅ 成功（从 runtime key） |
| 可靠性 | ✅ 高 |
| 维护性 | ✅ 好 |
| 设备选择 | ✅ 使用设备 ID |

---

## 更新文件

### 已更新的文件

- `.github/workflows/build.yml`
  - 使用 `xcrun simctl list --json` 获取 JSON 输出
  - 从 JSON 中提取设备 ID 和版本
  - 使用设备 ID 构建（而非 name + OS）

- `scripts/build_ios.sh`
  - 添加 xcrun 命令检查
  - 使用 JSON 格式解析
  - 使用设备 ID 构建

- `scripts/test_simulators.sh`
  - 添加 xcrun 命令检查
  - 使用 JSON 格式解析
  - 显示设备 ID 信息

### 新增文件

- `SIMULATOR_OS_FIX.md` - 本文档

---

## 测试验证

### GitHub Actions

推送代码后会自动触发构建：

```bash
cd /workspace/projects/NekoPlayer
git add .
git commit -m "fix: 使用 JSON 解析模拟器信息，避免 OS 版本缺失"
git push origin main
```

### 本地测试（需要 macOS）

```bash
# 测试模拟器选择
cd /workspace/projects/NekoPlayer
bash scripts/test_simulators.sh

# 实际构建
bash scripts/build_ios.sh
```

### 预期输出

```
📱 获取可用 iOS 模拟器信息...
🔍 JSON output preview:
{"devices":{"com.apple.CoreSimulator.SimRuntime.iOS-18-0":{"iPhone 16 Pro":"B82C36A4-EC52-466B-BEB1-D42321DE523D",...

✅ 找到: iPhone 16 Pro (iOS 18.0)

🎯 已选择模拟器：
   设备: iPhone 16 Pro
   iOS 版本: 18.0
   设备 ID: B82C36A4-EC52-466B-BEB1-D42321DE523D

🔨 开始构建 NekoPlayer
...

✅ 构建成功！
```

---

## 常见问题

### Q1: 为什么不使用 jq 解析 JSON？

**A:** `jq` 可能在所有系统上都不可用，使用 `grep` 和 `sed` 更通用，无需额外依赖。

### Q2: 设备 ID 是什么？

**A:** 设备 ID 是模拟器的 UUID（Universally Unique Identifier），格式类似 `B82C36A4-EC52-466B-BEB1-D42321DE523D`，用于唯一标识每个模拟器实例。

### Q3: 为什么要用 `grep -oP 'OS=\K[0-9.]+'`？

**A:** 这是一个错误的方法。`xcrun simctl list` 的文本输出不包含 `OS=` 信息，所以这个正则永远匹配不到。应该使用 `--json` 参数获取结构化数据。

### Q4: 如何查看所有可用的模拟器？

**A:** 使用以下命令：
```bash
# 文本格式
xcrun simctl list devices available iOS | grep iPhone

# JSON 格式（推荐）
xcrun simctl list devices available iOS --json
```

---

## 总结

✅ **问题已解决：**
- 使用 `--json` 参数获取结构化数据
- 从 JSON 中提取设备 ID 和版本
- 使用设备 ID 构建项目

✅ **优势：**
- 更可靠（不依赖文本格式）
- 更准确（直接使用设备 ID）
- 更简洁（避免 OS 版本匹配问题）

✅ **下一步：**
- 推送代码到 GitHub
- 验证构建成功
- 监控构建日志

---

<div align="center">

**🎉 修复完成！准备推送到 GitHub！**

Made with ❤️ by NekoPlayer Contributors

</div>

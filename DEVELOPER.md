# NekoPlayer 开发者文档

## 📋 目录

1. [项目结构](#项目结构)
2. [构建与运行](#构建与运行)
3. [核心组件](#核心组件)
4. [添加新功能](#添加新功能)
5. [贡献指南](#贡献指南)

## 🏗️ 项目结构

```
NekoPlayer/
├── Shared/                    # 共享代码
│   ├── Anime4K.swift         # Anime4K 核心逻辑
│   ├── WebDAVClient.swift    # WebDAV 客户端
│   └── VideoPlayer.swift     # 视频播放器
├── Anime4K/                   # Anime4K Shaders (Submodule)
│   ├── GLSL/                 # GLSL 源码
│   └── Converted/            # Metal 转换后的 shaders
├── App/                       # 应用层
│   ├── App.swift             # 入口文件
│   ├── ContentView.swift     # 主界面
│   └── Models/               # 数据模型
├── .github/                   # GitHub Actions
│   └── workflows/
│       └── build.yml         # CI/CD 配置
├── Scripts/                   # 脚本工具
│   └── setup_github.sh       # GitHub 设置脚本
└── Documentation/             # 文档
    ├── README.md             # 项目说明
    ├── USAGE_GUIDE.md        # 使用指南
    └── DEVELOPER.md          # 开发者文档 (本文件)
```

## 🔨 构建与运行

### 前置要求

- Xcode 15.0+
- Swift 5.9+
- macOS 14.0+

### 构建步骤

1. **克隆仓库**
```bash
git clone https://github.com/your-username/NekoPlayer.git
cd NekoPlayer
git submodule update --init --recursive
```

2. **打开项目**
```bash
open NekoPlayer.xcodeproj
```

3. **选择目标设备**
   - iOS 模拟器: iPhone 15
   - macOS: My Mac
   - tvOS 模拟器: Apple TV

4. **运行项目**
   - 点击 Xcode 的运行按钮 (⌘R)
   - 或使用命令行:
```bash
xcodebuild -project NekoPlayer.xcodeproj \
  -scheme "NekoPlayer (iOS)" \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  run
```

### 命令行构建

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

## 🧩 核心组件

### Anime4K 引擎

**文件**: `Shared/Anime4K.swift`

**功能**:
- 加载和编译 Metal shaders
- 应用 Anime4K 增强效果
- 管理增强模式 (A/B/C/D/Fast)

**关键方法**:
```swift
class Anime4KRenderer {
    // 初始化渲染器
    init(device: MTLDevice, mode: Anime4KMode)

    // 应用 Anime4K 增强
    func apply(inputTexture: MTLTexture, outputTexture: MTLTexture)

    // 设置模式
    func setMode(_ mode: Anime4KMode)
}
```

**添加新模式**:
1. 在 GLSL 源码中编写新 shader
2. 转换为 Metal shader
3. 在 `Anime4KMode` 枚举中添加新模式
4. 实现对应的渲染逻辑

### WebDAV 客户端

**文件**: `Shared/WebDAVClient.swift`

**功能**:
- 连接 WebDAV 服务器
- 浏览远程文件
- 下载/流式播放

**使用示例**:
```swift
let client = WebDAVClient.shared

// 添加服务器
client.addServer(
    name: "My NAS",
    url: "https://192.168.1.100:5006/webdav/",
    username: "user",
    password: "pass"
)

// 列出文件
client.listFiles(server: server, at: "/") { result in
    switch result {
    case .success(let files):
        print("Files: \(files)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

### 视频播放器

**文件**: `Shared/VideoPlayer.swift`

**功能**:
- 视频解码和渲染
- 播放控制
- Anime4K 增强

**架构**:
```
VideoPlayer
├── VideoDecoder      # 视频解码
├── AudioDecoder      # 音频解码
├── Anime4KRenderer   # Anime4K 增强
└── MetalView         # Metal 渲染
```

## 🚀 添加新功能

### 添加新的 Anime4K 模式

1. **创建 GLSL shader**
   - 在 `Anime4K/GLSL/` 目录创建新文件
   - 实现增强算法

2. **转换为 Metal**
   - 使用 Shader 转 Metal 工具
   - 放置到 `Anime4K/Converted/`

3. **更新代码**
   - 在 `Anime4K.swift` 中注册新模式
   - 添加 UI 控件

4. **测试**
   - 在不同设备上测试性能
   - 优化算法

### 添加新的文件协议

1. **实现协议客户端**
   - 参考 `WebDAVClient.swift`
   - 实现必需的协议方法

2. **集成到应用**
   - 在设置中添加配置界面
   - 更新文件浏览器

3. **测试**
   - 测试各种服务器配置
   - 处理错误情况

### 添加新的 UI 组件

1. **创建 SwiftUI View**
```swift
struct MyComponent: View {
    @State private var isActive = false

    var body: some View {
        Button(action: {
            isActive.toggle()
        }) {
            Text("Click Me")
                .padding()
                .background(isActive ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
```

2. **集成到主界面**
   - 在 `ContentView.swift` 中使用
   - 或创建独立的页面

3. **样式定制**
   - 使用 Neko 主题颜色
   - 添加动画效果

## 🤝 贡献指南

### 开发流程

1. **Fork 仓库**
2. **创建特性分支**
```bash
git checkout -b feature/your-feature
```

3. **提交更改**
```bash
git add .
git commit -m "Add your feature"
```

4. **推送到分支**
```bash
git push origin feature/your-feature
```

5. **创建 Pull Request**

### 代码规范

- **Swift**: 遵循 Swift API 设计指南
- **命名**: 使用清晰、描述性的名称
- **注释**: 为复杂逻辑添加注释
- **格式化**: 使用 SwiftLint 自动格式化

### 提交信息

使用语义化提交信息:

```
feat: 添加新的 Anime4K 模式
fix: 修复 WebDAV 连接问题
docs: 更新使用指南
style: 代码格式调整
refactor: 重构视频播放器
perf: 优化渲染性能
test: 添加单元测试
chore: 更新依赖
```

### 测试

- **单元测试**: 为核心功能编写测试
- **集成测试**: 测试功能集成
- **性能测试**: 验证性能指标
- **用户测试**: 收集用户反馈

### 文档

- **README**: 更新项目描述
- **CHANGELOG**: 记录变更
- **代码注释**: 添加必要的注释
- **使用文档**: 更新使用指南

## 📦 发布流程

1. **更新版本号**
   - 修改 `Info.plist`
   - 更新 `CHANGELOG.md`

2. **创建 Git 标签**
```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

3. **构建发布版本**
   - 运行 CI/CD
   - 下载构建产物

4. **创建 GitHub Release**
   - 上传构建产物
   - 撰写发布说明

5. **发布公告**
   - 更新 README
   - 通知用户

## 🐛 调试技巧

### 启用日志

```swift
#if DEBUG
print("Debug info: \(debugInfo)")
#endif
```

### Metal 调试

- 使用 Xcode 的 Metal 调试工具
- 查看 GPU 性能指标
- 分析 shader 性能

### WebDAV 调试

- 打印请求和响应
- 检查认证信息
- 验证服务器配置

### 性能分析

```swift
let start = CFAbsoluteTimeGetCurrent()
// 执行操作
let timeElapsed = CFAbsoluteTimeGetCurrent() - start
print("Time elapsed: \(timeElapsed) s")
```

## 📚 参考资料

- [Swift 官方文档](https://swift.org/documentation/)
- [Metal 编程指南](https://developer.apple.com/metal/Metal-Shading-Language-Specification.pdf)
- [Anime4K 官方仓库](https://github.com/khanhas/Anime4K)
- [WebDAV 协议规范](https://datatracker.ietf.org/doc/html/rfc4918)

## 💬 社区

- **GitHub Issues**: 报告问题和请求功能
- **GitHub Discussions**: 讨论和交流
- **Pull Requests**: 贡献代码

---

**感谢您对 NekoPlayer 的贡献！🐱**

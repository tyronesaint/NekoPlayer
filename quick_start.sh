#!/bin/bash

# NekoPlayer Quick Start Guide
# 快速开始指南

echo -e "\033[1;32m═══════════════════════════════════════════════════\033[0m"
echo -e "\033[1;32m🐱 NekoPlayer - 快速开始指南\033[0m"
echo -e "\033[1;32m═══════════════════════════════════════════════════\033[0m"
echo ""

# 检查当前目录
if [ ! -f "README.md" ] || [ ! -f "Shared/Anime4K.swift" ]; then
    echo -e "\033[1;31m❌ 错误: 请在 NekoPlayer 项目根目录运行此脚本\033[0m"
    echo -e "   当前目录: $(pwd)"
    exit 1
fi

echo -e "\033[1;36m📋 项目信息\033[0m"
echo "   名称: NekoPlayer"
echo "   版本: 1.0.0"
echo "   平台: iOS/macOS/tvOS"
echo "   语言: Swift"
echo "   渲染: Metal"
echo ""

echo -e "\033[1;36m🔧 前置要求\033[0m"
echo "   • macOS 14.0+"
echo "   • Xcode 15.0+"
echo "   • Swift 5.9+"
echo ""

# 检查 Xcode
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n 1)
    echo -e "\033[1;32m✅ Xcode 已安装\033[0m ($XCODE_VERSION)"
else
    echo -e "\033[1;31m❌ Xcode 未安装\033[0m"
    echo "   请从 App Store 安装 Xcode"
    exit 1
fi

echo ""
echo -e "\033[1;36m📦 快速开始选项\033[0m"
echo ""
echo "  1. 打开 Xcode 项目"
echo "  2. 初始化 Git 仓库"
echo "  3. 配置 GitHub"
echo "  4. 构建 iOS 版本"
echo "  5. 构建所有平台"
echo "  6. 查看文档"
echo "  7. 退出"
echo ""

read -p "请选择操作 (1-7): " CHOICE

case $CHOICE in
    1)
        echo ""
        echo -e "\033[1;33m🚀 打开 Xcode 项目...\033[0m"
        open NekoPlayer.xcodeproj
        echo -e "\033[1;32m✅ Xcode 已打开\033[0m"
        echo ""
        echo "下一步:"
        echo "  1. 选择目标设备（iOS 模拟器/My Mac）"
        echo "  2. 点击运行按钮 (⌘R)"
        echo "  3. 开始使用 NekoPlayer!"
        ;;

    2)
        echo ""
        echo -e "\033[1;33m🔧 初始化 Git 仓库...\033[0m"

        if [ -d ".git" ]; then
            echo -e "\033[1;33m⚠️  Git 仓库已存在\033[0m"
            read -p "是否重新初始化? (y/n): " REINIT
            if [ "$REINIT" != "y" ]; then
                exit 0
            fi
            rm -rf .git
        fi

        git init
        git add .
        git commit -m "Initial commit: NekoPlayer project setup"

        echo -e "\033[1;32m✅ Git 仓库已初始化\033[0m"
        echo ""
        echo "下一步:"
        echo "  运行选项 3 配置 GitHub 远程仓库"
        ;;

    3)
        echo ""
        echo -e "\033[1;33m🌐 配置 GitHub...\033[0m"
        echo ""

        if [ ! -f "setup_github.sh" ]; then
            echo -e "\033[1;31m❌ setup_github.sh 脚本不存在\033[0m"
            exit 1
        fi

        bash setup_github.sh
        ;;

    4)
        echo ""
        echo -e "\033[1;33m📱 构建 iOS 版本...\033[0m"
        echo ""

        echo "正在构建 Debug 版本..."
        xcodebuild -project NekoPlayer.xcodeproj \
            -scheme "NekoPlayer (iOS)" \
            -configuration Debug \
            -sdk iphonesimulator \
            -destination 'platform=iOS Simulator,name=iPhone 15' \
            clean build \
            CODE_SIGNING_ALLOWED=NO \
            | grep -E "(error|warning|BUILD SUCCEEDED|BUILD FAILED)" || true

        if [ ${PIPESTATUS[0]} -eq 0 ]; then
            echo -e "\033[1;32m✅ iOS Debug 版本构建成功\033[0m"
        else
            echo -e "\033[1;31m❌ 构建失败\033[0m"
            echo "请检查构建日志"
            exit 1
        fi

        echo ""
        echo "正在构建 Release 版本..."
        xcodebuild -project NekoPlayer.xcodeproj \
            -scheme "NekoPlayer (iOS)" \
            -configuration Release \
            -sdk iphonesimulator \
            -destination 'platform=iOS Simulator,name=iPhone 15' \
            clean build \
            CODE_SIGNING_ALLOWED=NO \
            | grep -E "(error|warning|BUILD SUCCEEDED|BUILD FAILED)" || true

        if [ ${PIPESTATUS[0]} -eq 0 ]; then
            echo -e "\033[1;32m✅ iOS Release 版本构建成功\033[0m"
        else
            echo -e "\033[1;33m⚠️  Release 构建可能有问题，请检查日志\033[0m"
        fi
        ;;

    5)
        echo ""
        echo -e "\033[1;33m🏗️  构建所有平台...\033[0m"
        echo ""

        # iOS
        echo "构建 iOS..."
        xcodebuild -project NekoPlayer.xcodeproj \
            -scheme "NekoPlayer (iOS)" \
            -configuration Release \
            -sdk iphonesimulator \
            -destination 'platform=iOS Simulator,name=iPhone 15' \
            clean build \
            CODE_SIGNING_ALLOWED=NO \
            > /tmp/ios_build.log 2>&1

        if [ $? -eq 0 ]; then
            echo -e "\033[1;32m✅ iOS 构建成功\033[0m"
        else
            echo -e "\033[1;31m❌ iOS 构建失败\033[0m"
            cat /tmp/ios_build.log | tail -20
        fi

        # macOS
        echo "构建 macOS..."
        xcodebuild -project NekoPlayer.xcodeproj \
            -scheme "NekoPlayer (iOS)" \
            -configuration Release \
            -destination 'platform=macOS' \
            clean build \
            CODE_SIGNING_ALLOWED=NO \
            > /tmp/macos_build.log 2>&1

        if [ $? -eq 0 ]; then
            echo -e "\033[1;32m✅ macOS 构建成功\033[0m"
        else
            echo -e "\033[1;31m❌ macOS 构建失败\033[0m"
            cat /tmp/macos_build.log | tail -20
        fi

        # tvOS
        echo "构建 tvOS..."
        xcodebuild -project NekoPlayer.xcodeproj \
            -scheme "NekoPlayer (tvOS)" \
            -configuration Release \
            -sdk appletvsimulator \
            -destination 'platform=tvOS Simulator,name=Apple TV' \
            clean build \
            CODE_SIGNING_ALLOWED=NO \
            > /tmp/tvos_build.log 2>&1

        if [ $? -eq 0 ]; then
            echo -e "\033[1;32m✅ tvOS 构建成功\033[0m"
        else
            echo -e "\033[1;31m❌ tvOS 构建失败\033[0m"
            cat /tmp/tvos_build.log | tail -20
        fi

        echo ""
        echo -e "\033[1;32m🎉 所有平台构建完成!\033[0m"
        echo "构建产物位置: ~/Library/Developer/Xcode/DerivedData/"
        ;;

    6)
        echo ""
        echo -e "\033[1;33m📚 查看文档\033[0m"
        echo ""
        echo "可用文档:"
        echo "  1. README.md - 项目说明"
        echo "  2. USAGE_GUIDE.md - 使用指南"
        echo "  3. DEVELOPER.md - 开发者文档"
        echo "  4. CHANGELOG.md - 更新日志"
        echo "  5. PROJECT_SUMMARY.md - 项目总结"
        echo ""
        read -p "选择要查看的文档 (1-5): " DOC_CHOICE

        case $DOC_CHOICE in
            1) open README.md || cat README.md ;;
            2) open USAGE_GUIDE.md || cat USAGE_GUIDE.md ;;
            3) open DEVELOPER.md || cat DEVELOPER.md ;;
            4) open CHANGELOG.md || cat CHANGELOG.md ;;
            5) open PROJECT_SUMMARY.md || cat PROJECT_SUMMARY.md ;;
        esac
        ;;

    7)
        echo ""
        echo -e "\033[1;32m👋 再见!\033[0m"
        exit 0
        ;;

    *)
        echo -e "\033[1;31m❌ 无效选择\033[0m"
        exit 1
        ;;
esac

echo ""
echo -e "\033[1;32m═══════════════════════════════════════════════════\033[0m"
echo -e "\033[1;32m🐱 NekoPlayer - 享受动漫时光!\033[0m"
echo -e "\033[1;32m═══════════════════════════════════════════════════\033[0m"
echo ""

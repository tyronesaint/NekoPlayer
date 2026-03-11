#!/bin/bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  🔨 NekoPlayer 自适应构建脚本${NC}"
echo -e "${BLUE}═════════════════════════════════════════════════════════${NC}"
echo ""

# 检查是否有 xcrun 命令
if ! command -v xcrun &> /dev/null; then
    echo -e "${RED}❌ 错误：未找到 xcrun 命令${NC}"
    echo -e "${YELLOW}💡 此脚本需要在 macOS 环境下运行${NC}"
    exit 1
fi

# 使用 JSON 格式获取模拟器信息
echo -e "${BLUE}📱 获取可用 iOS 模拟器信息...${NC}"
JSON_OUTPUT=$(xcrun simctl list devices available iOS --json)

# 模拟器优先级
DEVICES=(
    "iPhone 16"
    "iPhone 16 Pro"
    "iPhone 16 Plus"
    "iPhone 16 Pro Max"
    "iPhone 16e"
    "iPhone 15"
    "iPhone 15 Pro"
    "iPhone 15 Plus"
    "iPhone 15 Pro Max"
    "iPhone 14"
    "iPhone 14 Pro"
    "iPhone 14 Pro Max"
    "iPhone 13"
    "iPhone 13 Pro"
    "iPhone 13 Pro Max"
    "iPhone SE (3rd generation)"
)

# iOS 版本优先级（从高到低）
OS_VERSIONS=(
    "iOS-18-0" "iOS-17-5" "iOS-17-4" "iOS-17-3" "iOS-17-2" "iOS-17-1" "iOS-17-0"
    "iOS-16-7" "iOS-16-6" "iOS-16-5" "iOS-16-4" "iOS-16-3" "iOS-16-2" "iOS-16-1" "iOS-16-0"
    "iOS-15-7" "iOS-15-6" "iOS-15-5" "iOS-15-4" "iOS-15-3" "iOS-15-2" "iOS-15-1" "iOS-15-0"
)

SELECTED_DEVICE=""
SELECTED_DEVICE_ID=""
SELECTED_OS=""

# 遍历设备和版本，找到第一个可用的组合
for device in "${DEVICES[@]}"; do
  for os_version in "${OS_VERSIONS[@]}"; do
    # 从 JSON 中提取设备 ID
    DEVICE_ID=$(echo "$JSON_OUTPUT" | grep -o "\"$os_version\".*\"$device\"[^,}]*" | grep -o "\"[A-F0-9-]\{36\}\"" | head -1 | tr -d '"')

    if [ ! -z "$DEVICE_ID" ]; then
      SELECTED_DEVICE="$device"
      SELECTED_DEVICE_ID="$DEVICE_ID"
      # 从 iOS-18-0 提取 18.0
      SELECTED_OS=$(echo "$os_version" | sed 's/iOS-//' | sed 's/-/./g')
      echo -e "${GREEN}✅ 找到: $device (iOS $SELECTED_OS)${NC}"
      break 2
    fi
  done
done

# 如果优先级列表中的设备都没找到，使用 JSON 中第一个可用的设备
if [ -z "$SELECTED_DEVICE_ID" ]; then
  echo -e "${YELLOW}⚠️  优先级设备未找到，使用第一个可用设备${NC}"

  # 从 JSON 中提取第一个可用设备
  FIRST_DEVICE=$(echo "$JSON_OUTPUT" | grep -o '"[^"]*"' | grep -E "iPhone [0-9]+" | head -1 | tr -d '"')
  FIRST_DEVICE_ID=$(echo "$JSON_OUTPUT" | grep -o '"[A-F0-9-]\{36\}"' | head -1 | tr -d '"')
  FIRST_OS=$(echo "$JSON_OUTPUT" | grep -o '"com\.apple\.CoreSimulator\.SimRuntime\.[^"]*"' | head -1 | sed 's/.*iOS-//' | sed 's/"//' | sed 's/-/./g')

  SELECTED_DEVICE="$FIRST_DEVICE"
  SELECTED_DEVICE_ID="$FIRST_DEVICE_ID"
  SELECTED_OS="$FIRST_OS"
fi

echo ""
echo -e "${GREEN}🎯 已选择模拟器：${NC}"
echo -e "   设备: ${BLUE}$SELECTED_DEVICE${NC}"
echo -e "   iOS 版本: ${BLUE}$SELECTED_OS${NC}"
echo -e "   设备 ID: ${BLUE}$SELECTED_DEVICE_ID${NC}"
echo ""

# 构建项目
echo -e "${BLUE}═════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  🔨 开始构建 NekoPlayer${NC}"
echo -e "${BLUE}═════════════════════════════════════════════════════════${NC}"
echo ""

xcodebuild -project NekoPlayer.xcodeproj \
    -scheme "NekoPlayer (iOS)" \
    -configuration Debug \
    -sdk iphonesimulator \
    -destination "platform=iOS Simulator,id=$SELECTED_DEVICE_ID" \
    clean build \
    CODE_SIGNING_ALLOWED=NO

BUILD_STATUS=$?

echo ""
echo -e "${BLUE}═════════════════════════════════════════════════════════${NC}"

if [ $BUILD_STATUS -eq 0 ]; then
    echo -e "${GREEN}  ✅ 构建成功！${NC}"
    echo -e "${GREEN}═════════════════════════════════════════════════════════${NC}"
    exit 0
else
    echo -e "${RED}  ❌ 构建失败${NC}"
    echo -e "${RED}═════════════════════════════════════════════════════════${NC}"
    exit 1
fi

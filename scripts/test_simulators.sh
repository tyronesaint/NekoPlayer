#!/bin/bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  🔍 模拟器自动选择测试${NC}"
echo -e "${BLUE}═════════════════════════════════════════════════════════${NC}"
echo ""

# 检查是否有 xcrun 命令
if ! command -v xcrun &> /dev/null; then
    echo -e "${RED}❌ 错误：未找到 xcrun 命令${NC}"
    echo -e "${YELLOW}💡 此脚本需要在 macOS 环境下运行${NC}"
    echo -e "${YELLOW}💡 GitHub Actions 会在 macOS runner 上自动运行${NC}"
    exit 0
fi

# iOS 模拟器选择
echo -e "${BLUE}📱 iOS 模拟器选择${NC}"
echo -e "${BLUE}──────────────────────────────────────────────────────────${NC}"

# 使用 JSON 格式获取模拟器信息
JSON_OUTPUT=$(xcrun simctl list devices available iOS --json)

echo -e "${BLUE}🔍 JSON 输出预览：${NC}"
echo "$JSON_OUTPUT" | head -c 500
echo ""
echo ""

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

# iOS 版本优先级
OS_VERSIONS=(
  "iOS-18-0" "iOS-17-5" "iOS-17-4" "iOS-17-3" "iOS-17-2" "iOS-17-1" "iOS-17-0"
  "iOS-16-7" "iOS-16-6" "iOS-16-5" "iOS-16-4" "iOS-16-3" "iOS-16-2" "iOS-16-1" "iOS-16-0"
  "iOS-15-7" "iOS-15-6" "iOS-15-5" "iOS-15-4" "iOS-15-3" "iOS-15-2" "iOS-15-1" "iOS-15-0"
)

SELECTED_DEVICE=""
SELECTED_DEVICE_ID=""
SELECTED_OS=""

for device in "${DEVICES[@]}"; do
  for os_version in "${OS_VERSIONS[@]}"; do
    DEVICE_ID=$(echo "$JSON_OUTPUT" | grep -o "\"$os_version\".*\"$device\"[^,}]*" | grep -o "\"[A-F0-9-]\{36\}\"" | head -1 | tr -d '"')

    if [ ! -z "$DEVICE_ID" ]; then
      SELECTED_DEVICE="$device"
      SELECTED_DEVICE_ID="$DEVICE_ID"
      SELECTED_OS=$(echo "$os_version" | sed 's/iOS-//' | sed 's/-/./g')
      break 2
    fi
  done
done

if [ -z "$SELECTED_DEVICE_ID" ]; then
  echo -e "${YELLOW}⚠️  优先级设备未找到，使用第一个可用设备${NC}"
  FIRST_DEVICE=$(echo "$JSON_OUTPUT" | grep -o '"[^"]*"' | grep -E "iPhone [0-9]+" | head -1 | tr -d '"')
  FIRST_DEVICE_ID=$(echo "$JSON_OUTPUT" | grep -o '"[A-F0-9-]\{36\}"' | head -1 | tr -d '"')
  FIRST_OS=$(echo "$JSON_OUTPUT" | grep -o '"com\.apple\.CoreSimulator\.SimRuntime\.[^"]*"' | head -1 | sed 's/.*iOS-//' | sed 's/"//' | sed 's/-/./g')

  SELECTED_DEVICE="$FIRST_DEVICE"
  SELECTED_DEVICE_ID="$FIRST_DEVICE_ID"
  SELECTED_OS="$FIRST_OS"
fi

echo -e "${GREEN}✅ 已选择 iOS 模拟器：${NC}"
echo -e "   设备: ${BLUE}$SELECTED_DEVICE${NC}"
echo -e "   iOS 版本: ${BLUE}$SELECTED_OS${NC}"
echo -e "   设备 ID: ${BLUE}$SELECTED_DEVICE_ID${NC}"
echo ""

# tvOS 模拟器选择
echo -e "${BLUE}📺 tvOS 模拟器选择${NC}"
echo -e "${BLUE}──────────────────────────────────────────────────────────${NC}"

# 使用 JSON 格式获取 tvOS 模拟器信息
JSON_OUTPUT_TVOS=$(xcrun simctl list devices available tvOS --json)

echo -e "${BLUE}🔍 JSON 输出预览：${NC}"
echo "$JSON_OUTPUT_TVOS" | head -c 500
echo ""
echo ""

# tvOS 设备优先级
TVOS_DEVICES=(
  "Apple TV"
  "Apple TV 4K (3rd generation)"
  "Apple TV 4K (2nd generation)"
)

# tvOS 版本优先级
TVOS_OS_VERSIONS=(
  "tvOS-18-0" "tvOS-17-5" "tvOS-17-4" "tvOS-17-3" "tvOS-17-2" "tvOS-17-1" "tvOS-17-0"
  "tvOS-16-7" "tvOS-16-6" "tvOS-16-5" "tvOS-16-4" "tvOS-16-3" "tvOS-16-2" "tvOS-16-1" "tvOS-16-0"
  "tvOS-15-7" "tvOS-15-6" "tvOS-15-5" "tvOS-15-4" "tvOS-15-3" "tvOS-15-2" "tvOS-15-1" "tvOS-15-0"
)

SELECTED_TVOS_DEVICE=""
SELECTED_TVOS_DEVICE_ID=""
SELECTED_TVOS_OS=""

for device in "${TVOS_DEVICES[@]}"; do
  for os_version in "${TVOS_OS_VERSIONS[@]}"; do
    DEVICE_ID=$(echo "$JSON_OUTPUT_TVOS" | grep -o "\"$os_version\".*\"$device\"[^,}]*" | grep -o "\"[A-F0-9-]\{36\}\"" | head -1 | tr -d '"')

    if [ ! -z "$DEVICE_ID" ]; then
      SELECTED_TVOS_DEVICE="$device"
      SELECTED_TVOS_DEVICE_ID="$DEVICE_ID"
      SELECTED_TVOS_OS=$(echo "$os_version" | sed 's/tvOS-//' | sed 's/-/./g')
      break 2
    fi
  done
done

if [ -z "$SELECTED_TVOS_DEVICE_ID" ]; then
  echo -e "${YELLOW}⚠️  优先级设备未找到，使用第一个可用设备${NC}"
  FIRST_DEVICE=$(echo "$JSON_OUTPUT_TVOS" | grep -o '"[^"]*"' | grep -E "Apple TV" | head -1 | tr -d '"')
  FIRST_DEVICE_ID=$(echo "$JSON_OUTPUT_TVOS" | grep -o '"[A-F0-9-]\{36\}"' | head -1 | tr -d '"')
  FIRST_OS=$(echo "$JSON_OUTPUT_TVOS" | grep -o '"com\.apple\.CoreSimulator\.SimRuntime\.[^"]*"' | head -1 | sed 's/.*tvOS-//' | sed 's/"//' | sed 's/-/./g')

  SELECTED_TVOS_DEVICE="$FIRST_DEVICE"
  SELECTED_TVOS_DEVICE_ID="$FIRST_DEVICE_ID"
  SELECTED_TVOS_OS="$FIRST_OS"
fi

echo -e "${GREEN}✅ 已选择 tvOS 模拟器：${NC}"
echo -e "   设备: ${BLUE}$SELECTED_TVOS_DEVICE${NC}"
echo -e "   tvOS 版本: ${BLUE}$SELECTED_TVOS_OS${NC}"
echo -e "   设备 ID: ${BLUE}$SELECTED_TVOS_DEVICE_ID${NC}"
echo ""

echo -e "${BLUE}═════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ 模拟器选择完成${NC}"
echo -e "${BLUE}═════════════════════════════════════════════════════════${NC}"
echo ""

# 输出可以直接使用的构建命令
echo -e "${YELLOW}💡 iOS 构建命令：${NC}"
echo -e "${NC}xcodebuild -project NekoPlayer.xcodeproj \\"
echo -e "${NC}  -scheme \"NekoPlayer (iOS)\" \\"
echo -e "${NC}  -configuration Debug \\"
echo -e "${NC}  -sdk iphonesimulator \\"
echo -e "${NC}  -destination \"platform=iOS Simulator,id=$SELECTED_DEVICE_ID\" \\"
echo -e "${NC}  clean build \\"
echo -e "${NC}  CODE_SIGNING_ALLOWED=NO"
echo ""

echo -e "${YELLOW}💡 tvOS 构建命令：${NC}"
echo -e "${NC}xcodebuild -project NekoPlayer.xcodeproj \\"
echo -e "${NC}  -scheme \"NekoPlayer (tvOS)\" \\"
echo -e "${NC}  -configuration Debug \\"
echo -e "${NC}  -sdk appletvsimulator \\"
echo -e "${NC}  -destination \"platform=tvOS Simulator,id=$SELECTED_TVOS_DEVICE_ID\" \\"
echo -e "${NC}  clean build \\"
echo -e "${NC}  CODE_SIGNING_ALLOWED=NO"

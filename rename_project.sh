#!/bin/bash

# NekoPlayer 重命名脚本
# 将所有 Anime4KMetal 引用改为 NekoPlayer

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🔧 NekoPlayer 重命名脚本${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""

# 检查目录
if [ ! -f "Anime4KMetal.xcodeproj/project.pbxproj" ]; then
    echo -e "${RED}❌ 错误: 请在 NekoPlayer 项目根目录运行此脚本${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 将要修改的内容:${NC}"
echo "  1. Xcode 项目文件 (project.pbxproj)"
echo "  2. Scheme 配置文件"
echo "  3. Info.plist 文件"
echo "  4. 应用名称"
echo "  5. Bundle ID"
echo ""

read -p "确认继续? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo -e "${RED}❌ 操作已取消${NC}"
    exit 0
fi

echo ""
echo -e "${YELLOW}🔧 开始修改...${NC}"
echo ""

# 1. 修改 Xcode 项目文件
echo -e "${YELLOW}[1/5] 修改 Xcode 项目文件...${NC}"
sed -i.bak 's/Anime4KMetal/NekoPlayer/g' "Anime4KMetal.xcodeproj/project.pbxproj"
echo -e "${GREEN}✅ 完成${NC}"

# 2. 修改 Scheme 文件
echo -e "${YELLOW}[2/5] 修改 Scheme 文件...${NC}"
find "Anime4KMetal.xcodeproj/xcshareddata/xcschemes" -name "*.xcscheme" -type f -exec sed -i.bak 's/Anime4KMetal/NekoPlayer/g' {} \;
echo -e "${GREEN}✅ 完成${NC}"

# 3. 修改 Info.plist
echo -e "${YELLOW}[3/5] 修改 Info.plist 文件...${NC}"
for plist in Anime4KMetal--*.plist; do
    if [ -f "$plist" ]; then
        sed -i.bak 's/Anime4KMetal/NekoPlayer/g' "$plist"
        # 重命名文件
        newname=$(echo "$plist" | sed 's/Anime4KMetal/NekoPlayer/')
        mv "$plist" "$newname"
        echo -e "${GREEN}  ✓ 重命名: $plist → $newname${NC}"
    fi
done
echo -e "${GREEN}✅ 完成${NC}"

# 4. 修改权限文件
echo -e "${YELLOW}[4/5] 修改权限文件...${NC}"
for entitlement in Anime4KMetal*.entitlements; do
    if [ -f "$entitlement" ]; then
        sed -i.bak 's/Anime4KMetal/NekoPlayer/g' "$entitlement"
        newname=$(echo "$entitlement" | sed 's/Anime4KMetal/NekoPlayer/')
        mv "$entitlement" "$newname"
        echo -e "${GREEN}  ✓ 重命名: $entitlement → $newname${NC}"
    fi
done
echo -e "${GREEN}✅ 完成${NC}"

# 5. 删除备份文件
echo -e "${YELLOW}[5/5] 清理备份文件...${NC}"
find . -name "*.bak" -delete
echo -e "${GREEN}✅ 完成${NC}"

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ 重命名完成！${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}📝 修改摘要:${NC}"
echo "  ✅ 项目文件已更新"
echo "  ✅ Scheme 已重命名"
echo "  ✅ Info.plist 已更新"
echo "  ✅ 权限文件已更新"
echo ""

echo -e "${YELLOW}⚠️  下一步:${NC}"
echo "  1. 打开 Xcode 项目检查配置"
echo "  2. 重新构建项目"
echo "  3. 更新 GitHub Actions 配置"
echo ""

echo -e "${GREEN}🎉 现在项目名称已经是 NekoPlayer 了！${NC}"
echo ""

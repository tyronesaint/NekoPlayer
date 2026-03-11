#!/bin/bash

# NekoPlayer GitHub Repository Setup Script

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🐱 NekoPlayer - GitHub Setup${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""

# Check if we're in the correct directory
if [ ! -f "README.md" ] || [ ! -f "Shared/Anime4K.swift" ]; then
    echo -e "${RED}❌ Error: Please run this script from the NekoPlayer directory${NC}"
    exit 1
fi

# Remove old git history
echo -e "${YELLOW}🧹 Removing old git history...${NC}"
rm -rf .git

# Initialize new git repository
echo -e "${YELLOW}🔧 Initializing git repository...${NC}"
git init

# Ask for GitHub information
read -p "请输入 GitHub 用户名: " GITHUB_USERNAME
if [ -z "$GITHUB_USERNAME" ]; then
    echo -e "${RED}❌ Error: GitHub username is required${NC}"
    exit 1
fi

read -p "请输入仓库名称 (默认: NekoPlayer): " REPO_NAME
REPO_NAME=${REPO_NAME:-NekoPlayer}

echo ""
echo -e "${YELLOW}📋 Configuration:${NC}"
echo -e "  Username: $GITHUB_USERNAME"
echo -e "  Repository: $REPO_NAME"
echo ""

read -p "确认继续? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo -e "${RED}❌ 操作已取消${NC}"
    exit 0
fi

# Create .gitignore
echo -e "${YELLOW}📝 Creating .gitignore...${NC}"
cat > .gitignore << 'EOF'
# Xcode
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
!*.xcodeproj/xcshareddata/
!*.xcworkspace/contents.xcworkspacedata
*.xcworkspace/*
!*.xcworkspace/xcshareddata/
build/
DerivedData/
*.moved-aside
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3

# macOS
.DS_Store
.AppleDouble
.LSOverride

# Temporary files
*~
*.swp
*.tmp
*.temp

# Build artifacts
*.app
*.dSYM.zip
*.dSYM
*.ipa

# Logs
*.log

# Anime4K shaders (optional)
# Uncomment if you want to ignore shader changes
# Anime4K/

# Backups
*.bak
*.backup

# Submodules
# Anime4K/ (keep it, it's a git submodule)

EOF

# Add all files
echo -e "${YELLOW}📦 Adding files to git...${NC}"
git add .

# Create initial commit
echo -e "${YELLOW}💾 Creating initial commit...${NC}"
git commit -m "Initial commit: NekoPlayer

Features:
- Anime4K Metal shader support
- WebDAV integration for remote playback
- Multi-platform support (iOS/macOS/tvOS)
- Neko theme design

Based on Anime4KMetal with WebDAV enhancements
"

# Add remote repository
GITHUB_REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
echo -e "${YELLOW}🔗 Adding remote repository...${NC}"
git remote add origin "$GITHUB_REPO_URL"

# Instructions for creating GitHub repository
echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}⚠️  重要提示${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════${NC}"
echo ""
echo "在执行下一步之前，请先在 GitHub 上创建仓库："
echo ""
echo "1. 访问: https://github.com/new"
echo "2. 仓库名称: $REPO_NAME"
echo "3. 描述: 🐱 Anime video player with WebDAV and Anime4K support"
echo "4. 可见性: Public (推荐)"
echo "5. 初始化选项: 不要勾选任何选项"
echo "6. 点击 'Create repository'"
echo ""
read -p "创建完成后按 Enter 继续..."

# Push to GitHub
echo ""
echo -e "${GREEN}🚀 Pushing to GitHub...${NC}"
git branch -M main
git push -u origin main

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Repository setup complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "📍 Repository URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo -e "🔗 Actions: https://github.com/$GITHUB_USERNAME/$REPO_NAME/actions"
echo ""
echo -e "📝 Next steps:"
echo "1. Visit your repository: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "2. Check Actions status"
echo "3. Download build artifacts when ready"
echo "4. Start adding new features!"
echo ""
echo -e "🎉 NekoPlayer is now live on GitHub!${NC}"
echo ""

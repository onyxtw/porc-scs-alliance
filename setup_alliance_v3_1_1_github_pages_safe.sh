#!/bin/bash
set -e

echo "============================================================"
echo " 🚀 PoRC‑SCS Alliance v3.1.1 — GitHub Pages 安全部署開始"
echo "============================================================"

# Step 1: 確保 site/ 存在
echo "📁 確認 site/ 是否存在於 main 分支..."
if [ ! -d "site" ]; then
    echo "❌ 錯誤：site/ 資料夾不存在於 main 分支。"
    exit 1
fi

# Step 2: 建立或切換到 gh-pages（安全模式）
echo "📁 建立或切換到 gh-pages 分支（安全模式）..."
if git show-ref --verify --quiet refs/heads/gh-pages; then
    git checkout gh-pages
else
    git checkout -b gh-pages
fi

# Step 3: 清理 gh-pages 分支內容（不影響 main）
echo "🧹 清理 gh-pages 分支內容（不影響 main）..."
git rm -r . >/dev/null 2>&1 || true

# Step 4: 部署 site/ 到 gh-pages
echo "📦 部署 site/ 到 gh-pages..."
cp -r site/* .

echo "🔧 Git 提交 v3.1.1 (gh-pages)..."
git add .
git commit -m "deploy: PoRC-SCS Alliance v3.1.1 – Safe GitHub Pages deployment"
git push origin gh-pages --force

# Step 5: 設定 GitHub Pages
echo "🌐 設定 GitHub Pages..."
gh api \
  -X PUT \
  "repos/onyxtw/porc-scs-alliance/pages" \
  -F "source.branch=gh-pages" \
  -F "source.path=/"

# Step 6: 回到 main 分支並建立 tag + release
git checkout main

echo "🏷 建立 v3.1.1 tag..."
git tag -a v3.1.1 -m "PoRC-SCS Alliance v3.1.1 – Safe GitHub Pages Deployment"
git push origin v3.1.1

echo "📦 建立 GitHub Release..."
gh release create v3.1.1 --title "PoRC-SCS Alliance v3.1.1" --notes "
# PoRC-SCS Alliance v3.1.1 – Safe GitHub Pages Deployment

Safely deploys the PoRC‑SCS Alliance website to GitHub Pages without deleting
any local files or using orphan branches.
"

echo "============================================================"
echo " 🎉 PoRC‑SCS Alliance v3.1.1 GitHub Pages 已安全部署完成！"
echo "============================================================"
echo "🌐 網站網址：https://onyxtw.github.io/porc-scs-alliance/"

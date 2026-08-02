#!/bin/bash
set -e

echo "============================================================"
echo " 🚀 PoRC‑SCS Alliance v3.1.0 — GitHub Pages 自動部署開始（修正版）"
echo "============================================================"

# ------------------------------------------------------------
# Step 1: 確保 site/ 在 main 分支存在
# ------------------------------------------------------------
echo "📁 確認 site/ 是否存在於 main 分支..."

if [ ! -d "site" ]; then
    echo "❌ 錯誤：site/ 資料夾不存在於 main 分支。"
    echo "請先執行 v3.0.0 官方網站生成器。"
    exit 1
fi

# ------------------------------------------------------------
# Step 2: 建立暫存部署資料夾
# ------------------------------------------------------------
echo "📦 建立暫存部署資料夾 temp_site/..."
rm -rf temp_site
mkdir temp_site
cp -r site/* temp_site/

# ------------------------------------------------------------
# Step 3: 建立 gh-pages 分支
# ------------------------------------------------------------
echo "📁 建立 gh-pages 分支（若不存在）..."

if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "🔄 gh-pages 已存在，切換分支..."
    git checkout gh-pages
else
    echo "✨ 建立 gh-pages 分支..."
    git checkout --orphan gh-pages
    rm -rf *
fi

# ------------------------------------------------------------
# Step 4: 部署 temp_site 到 gh-pages
# ------------------------------------------------------------
echo "📦 部署 temp_site 到 gh-pages..."

cp -r ../porc-scs-alliance/temp_site/* .
rm -rf ../porc-scs-alliance/temp_site

echo "🔧 Git 提交 v3.1.0 (gh-pages)..."
git add .
git commit -m "deploy: PoRC-SCS Alliance v3.1.0 – GitHub Pages deployment"
git push origin gh-pages --force

# ------------------------------------------------------------
# Step 5: 設定 GitHub Pages
# ------------------------------------------------------------
echo "🌐 設定 GitHub Pages..."

gh api \
  -X PUT \
  "repos/onyxtw/porc-scs-alliance/pages" \
  -F "source.branch=gh-pages" \
  -F "source.path=/"

# ------------------------------------------------------------
# Step 6: 回到 main 分支並建立 tag + release
# ------------------------------------------------------------
git checkout main

echo "🏷 建立 v3.1.0 tag..."
git tag -a v3.1.0 -m "PoRC-SCS Alliance v3.1.0 – GitHub Pages Deployment"
git push origin v3.1.0

echo "📦 建立 GitHub Release..."
gh release create v3.1.0 --title "PoRC-SCS Alliance v3.1.0" --notes "
# PoRC-SCS Alliance v3.1.0 – GitHub Pages Deployment

This version deploys the full PoRC‑SCS Alliance website to GitHub Pages,
including standards, governance, verifier, certification engine, atlas,
negative-carbon registry, and international submission package.
"

echo "============================================================"
echo " 🎉 PoRC‑SCS Alliance v3.1.0 GitHub Pages 已成功部署！"
echo "============================================================"
echo "🌐 網站網址：https://onyxtw.github.io/porc-scs-alliance/"

#!/bin/bash
set -e

echo "============================================================"
echo " 🚀 PoRC‑SCS Alliance v3.2.0 — 官方網站 CSS 美化版開始"
echo "============================================================"

# Step 1: 建立 style.css
echo "🎨 建立 style.css..."

cat << 'FILE_EOF' > site/style.css
/* PoRC‑SCS Alliance v3.2.0 — 主題樣式 */
body {
  font-family: "Noto Sans TC", "Segoe UI", sans-serif;
  background-color: #f9fafb;
  color: #222;
  margin: 0;
  padding: 0;
}
header {
  background-color: #0b3d91;
  color: white;
  padding: 1.2em;
  text-align: center;
  font-size: 1.6em;
  letter-spacing: 0.05em;
}
main {
  max-width: 900px;
  margin: 2em auto;
  padding: 1em;
  background: white;
  box-shadow: 0 0 10px rgba(0,0,0,0.1);
  border-radius: 8px;
}
footer {
  text-align: center;
  color: #666;
  font-size: 0.9em;
  padding: 1em;
}
a {
  color: #0b3d91;
  text-decoration: none;
}
a:hover {
  text-decoration: underline;
}
FILE_EOF

# Step 2: 在所有 HTML 檔案中插入 <link>
echo "🔗 插入 CSS 連結到所有 HTML 頁面..."
for file in site/*.html; do
  sed -i '' 's|<head>|<head>\n<link rel="stylesheet" href="style.css">|' "$file"
done

# Step 3: Git 操作
echo "🔧 Git 提交 v3.2.0..."
git add site/style.css site/*.html
git commit -m "feat: PoRC-SCS Alliance v3.2.0 – Official Website CSS Theme"
git push origin main

echo "🏷 建立 v3.2.0 tag..."
git tag -a v3.2.0 -m "PoRC-SCS Alliance v3.2.0 – Official Website CSS Theme"
git push origin v3.2.0

echo "📦 建立 GitHub Release..."
gh release create v3.2.0 --title "PoRC-SCS Alliance v3.2.0" --notes "
# PoRC-SCS Alliance v3.2.0 – Official Website CSS Theme

Adds official PoRC‑SCS Alliance visual theme with unified typography,
color palette, and layout for all pages.
"

echo "============================================================"
echo " 🎉 PoRC‑SCS Alliance v3.2.0 CSS 美化版已建立並發布！"
echo "============================================================"

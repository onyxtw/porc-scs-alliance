#!/bin/bash
set -e

echo "============================================================"
echo " 🚀 PoRC‑SCS Alliance v3.3.1 — 導覽列＋搜尋引擎（macOS 兼容版）"
echo "============================================================"

# Step 1: 建立 search.js
echo "🔍 建立 search.js..."

cat << 'FILE_EOF' > site/search.js
// PoRC‑SCS Alliance v3.3.1 — Docs Search Engine
document.addEventListener("DOMContentLoaded", () => {
  const searchBox = document.getElementById("searchBox");
  const results = document.getElementById("searchResults");

  if (!searchBox || !results) return;

  searchBox.addEventListener("input", () => {
    const query = searchBox.value.toLowerCase();
    results.innerHTML = "";

    if (query.length < 2) return;

    const pages = [
      { name: "Home", file: "index.html" },
      { name: "Standards", file: "standards.html" },
      { name: "Verifier", file: "verifier.html" },
      { name: "Atlas", file: "atlas.html" },
      { name: "ISO/IEEE", file: "iso_ieee.html" }
    ];

    pages.forEach(p => {
      fetch(p.file)
        .then(r => r.text())
        .then(t => {
          if (t.toLowerCase().includes(query)) {
            const item = document.createElement("div");
            item.innerHTML = \`🔎 <a href="\${p.file}">\${p.name}</a>\`;
            results.appendChild(item);
          }
        });
    });
  });
});
FILE_EOF

# Step 2: 導覽列 HTML
NAVBAR=$(cat << 'HTML'
<nav style="background:#0b3d91;padding:1em;">
<a href="index.html" style="color:white;margin-right:1em;">Home</a>
<a href="standards.html" style="color:white;margin-right:1em;">Standards</a>
<a href="verifier.html" style="color:white;margin-right:1em;">Verifier</a>
<a href="atlas.html" style="color:white;margin-right:1em;">Atlas</a>
<a href="iso_ieee.html" style="color:white;">ISO/IEEE</a>
<input id="searchBox" placeholder="Search..." style="margin-left:2em;padding:0.3em;">
<div id="searchResults" style="background:white;color:black;padding:1em;"></div>
</nav>
HTML
)

# Step 3: 使用 awk 插入導覽列與搜尋引擎
echo "🧩 更新所有 HTML 頁面（使用 awk）..."

for file in site/*.html; do
  awk -v nav="$NAVBAR" '
    /<body>/ {
      print;
      print nav;
      next
    }
    /<\/body>/ {
      print "<script src=\"search.js\"></script>";
      print;
      next
    }
    { print }
  ' "$file" > "$file.tmp"

  mv "$file.tmp" "$file"
done

# Step 4: Git 操作
echo "🔧 Git 提交 v3.3.1..."
git add site/search.js site/*.html
git commit -m "feat: PoRC-SCS Alliance v3.3.1 – macOS-compatible Navbar + Docs Search Engine"
git push origin main

echo "🏷 建立 v3.3.1 tag..."
git tag -a v3.3.1 -m "PoRC-SCS Alliance v3.3.1 – macOS-compatible Navbar + Docs Search Engine"
git push origin v3.3.1

echo "📦 建立 GitHub Release..."
gh release create v3.3.1 --title "PoRC-SCS Alliance v3.3.1" --notes "
# PoRC-SCS Alliance v3.3.1 – macOS-compatible Navbar + Docs Search Engine

Adds full navigation bar and client-side search engine to all pages,
with macOS-compatible HTML injection.
"

echo "============================================================"
echo " 🎉 PoRC‑SCS Alliance v3.3.1 導覽列＋搜尋引擎（macOS 版）已完成！"
echo "============================================================"

#!/bin/bash
set -e

echo "============================================================"
echo " 🚀 PoRC‑SCS Alliance v3.3.2 — 導覽列＋搜尋引擎（macOS 絕對相容版）"
echo "============================================================"

# Step 1: 建立 search.js
echo "🔍 建立 search.js..."

cat << 'FILE_EOF' > site/search.js
// PoRC‑SCS Alliance v3.3.2 — Docs Search Engine
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

# Step 2: 導覽列 HTML（逐行插入）
echo "🧩 更新所有 HTML 頁面（逐行插入方式）..."

for file in site/*.html; do
  tmpfile="${file}.tmp"
  rm -f "$tmpfile"

  while IFS= read -r line; do
    # 插入 navbar
    if echo "$line" | grep -q "<body>"; then
      echo "$line" >> "$tmpfile"
      echo '<nav style="background:#0b3d91;padding:1em;">' >> "$tmpfile"
      echo '<a href="index.html" style="color:white;margin-right:1em;">Home</a>' >> "$tmpfile"
      echo '<a href="standards.html" style="color:white;margin-right:1em;">Standards</a>' >> "$tmpfile"
      echo '<a href="verifier.html" style="color:white;margin-right:1em;">Verifier</a>' >> "$tmpfile"
      echo '<a href="atlas.html" style="color:white;margin-right:1em;">Atlas</a>' >> "$tmpfile"
      echo '<a href="iso_ieee.html" style="color:white;">ISO/IEEE</a>' >> "$tmpfile"
      echo '<input id="searchBox" placeholder="Search..." style="margin-left:2em;padding:0.3em;">' >> "$tmpfile"
      echo '<div id="searchResults" style="background:white;color:black;padding:1em;"></div>' >> "$tmpfile"
      echo '</nav>' >> "$tmpfile"
      continue
    fi

    # 插入 search.js
    if echo "$line" | grep -q "</body>"; then
      echo '<script src="search.js"></script>' >> "$tmpfile"
      echo "$line" >> "$tmpfile"
      continue
    fi

    echo "$line" >> "$tmpfile"
  done < "$file"

  mv "$tmpfile" "$file"
done

# Step 3: Git 操作
echo "🔧 Git 提交 v3.3.2..."
git add site/search.js site/*.html
git commit -m "feat: PoRC-SCS Alliance v3.3.2 – macOS-safe Navbar + Docs Search Engine"
git push origin main

echo "🏷 建立 v3.3.2 tag..."
git tag -a v3.3.2 -m "PoRC-SCS Alliance v3.3.2 – macOS-safe Navbar + Docs Search Engine"
git push origin v3.3.2

echo "📦 建立 GitHub Release..."
gh release create v3.3.2 --title "PoRC-SCS Alliance v3.3.2" --notes "
# PoRC-SCS Alliance v3.3.2 – macOS-safe Navbar + Docs Search Engine

Adds full navigation bar and client-side search engine to all pages,
using a macOS-safe line-by-line HTML injection method.
"

echo "============================================================"
echo " 🎉 PoRC‑SCS Alliance v3.3.2 導覽列＋搜尋引擎（macOS 絕對相容版）已完成！"
echo "============================================================"

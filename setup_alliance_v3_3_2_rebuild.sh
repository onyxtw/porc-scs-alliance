#!/bin/bash
set -e

echo "============================================================"
echo " 🚀 Rebuilding PoRC‑SCS Alliance v3.3.2 — Full Website"
echo "============================================================"

mkdir -p site

echo "📄 建立 style.css..."
cat << 'CSS' > site/style.css
body {
  font-family: Arial, sans-serif;
  margin: 0;
  background: #f5f5f5;
}
nav {
  background: #0b3d91;
  padding: 1em;
}
nav a {
  color: white;
  margin-right: 1em;
  text-decoration: none;
}
.container {
  background: white;
  padding: 2em;
  margin: 2em auto;
  width: 80%;
  border-radius: 8px;
}
CSS

echo "📄 建立 search.js..."
cat << 'JS' > site/search.js
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
JS

echo "📄 建立 HTML 頁面..."

create_page() {
cat << HTML > $1
<html>
<head>
<title>PoRC‑SCS Alliance</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<nav>
<a href="index.html">Home</a>
<a href="standards.html">Standards</a>
<a href="verifier.html">Verifier</a>
<a href="atlas.html">Atlas</a>
<a href="iso_ieee.html">ISO/IEEE</a>
<input id="searchBox" placeholder="Search..." style="margin-left:2em;padding:0.3em;">
<div id="searchResults" style="background:white;color:black;padding:1em;"></div>
</nav>

<div class="container">
<h1>$2</h1>
<p>$3</p>
</div>

<script src="search.js"></script>
</body>
</html>
HTML
}

create_page index.html "PoRC‑SCS Alliance" "Official sovereign compute standard."
create_page standards.html "Standards" "PoRC‑SCS Alliance Standards Documentation."
create_page verifier.html "Verifier" "Verification Engine Overview."
create_page atlas.html "Atlas" "Global Sovereign Compute Atlas."
create_page iso_ieee.html "ISO/IEEE" "International Standards Alignment."

echo "🔧 Git 提交..."
git add .
git commit -m "rebuild: PoRC-SCS Alliance v3.3.2 full website"
git push origin main

echo "============================================================"
echo " 🎉 v3.3.2 重建完成！請切換到 gh-pages 並部署"
echo "============================================================"

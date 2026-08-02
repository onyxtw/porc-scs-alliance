#!/bin/bash
set -e

echo "============================================================"
echo " 🚀 PoRC‑SCS Alliance v4.0.0 — Interactive Website"
echo "============================================================"

mkdir -p site

echo "📄 建立 api-index.json..."
cat << 'JSON' > site/api-index.json
{
  "standards": [
    { "title": "PoRC‑SCS Standard", "file": "STANDARD.md", "url": "https://github.com/onyxtw/porc-scs-alliance/blob/main/STANDARD.md" },
    { "title": "Certification Policy", "file": "CERT_POLICY.md", "url": "https://github.com/onyxtw/porc-scs-alliance/blob/main/CERT_POLICY.md" },
    { "title": "Verifier Overview", "file": "VERIFIER_OVERVIEW.md", "url": "https://github.com/onyxtw/porc-scs-alliance/blob/main/VERIFIER_OVERVIEW.md" },
    { "title": "Atlas Overview", "file": "ATLAS_OVERVIEW.md", "url": "https://github.com/onyxtw/porc-scs-alliance/blob/main/ATLAS_OVERVIEW.md" },
    { "title": "Global Policy Framework", "file": "GLOBAL_POLICY_FRAMEWORK.md", "url": "https://github.com/onyxtw/porc-scs-alliance/blob/main/GLOBAL_POLICY_FRAMEWORK.md" }
  ],
  "nodes": [
    { "title": "Global Nodes", "file": "GLOBAL_NODES.md", "url": "https://github.com/onyxtw/porc-scs-alliance/blob/main/GLOBAL_NODES.md" },
    { "title": "Node Energy Profile", "file": "NODE_ENERGY_PROFILE.md", "url": "https://github.com/onyxtw/porc-scs-alliance/blob/main/NODE_ENERGY_PROFILE.md" }
  ],
  "governance": [
    { "title": "Sovereign Governance", "file": "SOVEREIGN_GOVERNANCE.md", "url": "https://github.com/onyxtw/porc-scs-alliance/blob/main/SOVEREIGN_GOVERNANCE.md" },
    { "title": "Governance", "file": "GOVERNANCE.md", "url": "https://github.com/onyxtw/porc-scs-alliance/blob/main/GOVERNANCE.md" }
  ]
}
JSON

echo "📄 建立 search_v4.js..."
cat << 'JS' > site/search_v4.js
document.addEventListener("DOMContentLoaded", () => {
  const searchBox = document.getElementById("searchBox");
  const results = document.getElementById("searchResults");
  if (!searchBox || !results) return;

  let apiIndex = null;

  fetch("api-index.json")
    .then(r => r.json())
    .then(j => { apiIndex = j; })
    .catch(() => { apiIndex = null; });

  const localPages = [
    { name: "Home", file: "index.html" },
    { name: "Standards", file: "standards.html" },
    { name: "Verifier", file: "verifier.html" },
    { name: "Atlas", file: "atlas.html" },
    { name: "ISO/IEEE", file: "iso_ieee.html" }
  ];

  searchBox.addEventListener("input", () => {
    const q = searchBox.value.trim().toLowerCase();
    results.innerHTML = "";
    if (q.length < 2) return;

    const section = document.createElement("div");
    section.style.padding = "1em";
    section.style.background = "white";

    const addItem = (label, url) => {
      const div = document.createElement("div");
      div.innerHTML = `🔎 <a href="${url}" target="_blank">${label}</a>`;
      section.appendChild(div);
    };

    // 本地頁面搜尋
    localPages.forEach(p => {
      fetch(p.file)
        .then(r => r.text())
        .then(t => {
          if (t.toLowerCase().includes(q)) {
            addItem(`Page: ${p.name}`, p.file);
          }
        })
        .catch(() => {});
    });

    // API 索引搜尋（標準文件）
    if (apiIndex) {
      Object.keys(apiIndex).forEach(group => {
        apiIndex[group].forEach(item => {
          const label = `${group.toUpperCase()}: ${item.title}`;
          if (label.toLowerCase().includes(q)) {
            addItem(label, item.url);
          }
        });
      });
    }

    results.appendChild(section);
  });
});
JS

echo "📄 更新 HTML 模板為 v4.0.0 互動版..."

create_page() {
cat << HTML > $1
<html>
<head>
<title>PoRC‑SCS Alliance — $2</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<nav>
<a href="index.html">Home</a>
<a href="standards.html">Standards</a>
<a href="verifier.html">Verifier</a>
<a href="atlas.html">Atlas</a>
<a href="iso_ieee.html">ISO/IEEE</a>
<input id="searchBox" placeholder="Search standards, nodes, governance..." style="margin-left:2em;padding:0.3em;width:320px;">
<div id="searchResults" style="background:white;color:black;padding:1em;"></div>
</nav>

<div class="container">
$3
</div>

<script src="search_v4.js"></script>
</body>
</html>
HTML
}

create_page index.html "Home" "<h1>PoRC‑SCS Alliance</h1><p>Interactive sovereign compute standard index (v4.0.0).</p>"
create_page standards.html "Standards" "<h1>Standards</h1><p>Browse and search PoRC‑SCS Alliance standards and certification policies.</p>"
create_page verifier.html "Verifier" "<h1>Verifier Engine</h1><p>Interactive overview of the PoRC‑SCS Verifier and certification flow.</p>"
create_page atlas.html "Atlas" "<h1>Global Atlas</h1><p>Explore global nodes, tiers, and energy profiles with integrated search.</p>"
create_page iso_ieee.html "ISO/IEEE Integration" "<h1>ISO/IEEE Integration Framework</h1><p>Aligned with ISO/IEC and IEEE standards; searchable via the global index.</p>"

echo "🔧 Git 提交 v4.0.0..."
git add .
git commit -m "release: PoRC-SCS Alliance v4.0.0 interactive website"
git push origin main

echo "============================================================"
echo " ✅ v4.0.0 已在 main 建立，請部署到 gh-pages"
echo "============================================================"

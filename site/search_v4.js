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

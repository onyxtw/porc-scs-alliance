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

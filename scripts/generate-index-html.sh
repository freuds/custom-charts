#!/usr/bin/env bash
# Génère la page d'accueil du repo Helm (docs/index.html) à partir de
# docs/index.yaml, en ne gardant que la dernière version de chaque chart.
#
# Usage : scripts/generate-index-html.sh [index.yaml] [index.html]
set -euo pipefail

INDEX_YAML="${1:-docs/index.yaml}"
OUTPUT="${2:-docs/index.html}"
REPO_URL="https://freuds.github.io/custom-charts"
REPO_NAME="custom-charts"

command -v yq >/dev/null || { echo "yq est requis" >&2; exit 1; }
[ -f "$INDEX_YAML" ] || { echo "Fichier introuvable : $INDEX_YAML" >&2; exit 1; }

# Échappe les caractères spéciaux HTML (valeurs issues des Chart.yaml).
esc() {
  printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' \
    -e 's/"/\&quot;/g' -e "s/'/\&#39;/g"
}

# N'autorise que les URLs http(s) dans les attributs href/src.
safe_url() {
  case "$1" in
    http://*|https://*) esc "$1" ;;
    *) printf '' ;;
  esac
}

generated=$(yq -r '.generated // ""' "$INDEX_YAML" | cut -c1-10)
chart_count=$(yq -r '.entries | length' "$INDEX_YAML")

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

cat > "$tmp" <<EOF
<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>custom-charts</title>
<meta name="description" content="Repo Helm custom-charts : ${chart_count} charts disponibles.">
<style>
  :root {
    --bg: #f6f7f9; --card: #ffffff; --text: #1d2330; --muted: #5d6676;
    --border: #e2e5ea; --accent: #0f62d6; --code-bg: #eef1f5; --badge-bg: #e6eefb;
  }
  @media (prefers-color-scheme: dark) {
    :root {
      --bg: #11141a; --card: #1a1e26; --text: #e6e9ef; --muted: #9aa3b2;
      --border: #2a303b; --accent: #6ea8ff; --code-bg: #232833; --badge-bg: #1f2c44;
    }
  }
  * { box-sizing: border-box; }
  body {
    margin: 0; background: var(--bg); color: var(--text);
    font: 15px/1.5 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  }
  main { max-width: 1080px; margin: 0 auto; padding: 32px 16px 48px; }
  h1 { margin: 0 0 4px; font-size: 28px; }
  .subtitle { margin: 0 0 24px; color: var(--muted); }
  a { color: var(--accent); text-decoration: none; }
  a:hover { text-decoration: underline; }
  .cmd {
    display: flex; align-items: center; gap: 8px; background: var(--code-bg);
    border: 1px solid var(--border); border-radius: 8px; padding: 8px 10px;
  }
  .cmd code {
    flex: 1; min-width: 0; overflow-wrap: anywhere;
    font: 13px/1.4 ui-monospace, SFMono-Regular, Menlo, monospace;
  }
  .cmd button {
    flex: none; border: 1px solid var(--border); background: var(--card); color: var(--text);
    border-radius: 6px; padding: 2px 8px; font-size: 12px; cursor: pointer;
  }
  .setup { margin-bottom: 32px; }
  .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(min(320px, 100%), 1fr)); gap: 16px; }
  .card {
    display: flex; flex-direction: column; gap: 12px; background: var(--card);
    border: 1px solid var(--border); border-radius: 12px; padding: 16px; min-width: 0;
  }
  .head { display: flex; align-items: center; gap: 12px; }
  .icon {
    width: 40px; height: 40px; flex: none; border-radius: 8px; object-fit: contain;
    background: #ffffff; border: 1px solid var(--border); padding: 4px;
  }
  .icon.fallback {
    display: flex; align-items: center; justify-content: center;
    font-weight: 600; color: var(--accent); text-transform: uppercase;
  }
  .head h2 { margin: 0; font-size: 17px; overflow-wrap: anywhere; }
  .badges { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 2px; }
  .badge {
    font-size: 12px; padding: 1px 8px; border-radius: 999px;
    background: var(--badge-bg); color: var(--accent);
  }
  .badge.app { background: var(--code-bg); color: var(--muted); }
  .desc { margin: 0; color: var(--muted); flex: 1; }
  .links { display: flex; flex-wrap: wrap; gap: 14px; font-size: 13px; }
  footer { margin-top: 32px; color: var(--muted); font-size: 13px; }
</style>
</head>
<body>
<main>
  <h1>custom-charts</h1>
  <p class="subtitle">Repo Helm : ${chart_count} charts disponibles</p>

  <section class="setup">
    <div class="cmd"><code>helm repo add ${REPO_NAME} ${REPO_URL} &amp;&amp; helm repo update</code><button type="button">Copier</button></div>
  </section>

  <section class="grid">
EOF

# Une ligne TSV par chart (dernière version = premier élément de la liste).
yq -r '.entries | to_entries | .[] | [
    .key,
    .value[0].version // "",
    .value[0].appVersion // "",
    .value[0].description // "",
    .value[0].icon // "",
    .value[0].urls[0] // "",
    .value[0].home // "",
    (.value[0].sources // [] | .[0] // "")
  ] | @tsv' "$INDEX_YAML" |
while IFS=$'\t' read -r name version app desc icon url home source; do
  n=$(esc "$name"); v=$(esc "$version"); a=$(esc "$app"); d=$(esc "$desc")
  icon_url=$(safe_url "$icon"); dl=$(safe_url "$url")
  home_url=$(safe_url "$home"); src_url=$(safe_url "$source")

  {
    echo '    <article class="card">'
    echo '      <div class="head">'
    if [ -n "$icon_url" ]; then
      echo "        <img class=\"icon\" src=\"${icon_url}\" alt=\"\" loading=\"lazy\" data-initial=\"${n:0:1}\">"
    else
      echo "        <div class=\"icon fallback\" aria-hidden=\"true\">${n:0:1}</div>"
    fi
    echo '        <div>'
    echo "          <h2>${n}</h2>"
    echo '          <div class="badges">'
    echo "            <span class=\"badge\">v${v}</span>"
    [ -n "$a" ] && echo "            <span class=\"badge app\">app ${a}</span>"
    echo '          </div>'
    echo '        </div>'
    echo '      </div>'
    echo "      <p class=\"desc\">${d}</p>"
    echo "      <div class=\"cmd\"><code>helm install ${n} ${REPO_NAME}/${n} --version ${v}</code><button type=\"button\">Copier</button></div>"
    echo '      <div class="links">'
    [ -n "$dl" ] && echo "        <a href=\"${dl}\">Télécharger .tgz</a>"
    [ -n "$home_url" ] && echo "        <a href=\"${home_url}\">Home</a>"
    [ -n "$src_url" ] && [ "$src_url" != "$home_url" ] && echo "        <a href=\"${src_url}\">Sources</a>"
    echo '      </div>'
    echo '    </article>'
  } >> "$tmp"
done

cat >> "$tmp" <<EOF
  </section>

  <footer>
    Index : <a href="index.yaml">index.yaml</a>${generated:+ · généré le ${generated}}
  </footer>
</main>
<script>
  document.querySelectorAll(".cmd button").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var text = btn.previousElementSibling.textContent;
      navigator.clipboard.writeText(text).then(function () {
        btn.textContent = "Copié";
        setTimeout(function () { btn.textContent = "Copier"; }, 1500);
      }).catch(function () {});
    });
  });
  document.querySelectorAll("img.icon").forEach(function (img) {
    img.addEventListener("error", function () {
      var fallback = document.createElement("div");
      fallback.className = "icon fallback";
      fallback.setAttribute("aria-hidden", "true");
      fallback.textContent = img.dataset.initial || "";
      img.replaceWith(fallback);
    });
  });
</script>
</body>
</html>
EOF

mv "$tmp" "$OUTPUT"
trap - EXIT
echo "Généré : $OUTPUT"

#!/usr/bin/env bash
# Mide la landing publicada desde fuera. Sale 0 solo si las tres comprobaciones pasan,
# o si existe SALIDA.md (salida legítima documentada). Uso: bash verificar.sh
set -uo pipefail
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
fallos=0
ok(){ printf ' ✓ %s\n' "$1"; }
no(){ printf ' ✗ %s\n' "$1"; fallos=$((fallos+1)); }

if [ -f SALIDA.md ] && [ ! -f URL.txt ]; then
  echo "SALIDA.md existe y no hay URL publicada:"; sed -n '1,12p' SALIDA.md; echo "SALE 0 (salida legítima)"; exit 0
fi
if [ ! -s URL.txt ]; then no "URL.txt existe y no está vacío"; echo "SALE 1"; exit 1; fi
URL="$(head -1 URL.txt | tr -d '[:space:]')"
echo "URL: $URL"

codigo="$(curl -s -o /dev/null -w '%{http_code}' -L --max-time 30 "$URL")"
[ "$codigo" = "200" ] && ok "la URL responde 200" || no "la URL responde 200 (respondió $codigo)"

curl -s -L --max-time 30 "$URL" -o servido.html
n="$(grep -c 'Usted no compra' servido.html || true)"
[ "${n:-0}" -ge 1 ] && ok "el HTML servido contiene «Usted no compra» ($n líneas)" || no "el HTML servido contiene «Usted no compra» (0 líneas)"
if cmp -s servido.html index.html; then ok "lo servido es idéntico a index.html (md5 $(md5 -q index.html))"; else no "lo servido es idéntico a index.html (servido $(md5 -q servido.html) · local $(md5 -q index.html))"; fi

rm -f despues.png
"$CHROME" --headless=new --disable-gpu --hide-scrollbars --window-size=1440,900 --screenshot="$PWD/despues.png" "$URL" >/dev/null 2>&1
t="$( [ -f despues.png ] && stat -f %z despues.png || echo 0)"
[ "$t" -gt 30000 ] && ok "despues.png existe y pesa más de 30 KB ($t bytes)" || no "despues.png existe y pesa más de 30 KB ($t bytes)"
if [ -f antes.png ] && [ "$t" -gt 0 ]; then
  a="$(stat -f %z antes.png)"; d=$(( (t > a ? t - a : a - t) * 100 / a ))
  [ "$d" -le 40 ] && ok "despues.png difiere de antes.png en ${d} % (tope 40 %)" || no "despues.png difiere de antes.png en ${d} % (tope 40 %)"
fi
echo "Resumen: $fallos fallos"
[ "$fallos" = 0 ] && { echo "SALE 0"; exit 0; } || { echo "SALE 1"; exit 1; }

#!/usr/bin/env bash
set -euo pipefail

THEME="themes/simple-illustrated"
CSS="$THEME/theme.css"
JSON="$THEME/theme.json"
PREVIEW="$THEME/preview/index.html"

python3 -m json.tool "$JSON" >/dev/null

grep -Fq '"id": "simple-illustrated"' "$JSON"
grep -Fq '"design_style_id": "simple-illustrated"' "$JSON"
grep -Fq -- '--mmw-content-max' "$CSS"
grep -Fq -- '--dendrila-color-primary' "$CSS"
grep -Fq 'mask-image: var(--d-media-mask)' "$CSS"
grep -Fq 'object-position: var(--d-media-x) var(--d-media-y)' "$CSS"
grep -Fq 'prefers-reduced-motion' "$CSS"
grep -Fq ':focus-visible' "$CSS"
grep -Fq 'data-media-shape="organic-tall"' "$PREVIEW"
grep -Fq 'data-media-shape="organic-soft"' "$PREVIEW"

test -f "$THEME/assets/masks/organic-soft.svg"
test -f "$THEME/assets/masks/organic-tall.svg"
test -f "$THEME/assets/masks/arch.svg"
test -f "$THEME/preview/sample-media.svg"

if grep -RIniE 'materceleste|emmanuelle|#b85c39|#a94e37|#e8b653' "$THEME" >/dev/null; then
  echo "Client-specific identity leaked into reusable theme." >&2
  exit 1
fi

python3 - "$CSS" <<'PY'
from pathlib import Path
import sys

css = Path(sys.argv[1]).read_text(encoding="utf-8")
depth = 0
for char in css:
    if char == "{":
        depth += 1
    elif char == "}":
        depth -= 1
        if depth < 0:
            raise SystemExit("CSS has an unexpected closing brace")
if depth != 0:
    raise SystemExit("CSS braces are unbalanced")
PY

echo "Dendrila design kit checks passed."

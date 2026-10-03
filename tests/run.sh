#!/usr/bin/env bash
set -euo pipefail

THEME="themes/simple-illustrated"
CSS="$THEME/theme.css"
JSON="$THEME/theme.json"
CATALOG="catalog.json"
PREVIEW="$THEME/preview/index.html"

python3 -m json.tool "$JSON" >/dev/null
python3 -m json.tool "$CATALOG" >/dev/null

grep -Fq '"id": "simple-illustrated"' "$JSON"
grep -Fq '"design_style_id": "simple-illustrated"' "$JSON"
grep -Fq -- '--dendrila-content-max' "$CSS"
! grep -Fq -- '--mmw-' "$CSS"
grep -Fq -- '--dendrila-color-primary' "$CSS"
grep -Fq 'mask-image: var(--d-media-mask)' "$CSS"
grep -Fq 'object-position: var(--d-media-x) var(--d-media-y)' "$CSS"
grep -Fq 'prefers-reduced-motion' "$CSS"
grep -Fq ':focus-visible' "$CSS"
grep -Fq 'data-media-shape="organic-tall"' "$PREVIEW"
grep -Fq 'data-media-shape="organic-soft"' "$PREVIEW"
grep -Fq '.d-gallery {' "$CSS"
grep -Fq '.d-key-values {' "$CSS"
grep -Fq '.d-embed {' "$CSS"
grep -Fq 'data-dendrila-gallery="masonry"' "$CSS"
grep -Fq '"version": "0.2.1"' "$JSON"
grep -Fq '.d-stats {' "$CSS"
grep -Fq 'data-dendrila-media-crop="natural"' "$CSS"
grep -Fq 'data-dendrila-full-bleed="true"' "$CSS"

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

python3 - "$CATALOG" <<'PY'
from pathlib import Path
import json
import re
import sys

root = Path(".")
catalog = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
if catalog.get("schema_version") != 1:
    raise SystemExit("Unsupported catalog schema version")
seen = set()
for entry in catalog.get("themes", []):
    if entry["id"] in seen:
        raise SystemExit("Duplicate theme id")
    seen.add(entry["id"])
    if not re.fullmatch(r"[a-z][a-z0-9-]*", entry["id"]):
        raise SystemExit("Unsafe theme id")
    base = root / entry["path"]
    manifest_path = base / entry["manifest"]
    if not manifest_path.is_file():
        raise SystemExit(f"Missing manifest: {manifest_path}")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest.get("id") != entry["id"]:
        raise SystemExit("Catalog id does not match manifest")
    if manifest.get("design_style_id") != entry["design_style_id"]:
        raise SystemExit("Catalog design style does not match manifest")
    if manifest.get("version") != entry["version"]:
        raise SystemExit("Catalog version does not match manifest")
    entrypoint = base / manifest["entrypoint"]
    if not entrypoint.is_file():
        raise SystemExit(f"Missing theme entrypoint: {entrypoint}")
    tokens = manifest.get("required_style_tokens")
    if not isinstance(tokens, list) or not tokens or len(tokens) != len(set(tokens)):
        raise SystemExit("Theme must declare unique required_style_tokens")
    if not all(isinstance(token, str) and token.startswith("--dendrila-") for token in tokens):
        raise SystemExit("Invalid required style token")
PY

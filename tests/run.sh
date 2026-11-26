#!/usr/bin/env bash
set -euo pipefail

CATALOG="catalog.json"
# Discover all catalogue entries, including future contributions.
THEME_IDS=$(python3 -c 'import json; print("\n".join(x["id"] for x in json.load(open("catalog.json"))["themes"]))')
mapfile -t THEMES <<< "$THEME_IDS"
test "${#THEMES[@]}" -gt 0

python3 -m json.tool "$CATALOG" >/dev/null

for theme in "${THEMES[@]}"; do
  BASE="themes/$theme"
  JSON="$BASE/theme.json"
  CSS="$BASE/theme.css"
  PREVIEW="$BASE/preview/index.html"

  test -f "$JSON"
  test -f "$CSS"
  test -f "$PREVIEW"

  python3 -m json.tool "$JSON" >/dev/null
  grep -Fq "\"id\": \"$theme\"" "$JSON"
  grep -Fq "\"design_style_id\": \"$theme\"" "$JSON"
  grep -Fq -- '--dendrila-color-primary' "$CSS"
  grep -Fq -- '--dendrila-content-max' "$CSS"
  grep -Fq ':focus-visible' "$CSS"
  grep -Fq 'prefers-reduced-motion' "$CSS"
  ! grep -Fq -- '--mmw-' "$CSS"

  if grep -RIniE 'atelier commun|materceleste|emmanuelle|#b85c39|#a94e37|#e8b653' "$BASE" >/dev/null; then
    echo "Client-specific identity leaked into reusable theme: $theme" >&2
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
done

test -f "themes/simple-illustrated/assets/masks/organic-soft.svg"
test -f "themes/simple-illustrated/assets/masks/organic-tall.svg"
test -f "themes/simple-illustrated/assets/masks/arch.svg"
test -f "themes/simple-illustrated/preview/sample-media.svg"

test -f "themes/image-centered/preview/sample-media.svg"
test -f "themes/very-minimal/preview/sample-media.svg"
test -f "themes/dynamic-graphic/preview/sample-media.svg"

test -f "themes/simple-illustrated/assets/motifs/organic-line.svg"
test -f "themes/image-centered/assets/motifs/frame-lines.svg"
test -f "themes/quiet-elegant/assets/motifs/botanical-line.svg"
test -f "themes/quiet-elegant/assets/masks/organic-soft.svg"
test -f "themes/dynamic-graphic/assets/motifs/diagonal-grid.svg"
test -f "docs/PREVIEW-MEDIA.md"
test -f "docs/DECORATIVE-SYSTEM.md"


# Signatures that keep the directions visually distinct.
grep -Fq 'min-height: clamp(34rem, 67vw, 46rem)' themes/image-centered/theme.css
grep -Fq 'grid-template-columns: 1.45fr 1fr 1fr' themes/image-centered/theme.css
grep -Fq 'botanical-line.svg' themes/quiet-elegant/theme.css
grep -Fq 'grid-template-columns: minmax(0, .95fr) minmax(24rem, 1.05fr)' themes/quiet-elegant/theme.css
grep -Fq '.d-hero__media {' themes/very-minimal/theme.css
grep -Fq 'display: none;' themes/very-minimal/theme.css
grep -Fq 'clip-path: polygon(18% 0, 100% 0, 84% 100%, 0 100%)' themes/dynamic-graphic/theme.css
grep -Fq -- '--dendrila-color-secondary' themes/dynamic-graphic/theme.css

python3 - "$CATALOG" <<'PY'
from pathlib import Path
import json
import re
import sys

root = Path(".")
catalog = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
if catalog.get("schema_version") != 1:
    raise SystemExit("Unsupported catalog schema version")

themes = catalog.get("themes")
if not isinstance(themes, list) or len(themes) < 1:
    raise SystemExit("Catalog must contain themes")

seen_ids = set()
seen_styles = set()
for entry in themes:
    if not isinstance(entry, dict):
        raise SystemExit("Invalid catalog entry")
    for key in ("id", "design_style_id", "version", "path", "manifest"):
        if key not in entry:
            raise SystemExit(f"Missing catalog key: {key}")
    if entry["id"] in seen_ids or entry["design_style_id"] in seen_styles:
        raise SystemExit("Duplicate theme id or design style mapping")
    seen_ids.add(entry["id"])
    seen_styles.add(entry["design_style_id"])
    if not re.fullmatch(r"[a-z][a-z0-9-]*", entry["id"]):
        raise SystemExit("Unsafe theme id")

    if entry["path"] != "themes/" + entry["id"] or entry["manifest"] != "theme.json":
        raise SystemExit("Unsafe or unexpected catalogue path")
    base = root / entry["path"]
    if base.is_symlink() or not base.is_dir():
        raise SystemExit("Invalid theme directory")
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

    if manifest.get("entrypoint") != "theme.css" or manifest.get("preview") != "preview/index.html":
        raise SystemExit("Unsupported entrypoint or preview path")
    entrypoint = base / manifest["entrypoint"]
    preview = base / manifest["preview"]
    if not entrypoint.is_file():
        raise SystemExit(f"Missing theme entrypoint: {entrypoint}")
    if not preview.is_file():
        raise SystemExit(f"Missing theme preview: {preview}")

    if entrypoint.is_symlink() or preview.is_symlink():
        raise SystemExit("Symlinked theme file")
    if entry["id"] not in {"simple-illustrated", "image-centered", "quiet-elegant", "very-minimal", "dynamic-graphic"}:
        for f in base.rglob("*"):
            if f.is_symlink() or (f.is_file() and f.suffix.lower() not in {".css", ".html", ".json", ".svg", ".png", ".jpg", ".jpeg", ".webp", ".gif", ".md", ".txt", ".avif"}):
                raise SystemExit(f"Unsupported contribution file: {f}")
            if f.is_file() and f.suffix.lower() in {".css", ".html", ".svg"}:
                body = f.read_text(encoding="utf-8")
                if re.search(r"(?i)<script\b|\bon[a-z]+\s*=|javascript:|<iframe\b|<object\b|<embed\b|@import\b|url\(\s*['\"]?(?:https?:)?//|(?:src|href)\s*=\s*['\"](?:https?:)?//", body):
                    raise SystemExit(f"Review forbidden active or remote content: {f}")
        if not (base / "CREDITS.md").is_file():
            raise SystemExit("New theme requires CREDITS.md")
    tokens = manifest.get("required_style_tokens")
    if not isinstance(tokens, list) or not tokens or len(tokens) != len(set(tokens)):
        raise SystemExit("Theme must declare unique required_style_tokens")
    if not all(isinstance(token, str) and token.startswith("--dendrila-") for token in tokens):
        raise SystemExit("Invalid required style token")

    accessibility = manifest.get("accessibility")
    if not isinstance(accessibility, dict):
        raise SystemExit("Missing accessibility contract")
    if accessibility.get("focus_visible") is not True:
        raise SystemExit("Theme must keep visible focus")
    if accessibility.get("reduced_motion") is not True:
        raise SystemExit("Theme must support reduced motion")
    if accessibility.get("no_autoplay_media") is not True:
        raise SystemExit("Theme must forbid autoplay media")
    decorative = manifest.get("decorative_system")
    if not isinstance(decorative, dict):
        raise SystemExit("Theme must declare decorative_system")
    if decorative.get("no_upload_required") is not True:
        raise SystemExit("Theme decoration must not require client uploads")
    motifs = decorative.get("motifs")
    if not isinstance(motifs, list) or not motifs:
        raise SystemExit("Theme must declare at least one motif mode")
    shapes = decorative.get("image_shapes")
    if shapes != manifest.get("media_shapes"):
        raise SystemExit("Decorative image_shapes must match media_shapes")
    if decorative.get("implementation") != "theme-owned-css-svg":
        raise SystemExit("Theme decoration implementation must stay local to the theme")

expected = {"simple-illustrated", "image-centered", "quiet-elegant", "very-minimal", "dynamic-graphic"}
if not expected.issubset(seen_ids):
    raise SystemExit(f"Missing expected base themes: {sorted(expected - seen_ids)}")
PY

# Preview photos may be remote fillers, but only from documented Wikimedia thumbnails.
for theme in image-centered quiet-elegant very-minimal dynamic-graphic; do
  PREVIEW="themes/$theme/preview/index.html"
  if grep -Eq 'https://[^"]+' "$PREVIEW"; then
    ! grep -Eo 'https://[^"]+' "$PREVIEW" | grep -Ev '^https://(thumb|upload)\.wikimedia\.org/' >/dev/null
  fi
done
grep -Fq 'domaine public' docs/PREVIEW-MEDIA.md
grep -Fq 'CC0 1.0' docs/PREVIEW-MEDIA.md

echo "Dendrila design kit checks passed."

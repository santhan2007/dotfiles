#!/usr/bin/env bash
# gen-wallpaper.sh — generate a hacker-themed Catppuccin wallpaper
# Output: hacker.png in the wallpapers/ directory

set -euo pipefail

OUT="${1:-hacker.png}"
SIZE="${2:-1920x1080}"

# Generate SVG with Catppuccin Mocha + matrix code rain + gradient
SVG=$(mktemp --suffix=.svg)

cat > "$SVG" <<'SVG_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1920 1080" preserveAspectRatio="xMidYMid slice">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#1e1e2e"/>
      <stop offset="1" stop-color="#11111b"/>
    </linearGradient>
    <radialGradient id="glow" cx="0.5" cy="0.5" r="0.6">
      <stop offset="0" stop-color="#c6a0f6" stop-opacity="0.15"/>
      <stop offset="1" stop-color="#1e1e2e" stop-opacity="0"/>
    </radialGradient>
    <filter id="blur"><feGaussianBlur stdDeviation="2"/></filter>
  </defs>

  <!-- Background gradient -->
  <rect width="1920" height="1080" fill="url(#bg)"/>

  <!-- Center glow -->
  <rect width="1920" height="1080" fill="url(#glow)"/>

  <!-- Subtle grid -->
  <g stroke="#313244" stroke-width="1" opacity="0.4">
    <line x1="0" y1="100" x2="1920" y2="100"/>
    <line x1="0" y1="200" x2="1920" y2="200"/>
    <line x1="0" y1="300" x2="1920" y2="300"/>
    <line x1="0" y1="400" x2="1920" y2="400"/>
    <line x1="0" y1="500" x2="1920" y2="500"/>
    <line x1="0" y1="600" x2="1920" y2="600"/>
    <line x1="0" y1="700" x2="1920" y2="700"/>
    <line x1="0" y1="800" x2="1920" y2="800"/>
    <line x1="0" y1="900" x2="1920" y2="900"/>
    <line x1="0" y1="1000" x2="1920" y2="1000"/>
    <line x1="100" y1="0" x2="100" y2="1080"/>
    <line x1="200" y1="0" x2="200" y2="1080"/>
    <line x1="300" y1="0" x2="300" y2="1080"/>
    <line x1="400" y1="0" x2="400" y2="1080"/>
    <line x1="500" y1="0" x2="500" y2="1080"/>
    <line x1="600" y1="0" x2="600" y2="1080"/>
    <line x1="700" y1="0" x2="700" y2="1080"/>
    <line x1="800" y1="0" x2="800" y2="1080"/>
    <line x1="900" y1="0" x2="900" y2="1080"/>
    <line x1="1000" y1="0" x2="1000" y2="1080"/>
    <line x1="1100" y1="0" x2="1100" y2="1080"/>
    <line x1="1200" y1="0" x2="1200" y2="1080"/>
    <line x1="1300" y1="0" x2="1300" y2="1080"/>
    <line x1="1400" y1="0" x2="1400" y2="1080"/>
    <line x1="1500" y1="0" x2="1500" y2="1080"/>
    <line x1="1600" y1="0" x2="1600" y2="1080"/>
    <line x1="1700" y1="0" x2="1700" y2="1080"/>
    <line x1="1800" y1="0" x2="1800" y2="1080"/>
  </g>

  <!-- Center text -->
  <text x="960" y="540" text-anchor="middle"
        font-family="monospace" font-size="72" font-weight="bold"
        fill="#c6a0f6" filter="url(#blur)" opacity="0.3">MSS</text>
  <text x="960" y="540" text-anchor="middle"
        font-family="monospace" font-size="72" font-weight="bold"
        fill="#c6a0f6">MSS</text>

  <text x="960" y="600" text-anchor="middle"
        font-family="monospace" font-size="20"
        fill="#a6adc8" opacity="0.7">secure shell — authenticated</text>

  <text x="960" y="640" text-anchor="middle"
        font-family="monospace" font-size="14"
        fill="#6c7086">[ access granted ]</text>

  <!-- Matrix-style code rain (sparse, aesthetic) -->
  <g font-family="monospace" font-size="16" opacity="0.5">
    <text x="50" y="200" fill="#a6e3a1">01001000</text>
    <text x="50" y="240" fill="#94e2d5">01100101</text>
    <text x="50" y="280" fill="#a6e3a1">01101100</text>
    <text x="50" y="320" fill="#94e2d5">01101100</text>
    <text x="50" y="360" fill="#a6e3a1">01101111</text>

    <text x="1750" y="800" fill="#c6a0f6">$ sudo _</text>
    <text x="1750" y="840" fill="#a6adc8">[ok]</text>
    <text x="1750" y="880" fill="#f9e2af">loading...</text>

    <text x="100" y="900" fill="#89b4fa">&gt; whoami</text>
    <text x="100" y="940" fill="#a6e3a1">santhan</text>
    <text x="100" y="980" fill="#89b4fa">&gt; _</text>
  </g>

  <!-- Corner accents -->
  <g stroke="#c6a0f6" stroke-width="2" fill="none" opacity="0.6">
    <path d="M 40 40 L 40 100 M 40 40 L 100 40"/>
    <path d="M 1880 40 L 1880 100 M 1880 40 L 1820 40"/>
    <path d="M 40 1040 L 40 980 M 40 1040 L 100 1040"/>
    <path d="M 1880 1040 L 1880 980 M 1880 1040 L 1820 1040"/>
  </g>
</svg>
SVG_EOF

# Convert SVG to PNG
if command -v rsvg-convert >/dev/null 2>&1; then
    rsvg-convert -w 1920 -h 1080 "$SVG" -o "$OUT"
elif command -v inkscape >/dev/null 2>&1; then
    inkscape "$SVG" --export-filename="$OUT" -w 1920 -h 1080
elif command -v convert >/dev/null 2>&1; then
    convert -size 1920x1080 "$SVG" "$OUT"
elif command -v ffmpeg >/dev/null 2>&1; then
    ffmpeg -i "$SVG" -y "$OUT" 2>/dev/null
else
    echo "ERROR: need rsvg-convert, inkscape, imagemagick, or ffmpeg to render SVG"
    exit 1
fi

rm -f "$SVG"
echo "wallpaper written: $OUT"
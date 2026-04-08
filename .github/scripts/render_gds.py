#!/usr/bin/env python3
"""Render GDS files to PNG using KLayout in headless mode."""

import sys
from pathlib import Path

try:
    from klayout.lay import LayoutView
    import klayout.db as db
except ImportError:
    print("KLayout Python module not available (need full klayout, not pip version)")
    print("Install via: sudo apt-get install klayout")
    sys.exit(1)


def find_lyp(pdk_root: Path, pdk: str) -> str | None:
    """Find the .lyp layer properties file for the given PDK."""
    # Direct path under PDK
    lyp = pdk_root / pdk / "libs.tech" / "klayout" / "tech" / f"{pdk}.lyp"
    if lyp.exists():
        return str(lyp)
    # Search under ciel/sky130/versions/
    for lyp in pdk_root.rglob(f"{pdk}.lyp"):
        return str(lyp)
    return None


def render(gds_file: str, output_png: str, lyp_file: str = None,
           width: int = 2048, height: int = 2048):
    lv = LayoutView()

    lv.set_config("background-color", "#ffffff")
    lv.set_config("grid-visible", "false")
    lv.set_config("grid-show-ruler", "false")
    lv.set_config("text-visible", "false")

    lv.load_layout(gds_file, 0)

    if lyp_file and Path(lyp_file).exists():
        lv.load_layer_props(lyp_file)

    lv.max_hier()
    lv.timer()

    lv.save_image(output_png, width, height)
    print(f"Rendered {gds_file} -> {output_png} ({width}x{height})")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <gds_file> <output_png> [lyp_file]")
        sys.exit(1)

    gds_file = sys.argv[1]
    output_png = sys.argv[2]
    lyp_file = sys.argv[3] if len(sys.argv) > 3 else None

    if not Path(gds_file).exists():
        print(f"GDS file not found: {gds_file}")
        sys.exit(1)

    render(gds_file, output_png, lyp_file)

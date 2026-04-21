#!/usr/bin/env python3
"""Render GDS files to PNG using KLayout in headless mode.

Run with: klayout -b -r render_gds.py -rd gds_file=X -rd output_png=Y -rd lyp_file=Z
"""

from klayout.lay import LayoutView
import klayout.db as db
from pathlib import Path

# Parameters passed via klayout -rd
gds_file = gds_file  # noqa: F821 — injected by klayout -rd
output_png = output_png  # noqa: F821
lyp_file = lyp_file if "lyp_file" in dir() else None  # noqa: F821

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

lv.save_image(output_png, 2048, 2048)
print(f"Rendered {gds_file} -> {output_png}")

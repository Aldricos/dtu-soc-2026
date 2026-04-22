#!/usr/bin/env python3
"""Render GDS files to PNG using gdstk + rsvg-convert + pngquant.

Same approach as TinyTapeout's tt-support-tools/render_utils.py.
Dependencies:
  - pip: gdstk
  - apt: librsvg2-bin, pngquant
"""

import os
import subprocess
import sys


def render_svg(gds_file: str, svg_file: str, pad: str = "5%",
               filter_text: bool = True):
    import gdstk

    library = gdstk.read_gds(gds_file)
    top_cells = library.top_level()
    assert len(top_cells) >= 1
    top_cell = top_cells[0]

    cells = [top_cell] + [
        c for c in top_cell.dependencies(True) if isinstance(c, gdstk.Cell)
    ]
    if filter_text:
        for cell in cells:
            cell.remove(*cell.labels)

    top_cell.write_svg(svg_file, pad=pad)


def svg_to_png(svg_file: str, png_file: str) -> bool:
    cmd = ["rsvg-convert", "--unlimited", svg_file, "-o", png_file, "--no-keep-image-data"]
    p = subprocess.run(cmd, capture_output=True)
    if p.returncode != 0:
        print(f"rsvg-convert failed: {p.stderr.decode().strip()}", file=sys.stderr)
        return False
    return True


def compress_png(png_in: str, png_out: str, quality: str = "0-30") -> bool:
    cmd = ["pngquant", "--quality", quality, "--speed", "1", "--nofs",
           "--strip", "--force", "--output", png_out, png_in]
    p = subprocess.run(cmd, capture_output=True)
    if p.returncode != 0:
        # fall back to uncompressed
        os.rename(png_in, png_out)
        return False
    return True


def render(gds_file: str, output_png: str):
    svg_file = output_png.replace(".png", ".svg")
    tmp_png = output_png.replace(".png", "_raw.png")

    render_svg(gds_file, svg_file, pad=0, filter_text=True)
    if not svg_to_png(svg_file, tmp_png):
        sys.exit(1)
    compress_png(tmp_png, output_png)

    # Clean up intermediates
    for f in (svg_file, tmp_png):
        if os.path.exists(f):
            os.remove(f)

    print(f"Rendered {gds_file} -> {output_png} ({os.path.getsize(output_png):,} bytes)")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <gds_file> <output_png>")
        sys.exit(1)

    gds_file = sys.argv[1]
    output_png = sys.argv[2]

    if not os.path.exists(gds_file):
        print(f"GDS file not found: {gds_file}")
        sys.exit(1)

    render(gds_file, output_png)

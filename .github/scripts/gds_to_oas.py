#!/usr/bin/env python3
"""Convert GDS to OAS format using klayout.db (same as TinyTapeout)."""

import sys
from pathlib import Path

import klayout.db as pya


def convert(gds_file: str, output_oas: str, pdk: str = None):
    layout = pya.Layout()
    layout.read(gds_file)
    if pdk:
        layout.set_property("TT_PDK", pdk)
    layout.write(output_oas)
    print(f"Converted {gds_file} -> {output_oas}")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <gds_file> <output_oas> [pdk]")
        sys.exit(1)

    gds_file = sys.argv[1]
    output_oas = sys.argv[2]
    pdk = sys.argv[3] if len(sys.argv) > 3 else None

    if not Path(gds_file).exists():
        print(f"GDS file not found: {gds_file}")
        sys.exit(1)

    convert(gds_file, output_oas, pdk)

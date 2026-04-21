#!/usr/bin/env python3
"""Convert GDS to OAS format using KLayout.

Run with: klayout -b -r gds_to_oas.py -rd gds_file=X -rd output_oas=Y
"""

import klayout.db as db

# Parameters passed via klayout -rd
gds_file = gds_file  # noqa: F821 — injected by klayout -rd
output_oas = output_oas  # noqa: F821

ly = db.Layout()
ly.read(gds_file)
ly.write(output_oas)
print(f"Converted {gds_file} -> {output_oas}")

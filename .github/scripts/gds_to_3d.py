#!/usr/bin/env python3
"""Convert GDS files to glTF 3D models using GDS2glTF.

Output can be hosted on GitHub Pages and viewed with any glTF viewer.
"""

import subprocess
import sys
import tempfile
from pathlib import Path

GDS2GLTF_REPO = "https://github.com/mbalestrini/GDS2glTF.git"


def ensure_deps():
    subprocess.check_call([
        sys.executable, "-m", "pip", "install", "--quiet",
        "gdspy", "numpy", "triangle", "pygltflib"
    ])


def convert(gds_file: str, output_dir: str, gds2gltf_dir: str = None):
    """Convert a GDS file to glTF format."""
    ensure_deps()

    if gds2gltf_dir:
        script = Path(gds2gltf_dir) / "gds2gltf.py"
    else:
        tmp = Path(tempfile.mkdtemp())
        subprocess.check_call(["git", "clone", "--depth=1", GDS2GLTF_REPO, str(tmp)])
        script = tmp / "gds2gltf.py"

    if not script.exists():
        print(f"gds2gltf.py not found at {script}")
        sys.exit(1)

    gds_path = Path(gds_file).resolve()
    out_dir = Path(output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    # GDS2glTF outputs to the same directory as the input file
    # so we copy the GDS there first, then move the output
    import shutil
    tmp_gds = out_dir / gds_path.name
    shutil.copy2(gds_path, tmp_gds)

    subprocess.check_call(
        [sys.executable, str(script), str(tmp_gds)],
        cwd=str(out_dir)
    )

    # Output is <filename>.gltf
    gltf_file = out_dir / f"{gds_path.name}.gltf"
    tmp_gds.unlink()  # clean up the copied GDS

    if gltf_file.exists():
        # Rename to just <design>.gltf
        final = out_dir / f"{gds_path.stem}.gltf"
        gltf_file.rename(final)
        print(f"3D model: {gds_file} -> {final}")
    else:
        print(f"Warning: glTF output not found at {gltf_file}")
        sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <gds_file> <output_dir> [gds2gltf_dir]")
        sys.exit(1)

    gds_file = sys.argv[1]
    output_dir = sys.argv[2]
    gds2gltf_dir = sys.argv[3] if len(sys.argv) > 3 else None

    if not Path(gds_file).exists():
        print(f"GDS file not found: {gds_file}")
        sys.exit(1)

    convert(gds_file, output_dir, gds2gltf_dir)

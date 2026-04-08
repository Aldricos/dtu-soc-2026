#!/usr/bin/env python3
"""Generate a GitHub Actions job summary from OpenLane hardening results."""

import csv
import os
import sys
from pathlib import Path


def read_metrics(metrics_path: Path) -> dict:
    metrics = {}
    with open(metrics_path) as f:
        reader = csv.reader(f)
        next(reader)  # skip header
        for row in reader:
            if len(row) == 2:
                metrics[row[0]] = row[1]
    return metrics


def fmt_num(value: str, decimals: int = 2) -> str:
    try:
        num = float(value)
        if num == int(num) and decimals == 0:
            return f"{int(num):,}"
        return f"{num:,.{decimals}f}"
    except (ValueError, TypeError):
        return value


def fmt_pct(value: str) -> str:
    try:
        return f"{float(value) * 100:.1f}%"
    except (ValueError, TypeError):
        return value


def status_icon(value: str, bad_if_nonzero: bool = True) -> str:
    try:
        n = float(value)
        if bad_if_nonzero and n != 0:
            return f"**{fmt_num(value, 0)}** :x:"
        if not bad_if_nonzero and n < 0:
            return f"**{fmt_num(value)}** :warning:"
        return fmt_num(value, 0) if bad_if_nonzero else fmt_num(value)
    except (ValueError, TypeError):
        return value


def get_corners(metrics: dict) -> list:
    corners = set()
    for key in metrics:
        if "__corner:" in key:
            corner = key.split("__corner:")[-1]
            if not corner.startswith("nom_") and not corner.startswith("min_") and not corner.startswith("max_"):
                continue
            corners.add(corner)
    return sorted(corners)


def write_summary(design: str, exit_code: int, project_root: Path):
    summary_file = os.environ.get("GITHUB_STEP_SUMMARY")
    out = open(summary_file, "a") if summary_file else sys.stdout

    signoff_dir = project_root / "signoff" / design
    metrics_path = signoff_dir / "metrics.csv"
    openlane_signoff = signoff_dir / "openlane-signoff"

    passed = exit_code == 0
    icon = ":white_check_mark:" if passed else ":x:"
    out.write(f"## {icon} {design}\n\n")

    # On failure, show errors first
    if not passed:
        error_log = openlane_signoff / "error.log" if openlane_signoff.exists() else None
        flow_log = openlane_signoff / "flow.log" if openlane_signoff.exists() else None

        out.write("### Errors\n\n")

        errors_shown = False
        if error_log and error_log.exists() and error_log.stat().st_size > 1:
            out.write("```\n")
            out.write(error_log.read_text()[:5000])
            out.write("\n```\n\n")
            errors_shown = True

        if not errors_shown and flow_log and flow_log.exists():
            lines = flow_log.read_text().splitlines()
            tail = lines[-50:] if len(lines) > 50 else lines
            out.write("<details><summary>Last 50 lines of flow.log</summary>\n\n```\n")
            out.write("\n".join(tail))
            out.write("\n```\n\n</details>\n\n")

        # Find the latest run directory for additional logs
        runs_dir = project_root / "runs" / design
        if runs_dir.exists():
            run_dirs = sorted(runs_dir.iterdir(), reverse=True)
            if run_dirs:
                latest_run = run_dirs[0]
                for log_name in ["flow.log", "error.log"]:
                    log_path = latest_run / log_name
                    if log_path.exists() and log_path.stat().st_size > 1 and not errors_shown:
                        out.write(f"<details><summary>{log_name} (from runs/)</summary>\n\n```\n")
                        content = log_path.read_text()
                        lines = content.splitlines()
                        tail = lines[-80:] if len(lines) > 80 else lines
                        out.write("\n".join(tail))
                        out.write("\n```\n\n</details>\n\n")

    # If no metrics available, stop here
    if not metrics_path.exists():
        if not passed:
            out.write("*No metrics available — hardening failed before producing signoff data.*\n\n")
        if out is not sys.stdout:
            out.close()
        return

    metrics = read_metrics(metrics_path)

    # Overview table
    out.write("### Design Overview\n\n")
    out.write("| Metric | Value |\n")
    out.write("|:-------|------:|\n")

    rows = [
        ("Instances", fmt_num(metrics.get("design__instance__count", ""), 0)),
        ("Die area", f"{fmt_num(metrics.get('design__die__area', ''), 0)} um\u00b2"),
        ("Utilization", fmt_pct(metrics.get("design__instance__utilization", ""))),
        ("Power (total)", f"{fmt_num(metrics.get('power__total', ''), 4)} W"),
    ]
    for label, value in rows:
        out.write(f"| {label} | {value} |\n")
    out.write("\n")

    # Signoff checks
    out.write("### Signoff Checks\n\n")
    out.write("| Check | Count |\n")
    out.write("|:------|------:|\n")

    checks = [
        ("DRC errors (Magic)", "magic__drc_error__count"),
        ("DRC errors (KLayout)", "klayout__drc_error__count"),
        ("LVS errors", "design__lvs_error__count"),
        ("LVS device diff", "design__lvs_device_difference__count"),
        ("LVS net diff", "design__lvs_net_difference__count"),
        ("Antenna violations", "antenna__violating__nets"),
        ("Route DRC errors", "route__drc_errors"),
    ]
    for label, key in checks:
        val = metrics.get(key, "N/A")
        out.write(f"| {label} | {status_icon(val)} |\n")
    out.write("\n")

    # Timing summary (aggregate across all corners)
    out.write("### Timing Summary\n\n")
    out.write("| Metric | Value |\n")
    out.write("|:-------|------:|\n")

    timing_rows = [
        ("Setup WNS", "timing__setup__wns", False),
        ("Setup TNS", "timing__setup__tns", False),
        ("Setup violations", "timing__setup_vio__count", True),
        ("Hold WNS", "timing__hold__wns", False),
        ("Hold TNS", "timing__hold__tns", False),
        ("Hold violations", "timing__hold_vio__count", True),
        ("Slew violations", "design__max_slew_violation__count", True),
        ("Fanout violations", "design__max_fanout_violation__count", True),
        ("Cap violations", "design__max_cap_violation__count", True),
    ]
    for label, key, bad_nonzero in timing_rows:
        val = metrics.get(key, "N/A")
        if val != "N/A":
            out.write(f"| {label} | {status_icon(val, bad_nonzero)} |\n")
    out.write("\n")

    # Cell breakdown
    out.write("### Cell Breakdown\n\n")
    out.write("| Type | Count |\n")
    out.write("|:-----|------:|\n")
    cell_types = [
        ("Sequential", "design__instance__count__class:sequential_cell"),
        ("Combinational", "design__instance__count__class:multi_input_combinational_cell"),
        ("Buffer", "design__instance__count__class:buffer"),
        ("Inverter", "design__instance__count__class:inverter"),
        ("Clock buffer", "design__instance__count__class:clock_buffer"),
        ("Clock inverter", "design__instance__count__class:clock_inverter"),
        ("Timing repair", "design__instance__count__class:timing_repair_buffer"),
        ("Fill", "design__instance__count__class:fill_cell"),
        ("Tap", "design__instance__count__class:tap_cell"),
        ("Antenna", "design__instance__count__class:antenna_cell"),
    ]
    for label, key in cell_types:
        val = metrics.get(key)
        if val is not None:
            out.write(f"| {label} | {fmt_num(val, 0)} |\n")
    out.write("\n")

    # Per-corner timing details (collapsible)
    corners = get_corners(metrics)
    if corners:
        out.write("<details><summary>Timing per corner</summary>\n\n")
        out.write("| Corner | Setup WNS | Setup TNS | Setup Vio | Hold WNS | Hold Vio |\n")
        out.write("|:-------|----------:|----------:|----------:|---------:|---------:|\n")
        for corner in corners:
            s_wns = metrics.get(f"timing__setup__wns__corner:{corner}", "")
            s_tns = metrics.get(f"timing__setup__tns__corner:{corner}", "")
            s_vio = metrics.get(f"timing__setup_vio__count__corner:{corner}", "")
            h_wns = metrics.get(f"timing__hold__wns__corner:{corner}", "")
            h_vio = metrics.get(f"timing__hold_vio__count__corner:{corner}", "")
            out.write(
                f"| {corner} | {fmt_num(s_wns)} | {fmt_num(s_tns)} | {fmt_num(s_vio, 0)} "
                f"| {fmt_num(h_wns)} | {fmt_num(h_vio, 0)} |\n"
            )
        out.write("\n</details>\n\n")

    # Warnings (collapsible)
    warning_log = openlane_signoff / "warning.log" if openlane_signoff.exists() else None
    if warning_log and warning_log.exists() and warning_log.stat().st_size > 1:
        out.write("<details><summary>Warnings</summary>\n\n```\n")
        out.write(warning_log.read_text()[:5000])
        out.write("\n```\n\n</details>\n\n")

    out.write("---\n\n")

    if out is not sys.stdout:
        out.close()


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <design_name> <exit_code>")
        sys.exit(1)

    design = sys.argv[1]
    exit_code = int(sys.argv[2])
    project_root = Path.cwd()

    write_summary(design, exit_code, project_root)

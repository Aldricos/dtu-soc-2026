#!/usr/bin/env bash
# Patch chipfoundry_cli's `cf precheck` command so its Docker invocation runs
# scripts/patch_cf_precheck.sh INSIDE the container, between the pip install
# of cf-precheck and the cf-precheck call. That patch is what actually adds
# `-rd sram_exclude=true` to the klayout_feol DRC and silences the 15
# documented false-positive SRAM-macro errors.
#
# Without this host-side patch, cf precheck runs cf_precheck in a fresh
# container that has no awareness of any project-local fixes. Patching the
# host venv's cf_precheck is useless for `cf precheck` (it's container-only).
#
# Idempotent. Safe to re-run after `pip install --upgrade chipfoundry-cli`.
set -euo pipefail

# Find a Python interpreter that has chipfoundry_cli importable. Prefer
# (in order): explicit $PYTHON, an active virtualenv, the project's .venv,
# the system python3.
find_python() {
  local candidates=()
  [ -n "${PYTHON:-}" ]              && candidates+=("$PYTHON")
  [ -n "${VIRTUAL_ENV:-}" ]         && candidates+=("$VIRTUAL_ENV/bin/python3")
  [ -x "./.venv/bin/python3" ]      && candidates+=("./.venv/bin/python3")
  candidates+=(python3)
  for p in "${candidates[@]}"; do
    if "$p" -c 'import chipfoundry_cli' 2>/dev/null; then
      echo "$p"
      return 0
    fi
  done
  return 1
}

PYTHON="$(find_python)" \
  || { echo "patch_chipfoundry_cli: chipfoundry_cli not importable from any candidate python3 (PYTHON, \$VIRTUAL_ENV, ./.venv, system). Is chipfoundry-cli installed?" >&2; exit 1; }

TARGET="$("$PYTHON" -c 'import chipfoundry_cli, pathlib, sys; sys.stdout.write(str(pathlib.Path(chipfoundry_cli.__file__).parent / "main.py"))')"

if [ ! -f "$TARGET" ]; then
  echo "patch_chipfoundry_cli: $TARGET not found." >&2
  exit 1
fi

if grep -q 'scripts/patch_cf_precheck.sh' "$TARGET"; then
  echo "patch_chipfoundry_cli: already patched (target: $TARGET)."
  exit 0
fi

"$PYTHON" - "$TARGET" <<'PY'
import sys, re, pathlib
p = pathlib.Path(sys.argv[1])
src = p.read_text()
# chipfoundry_cli's precheck() builds inner_cmd as a single-line string of
# the form (with or without the `exec ` introduced in a recent release):
#   inner_cmd = 'pip3 install ... cf-precheck 2>/dev/null && [exec ]cf-precheck ' + ' '.join(precheck_args)
# We capture the leading indent and the optional `exec ` prefix so we
# preserve both faithfully when expanding to a multi-line concatenation.
pat = re.compile(
    r"^(?P<indent> *)inner_cmd = "
    r"'pip3 install --upgrade -q --root-user-action=ignore cf-precheck 2>/dev/null && "
    r"(?P<exec>exec )?cf-precheck ' \+ ' '\.join\(precheck_args\)$",
    re.MULTILINE,
)
m = pat.search(src)
if not m:
    sys.exit("patch_chipfoundry_cli: expected inner_cmd line not found in main.py;"
             " chipfoundry_cli version may have changed shape, refusing to patch blindly")
indent = m.group("indent")
inner = indent + "    "
exec_prefix = m.group("exec") or ""
replacement = (
    f"{indent}inner_cmd = (\n"
    f"{inner}'pip3 install --upgrade -q --root-user-action=ignore cf-precheck 2>/dev/null && '\n"
    f"{inner}f'( [ -f {{project_root_path}}/scripts/patch_cf_precheck.sh ] && bash {{project_root_path}}/scripts/patch_cf_precheck.sh || true ) && '\n"
    f"{inner}'{exec_prefix}cf-precheck ' + ' '.join(precheck_args)\n"
    f"{indent})"
)
p.write_text(src[:m.start()] + replacement + src[m.end():])
PY

echo "patch_chipfoundry_cli: cf precheck now invokes scripts/patch_cf_precheck.sh inside the container before cf-precheck (target: $TARGET)."

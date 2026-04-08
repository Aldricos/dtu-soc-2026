# Macro LIB File Integration — Group 4

## Task
Demonstrate that the LibreLane hardening flow reads and uses a macro's LIB file during top-level STA by measuring fmax before and after making the macro slower.

## Experiment Setup

Two versions of the same macro (`TinyMacro`) with identical interfaces but different logic:

- **Fast** (`TinyMacroFast.v`): 8-bit register — `dout <= din`
- **Slow** (`TinyMacroSlow.v`): 3 chained 8-bit multipliers before the register — deep combinational path

Each version was hardened independently (`cf harden TinyMacro`), producing a LIB file at `lib/TinyMacro.lib`. A top-level wrapper (`LibTestTop`) instantiating TinyMacro as a black-box was then hardened using the macro's LIB, GDS, LEF, and SPEF artifacts.

## Results

fmax is derived from the post-PnR setup slack: **fmax = 1 / (period − slack)**. Both designs use a 10 ns clock.

| Macro | Setup Slack (nom_tt) | fmax (nom_tt) | Setup Slack (worst SS) | fmax (worst case) |
|-------|----------------------|---------------|------------------------|-------------------|
| Fast  | +6.83 ns             | ~315 MHz      | +6.04 ns               | ~253 MHz          |
| Slow  | +2.99 ns             | ~143 MHz      | −1.49 ns (violation)   | ~87 MHz           |

The slow macro has **2× worse fmax** and already fails timing at 100 MHz in SS corners.

## Note on What Actually Drives the Timing

The `LibTestTop` config references four macro artifacts: `nl` (gate-level netlist), `spef` (extracted parasitics), `lib`, and `lef`. When all four are present, the STA tool uses the **gate-level netlist + SPEF** as the primary source — it unfolds the macro hierarchy and traces the actual cell-level paths with real wire parasitics. The LIB file is not used as the timing model in this case; it would only be the primary source if the macro were treated as a true black box (i.e., no `nl`/`spef` provided).

This can be verified directly in the post-PnR timing report:

```
openlane/LibTestTop/runs/Fast/48-openroad-stapostpnr/nom_ss_100C_1v60/max.rpt
```

The critical path lists internal macro cells by name, e.g.:

```
^ u_macro/clkbuf_0_clk/A (sky130_fd_sc_hd__clkbuf_16)
^ u_macro/_4_/CLK (sky130_fd_sc_hd__dfxtp_2)
^ u_macro/output13/X (sky130_fd_sc_hd__buf_12)
```

If the LIB were used as a black box, the path would instead show a single abstract entry at the macro boundary (e.g. `u_macro/dout[4]` with a lumped delay), with no visibility into internal cells. The presence of individual PDK cell names inside `u_macro` is proof the STA is using the gate-level netlist.

So the experiment result is still valid — the STA correctly reflects the macro's logic in both runs — but the driver is the netlist + SPEF, not the LIB file directly. The LIB file would be the relevant artifact when handing off the macro to a third party who does not have access to the internal netlist.

## Conclusion

Same top-level wrapper, same constraints, same PDK — only the macro internals changed. The top-level STA correctly reflected the macro's timing in both cases via the gate-level netlist and SPEF. The 2× fmax difference proves the flow properly integrates macro timing, even if the LIB file itself is not the direct input to the STA in this configuration.

Hardening runs are saved under `openlane/TinyMacro/runs/Fast` and `openlane/TinyMacro/runs/Slow`.

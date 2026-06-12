# TU-boundary archaeology — retail alignment census

Side findings from the braf-lint investigation (2026-06-12), parked
here so the data isn't lost. No code depends on this; it's a map
fragment for the decomp.

## The census

Probe over the authoritative ~850-function yaml map
(`DaytonaCCEReverse/config/race.bin.yaml`) plus retail RACE.BIN
bytes (753 code subsegments; the map tiles the module completely,
zero inter-subsegment gaps):

| Measurement | Result |
|---|---|
| Function starts ≡ 0 mod 4 | 601 (80%) |
| Function starts ≡ 2 mod 4 | 152 (20%) |
| mod-16 spread | flat (154/45/158/29/154/36/135/42) — no wider alignment |
| Functions with trailing pad nops | 62, every one exactly ONE `0x0009` word |

Trailing-nop detection guarded against `rts`-delay-slot nops
(a nop preceded by an instruction with a delay slot is code, not
pad). Probe script preserved inline in the session that produced
this doc; trivially re-derivable from the table above.

## What it killed

The "keep functions at retail parity so parity-sensitive idioms
never see odd offsets" proposal: SHC did **not** 4-align functions
(20% start odd), so blanket alignment breaks baseline byte-match,
and the workable per-function variant needs the retail parity from
the `FUN_` symbol name — which silently dies when the decomp
renames functions. Punted; the braf lint
(`braf_dispatch_lint.md`) guards the corruption class instead.

## The hypothesis worth keeping

62 single-nop seams across 753 tightly-packed mixed-parity
functions is the wrong shape for per-function alignment — but it is
exactly the shape of **per-compilation-unit alignment**: SHC packing
functions tightly within a TU while the section start of each TU
gets 4-aligned at link, the seam nop landing at the end of a TU
whose code happened to end at ≡2. If that's right, the 62 seams
partition race.bin into Sega's original source files — directly
useful when M3 picks TU lift targets, and a free cross-check for
the TU census.

**Follow-up probes when someone picks this up:**

- Do the 62 seam addresses correlate with boundaries already
  suspected from the FUN_-clustering / shared-pool analysis
  (`pool_graph_probe.py` Case C map)?
- Are cross-function pool-sharing edges (Case C) strictly
  *intra*-seam? TU-local pools shouldn't cross a TU boundary; a
  clean partition would confirm both hypotheses at once.
- Do `#pragma`-class quirks (gbr_base, save-strategy) cluster
  within seams? Per-TU compiler flags would look exactly like that.

## Append log

| Date | Note |
|------|------|
| 2026-06-12 | Created from the braf-lint session's parity census. |

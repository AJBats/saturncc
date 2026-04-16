# history

Historical workstream docs, archived here so they stay discoverable
but don't clutter the top-level `workstreams/` directory or get
mistaken for current-state references.

## What's in here

- **`byte_match_status.md`** — 2026-04-11 snapshot. Uses the obsolete
  "byte match %" metric from before the compiler was writing
  full-function output. Historical evidence for **M2 — success-metric
  drift** in [../methodology_remediation.md](../methodology_remediation.md);
  the metric has since been replaced by the tier-1 diff counts at
  `saturn/experiments/byte_match_baselines/`.

- **`2026-04-11_session_handoff.md`** — Phase 1C wrap-up + project
  migration from `SaturnCompiler/` to `saturncc/`. Records the
  register-allocation blocker that dominated that week.

- **`2026-04-12_session_handoff.md`** — follow-up on the switch +
  register-argument crash.

## When to read these

Only when archaeology calls for it — the metrics and next-action
pointers inside are no longer valid. For current state:

- `git log --oneline master` — what's shipped.
- [../gap_catalog.md](../gap_catalog.md) — open backend gaps.
- [../methodology_remediation.md](../methodology_remediation.md) —
  open infrastructure / process items.
- `wsl bash saturn/tools/validate_byte_match.sh dashboard` — current
  byte-match diff counts.

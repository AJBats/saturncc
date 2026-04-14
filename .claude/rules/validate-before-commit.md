# Validate Before Commit

Before creating any git commit  you must do two checks:

1. run `validate_build.sh` and confirm all tests pass:

```bash
wsl bash saturn/tools/validate_build.sh
```

If any test fails, do not commit. Fix the failure first.

If the stable .s files differ from HEAD, **stop and talk to the user** before doing anything else. A stability change means either a regression or an intentional improvement — only the user can decide which.

2. Get a subagent to review modifiled .s files as a side effect our your most recent compiler change. Ask the subagent to grade the change against production in terms of bringing the .s file to a closer byte match of production.

If the subagent reports no change or a regression, **stop and talk to the user* before doing anything else. The user may have a good reason for the change, but they should be aware of the impact on stability.

No exceptions — this is the mechanical safety net that prevents regressions in the compiler and byte-match experiments.

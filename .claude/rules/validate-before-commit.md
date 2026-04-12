# Validate Before Commit

Before creating any git commit, run `validate_build.sh` and confirm all tests pass:

```bash
wsl bash saturn/tools/validate_build.sh
```

If any test fails, do not commit. Fix the failure first.

If the stable .s files differ from HEAD, **stop and talk to the user** before doing anything else. A stability change means either a regression or an intentional improvement — only the user can decide which.

No exceptions — this is the mechanical safety net that prevents regressions in the compiler and byte-match experiments.

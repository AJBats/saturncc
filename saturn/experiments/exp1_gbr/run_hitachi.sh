#!/bin/bash
# Run Hitachi SHC v5.0 R31 on gbr_test_sh.c and capture output.
#
# Note: Hitachi SHC is VERY picky about environment variables. Must scrub
# any unrelated ones (ProgramFiles(x86), VSCODE_*, etc.) or it fails with
# "Illegal environment variable". Uses PowerShell's EnvironmentVariables.Clear()
# pattern (same as the test harness at Downloads/Hitachi/test/test_all_flags.py).

SHC_DIR="C:/Users/albat/Downloads/Hitachi"
TEST_DIR="D:/Projects/SaturnCompiler/experiments/exp1_gbr"

# PowerShell approach for clean environment
powershell.exe -Command "
\$psi = New-Object System.Diagnostics.ProcessStartInfo
\$psi.FileName = '${SHC_DIR}/shc.exe'
\$psi.Arguments = '-cpu=sh2 -optimize=1 -listfile=${TEST_DIR}/hitachi_out.lst -show=object,source ${TEST_DIR}/gbr_test_sh.c'
\$psi.UseShellExecute = \$false
\$psi.RedirectStandardOutput = \$true
\$psi.RedirectStandardError = \$true
\$psi.WorkingDirectory = '${SHC_DIR}'
\$psi.EnvironmentVariables.Clear()
\$psi.EnvironmentVariables['SHC_TMP'] = '${TEST_DIR}'
\$psi.EnvironmentVariables['SHC_LIB'] = '${SHC_DIR}'
\$psi.EnvironmentVariables['PATH'] = '${SHC_DIR};C:\Windows\system32'
\$psi.EnvironmentVariables['SYSTEMROOT'] = 'C:\Windows'
\$p = [System.Diagnostics.Process]::Start(\$psi)
\$stdout = \$p.StandardOutput.ReadToEnd()
\$stderr = \$p.StandardError.ReadToEnd()
\$p.WaitForExit()
Write-Host 'STDOUT:'
Write-Host \$stdout
Write-Host 'STDERR:'
Write-Host \$stderr
Write-Host \"ExitCode: \$(\$p.ExitCode)\"
"

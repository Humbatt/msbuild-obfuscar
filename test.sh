#!/usr/bin/env bash
# Packs the targets, builds the sample in Release with them, and checks the output was obfuscated.
set -euo pipefail
cd "$(dirname "$0")"

rm -rf artifacts MSBuild.Obfuscar.Test/.packages MSBuild.Obfuscar.Test/bin MSBuild.Obfuscar.Test/obj
dotnet pack MSBuild.Obfuscar/Humbatt.MSBuild.Obfuscar.csproj -c Release
dotnet build MSBuild.Obfuscar.Test/MSBuild.Obfuscar.Test.csproj -c Release "$@"

out=MSBuild.Obfuscar.Test/bin/Release/net10.0
test -f "$out/Mapping.txt" || { echo "FAIL: no Mapping.txt, Obfuscar did not run"; exit 1; }
test ! -d "$out/obfuscated" || { echo "FAIL: obfuscated files were not moved into the output"; exit 1; }
if grep -q "SecretComputation" "$out/MSBuild.Obfuscar.Test.dll"; then echo "FAIL: the output assembly is not obfuscated"; exit 1; fi
test "$(dotnet "$out/MSBuild.Obfuscar.Test.dll")" = "42" || { echo "FAIL: the obfuscated program does not run"; exit 1; }
echo "PASS"

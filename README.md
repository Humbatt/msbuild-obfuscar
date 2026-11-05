Humbatt.MSBuild.Obfuscar
========================

MSBuild targets that run [Obfuscar](https://www.obfuscar.com) after every Release build, on Windows, Linux and macOS.

[![Build](https://github.com/Humbatt/msbuild-obfuscar/actions/workflows/build.yml/badge.svg)](https://github.com/Humbatt/msbuild-obfuscar/actions/workflows/build.yml)
[![NuGet](https://img.shields.io/nuget/v/Humbatt.MSBuild.Obfuscar.svg)](https://www.nuget.org/packages/Humbatt.MSBuild.Obfuscar/)

Usage
-----

```xml
<PackageReference Include="Humbatt.MSBuild.Obfuscar" Version="2.2.50.1" PrivateAssets="all" />
```

Put an Obfuscar configuration next to the project, named `<ProjectName>.xml` or `Obfuscar.xml`. Write its
output to `obfuscated` under the build output, using forward slashes so it works on every OS:

```xml
<Obfuscator>
  <Var name="InPath" value="bin/Release/netstandard2.0" />
  <Var name="OutPath" value="$(InPath)/obfuscated" />
  <Var name="HidePrivateApi" value="true" />
  <Module file="$(InPath)/MyLibrary.dll" />
</Obfuscator>
```

After a Release build the obfuscated files replace the originals in the output folder, so `dotnet pack`
packs them. `Mapping.txt` is left beside them.

| Property | Meaning |
| --- | --- |
| `ObfuscarRunner` | `dotnet` (default): Obfuscar's cross-platform console, bundled in the package and run by the build's .NET host (.NET 10 or later). `exe`: `Obfuscar.Console.exe` from the Obfuscar package (.NET Framework: Windows, or Mono elsewhere), as in versions before 2.2.50. |
| `SkipObfuscation` | `true` builds without obfuscating. |
| `ObfuscarConfigFile` | A different configuration file. |

Strong-name signing (`<Var name="KeyFile" .../>`) works with both runners.

What changed in 2.2.50
----------------------

Earlier versions only worked on Windows:
- Off Windows they ran `Obfuscar.Console.exe` under Mono.
- They looked for the tools in `Obfuscar/<version>` while NuGet stores them as `obfuscar/<version>`.
- Off Windows they never moved the obfuscated files into the output, so packages were built from the unobfuscated assemblies without any error.

2.2.50 fixes all three. It also no longer overwrites MSBuild's `ProjectFileName` property; use `ObfuscarConfigFile` instead.

Building and releasing
----------------------

```bash
./test.sh                          # pack, obfuscate the sample, and check the result
./test.sh -p:ObfuscarRunner=exe    # the same with Obfuscar.Console.exe (Windows)
```

GitHub Actions runs `test.sh` on Linux, Windows and macOS for every push and pull request.

To release, push a tag `v<version>`, for example `git tag v2.2.50.1 && git push origin v2.2.50.1`. The workflow then packs that version, pushes it to nuget.org using the `NUGET_API_KEY` repository secret, and creates a GitHub release with the package attached.

Obfuscar
--------

[Obfuscar](https://github.com/obfuscar/obfuscar) is an open-source .NET obfuscator released under the MIT
license. Its console is bundled in this package; see [THIRD-PARTY-NOTICES.txt](THIRD-PARTY-NOTICES.txt).

License
-------

MIT; see [LICENSE](LICENSE). Originally by Enner Pérez ([ennerperez/msbuild-obfuscar](https://github.com/ennerperez/msbuild-obfuscar)).

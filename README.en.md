<div align="center">

# Moon Cross

### MoonBit Cross-Platform Native Framework

> Write once, deliver to five platforms — iOS / Android / Windows / HarmonyOS / Linux

[![Version](https://img.shields.io/badge/version-0.3.36-blue.svg)](./docs/changelog.md)
[![Tests](https://img.shields.io/badge/tests-2374%2B18-brightgreen.svg)]()
[![Packages](https://img.shields.io/badge/packages-80-green.svg)]()
[![Warnings](https://img.shields.io/badge/warnings-0-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)

**80 packages** · **2374 tests (main) + 18 tests (examples)** · **0 warnings** · **8 real CLI commands** · **4 runnable examples**

[中文](./README.md) · [Changelog](./docs/changelog.md) · [Roadmap](./docs/roadmap.md) · [Contributing](./CONTRIBUTING.md)

</div>

---

## Overview

Moon Cross turns any pure MoonBit library into native libraries for **five platforms** with one codebase — iOS / Android / Windows / HarmonyOS / Linux.

Built on the MoonBit native backend's **`foreign_library` + `#export_name`** mechanism: MoonBit code compiles into a platform-native static archive (`.a`/`.lib`); the framework then generates the C adapter layer, per-platform FFI bindings and build scripts, and an outer C compiler wraps them into `.so`/`.dll`/`.framework` artifacts.

## Core Features

### CLI (8 real commands)

| Command | Description | Status |
|---------|-------------|:------:|
| `init` | Scaffold a buildable cross-platform project (5 files on disk) | ✅ |
| `build` | Generate C adapter + five-platform FFI bindings + Makefile from `moon-cross.json` | ✅ |
| `check` | Validate config: unique function names, type mapping, platform validity | ✅ |
| `plan` | Show the build plan (dry-run) | ✅ |
| `sync` | Regenerate platform bindings | ✅ |
| `doctor` | Probe moon toolchain & C compilers (clang-cl/clang/gcc/cc), NDK/OHOS SDK env | ✅ |
| `publish` | moon.mod metadata pre-check + mooncakes publishing guide | ✅ |
| `wizard` | Non-interactive preview of the init plan | ✅ |

Every command performs real disk IO (`moonbitlang/core/async/fs`); `doctor` probes via subprocesses (`core/async/process`).

### Type Mapping

Scalars (Int/Double/Bool/Unit), String, Bytes, Array[T], named Struct → native types on all five platforms, with type-dependency cycle checking.

## Quick Start

```bash
# 0. Prerequisites: moon >= 0.1.20261104 (https://www.moonbitlang.com/download)
git clone https://github.com/walkzzz/moon-cross.git
cd moon-cross

# 1. Verify the framework itself (2374 tests)
moon check --deny-warn && moon test

# 2. Scaffold a cross-platform project (writes 5 real files)
moon run tools/cli -- init --name mylib --output mylib

# 3. Build mylib into a native static archive (with #export_name symbols)
cd mylib && moon build --target native --release
# artifact: _build/native/release/build/src/src.a (Linux/macOS) / src.lib (Windows)

# 4. Generate five-platform bindings + Makefile (writes 7 real files)
moon run ../tools/cli -- build --config moon-cross.json --platform all --output moon-cross-output
```

End-to-end proof (Linux):

```bash
bash scripts/e2e_linux.sh
# scaffold -> static library -> C host link -> moonbit_init() -> call exported fn -> assertions PASS
# followed by the same chain against the real third-party library zlib-cross
```

## Runnable Examples

All four examples under `examples/` are **complete, buildable standalone MoonBit modules** (real mooncakes third-party libraries + `#export_name` wrappers + tests + `moon-cross.json` + README):

| Example | Third-party library | Exported fns | Tests |
|---------|--------------------|:------------:|:-----:|
| `zlib-cross` | mizchi/zlib@0.4.12 (compression & checksums, pure MoonBit) | 9 | 6 |
| `toml-cross` | moonbit-community/toml@0.5.1 (TOML 1.1 parser) | 4 | 5 |
| `quickcheck-cross` | moonbitlang/quickcheck@0.15.1 (property testing, fixed-property wrappers) | 3 | 3 |
| `parser-cross` | moonbitlang/parser@0.4.9 (MoonBit language parser) | 5 | 4 |

Each example supports:

```bash
cd examples/<name>
moon check --deny-warn && moon test --target native   # standalone verification
moon build --target native --release                  # build static archive
```

## Platform Support

| Platform | Artifact | Verification level |
|----------|----------|--------------------|
| Linux | `.a` → `.so` (gcc -shared) | **End-to-end proven** (`scripts/e2e_linux.sh`, runs on CI ubuntu) |
| Windows | `.lib` → `.dll` (clang-cl/MSVC) | Artifact-level (static archive & symbols verified locally) |
| iOS | `.a` → `.framework` (xcodebuild) | Artifact-level (requires macOS + Xcode) |
| Android | `.a` → `.so` (NDK clang) | Artifact-level (`doctor` detects ANDROID_NDK_HOME) |
| HarmonyOS | `.a` → `.so` (OHOS SDK clang) | Artifact-level (`doctor` detects OHOS_SDK) |

## License

[MIT License](./LICENSE) — 2026 walkzzz

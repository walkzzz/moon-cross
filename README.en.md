<div align="center">

# Moon Cross

### MoonBit Cross-Platform Native Framework

> Write once, deliver to five platforms — iOS / Android / Windows / HarmonyOS / Linux

[![Version](https://img.shields.io/badge/version-0.3.26-blue.svg)](./docs/changelog.md)
[![Tests](https://img.shields.io/badge/tests-2289-brightgreen.svg)]()
[![Packages](https://img.shields.io/badge/packages-80-green.svg)]()
[![Warnings](https://img.shields.io/badge/warnings-0-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![MoonBit](https://img.shields.io/badge/MoonBit-0.1.20260920-orange.svg)](https://moonbitlang.com)

**79 packages** · **2233 tests** · **700+ APIs** · **0 warnings** · **26 integration targets**

[中文](./README.md) · [Changelog](./docs/changelog.md) · [Roadmap](./docs/roadmap.md) · [Architecture](./docs/architecture.md) · [Contributing](./CONTRIBUTING.md)

</div>

---

## Table of Contents

- [Introduction](#introduction)
- [Core Features](#core-features)
- [Quick Start](#quick-start)
- [Architecture Overview](#architecture-overview)
- [Package Structure](#package-structure)
- [Type Mapping](#type-mapping)
- [Integration Tests](#integration-tests)
- [Technical Highlights](#technical-highlights)
- [Toolchain Ecosystem](#toolchain-ecosystem)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Moon Cross is a **MoonBit cross-platform native framework** that delivers any pure MoonBit library to four platforms with a single codebase. The framework provides a unified API abstraction layer, automatic FFI binding generation, per-platform runtime adaptation, and project templates.

**Workflow**: Developers declare exported function signatures → The framework automatically handles C code generation → Cross-compilation → FFI binding generation → Platform project packaging.

### Why Moon Cross?

| Feature | Moon Cross | Manual | Others |
|---------|:----------:|:------:|:------:|
| Four-platform delivery | ✅ | ❌ | Partial |
| Auto FFI bindings | ✅ | ❌ | Rare |
| Zero GC embedding | ✅ | ✅ | ❌ |
| Scaffold init | ✅ | ❌ | Rare |
| Incremental sync | ✅ | ❌ | ❌ |
| Type safety | ✅ | ❌ | Partial |

## Core Features

### CLI Tool

```bash
moon-cross <command> [options]
```

| Command | Description |
|---------|-------------|
| `build` | One-command four-platform cross-compilation |
| `check` | Validate configuration |
| `plan` | Show build plan |
| `init` | Initialize cross-platform project skeleton |
| `sync` | Incremental sync per-platform bindings |
| `doctor` | Environment diagnostics and dependency check |
| `publish` | mooncakes publishing preparation |
| `wizard` | Interactive project wizard |

### Core Capabilities

- **C adapter code generation** — Auto-generate C wrapper functions with runtime init, parameter conversion, and refcount management
- **Four-platform cross-compilation** — iOS (clang) / Android (NDK) / Windows (MSVC) / HarmonyOS (OHOS clang)
- **Automatic FFI binding generation** — JNI (Android) / NAPI+ArkTS (HarmonyOS) / DllImport (Windows) / Swift interop (iOS)
- **Type system support** — Scalars / strings / bytes / containers / structs, auto-mapped to each platform's native types
- **Scaffold + incremental sync** — `init` for instant cross-platform, `sync` for update propagation

### Toolchain Ecosystem

| Package | Function | Tests |
|---------|----------|:-----:|
| `benchmark` | Performance benchmarks (stats+comparison+suites) | 42 |
| `trace` | Compilation tracing and logging (events+spans+collector) | 38 |
| `linter` | Config lint rules (8 built-in rules) | 39 |
| `formatter` | Code formatter (indent+newline+rule engine) | 35 |
| `coverage` | Test coverage analysis (entries+reports+stats) | 38 |
| `watcher` | File watcher (events+filtering+dedup) | 25 |
| `diff` | Code diff analysis (line diff+format+reverse) | 30 |
| `dependency` | Dependency analysis (graph+cycle detection+topo sort) | 30 |

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/walkzzz/moon-cross.git
cd moon-cross

# Install MoonBit toolchain (requires moon >= 0.1.20260920)
# See https://moonbitlang.com
```

### Initialize a Project

```bash
# Initialize a cross-platform project
moon-cross init --name my-lib --platform all

# Generated project structure
my-lib/
├── moon.mod.json          # MoonBit module definition
├── moon-cross.json        # Cross-platform configuration
├── src/
│   └── my-lib.mbt         # MoonBit source code
├── ios/                   # iOS XCFramework project
├── android/               # Android NDK + JNI project
├── windows/               # Windows DllImport project
└── ohos/                  # HarmonyOS NAPI + ArkTS project
```

### Build and Sync

```bash
# Build for all four platforms
moon-cross build --config moon-cross.json --platform ios,android,windows,ohos

# Sync per-platform bindings after updating MoonBit code
moon-cross sync --config moon-cross.json

# Validate configuration
moon-cross check --config moon-cross.json

# Show build plan
moon-cross plan --config moon-cross.json

# Environment diagnostics
moon-cross doctor
```

## Architecture Overview

```
                    ┌─────────────────────────────────┐
                    │         MoonBit Source           │
                    │   (pure MoonBit, zero platform   │
                    │        dependency)               │
                    └──────────────┬──────────────────┘
                                   │ moon build --target native
                    ┌──────────────▼──────────────────┐
                    │       C Adapter Layer            │
                    │  (auto wrapper + refcount mgmt)  │
                    └──────────────┬──────────────────┘
                                   │ moon-cross codegen
                    ┌──────────────▼──────────────────┐
                    │     FFI Binding Generation       │
                    └──────┬───────┬───────┬──────────┘
                           │       │       │
              ┌────────────▼┐ ┌───▼───┐ ┌─▼──────────┐
              │  iOS        │ │ Android│ │ Windows    │
              │  Swift      │ │ JNI    │ │ DllImport  │
              │  XCFramework│ │ NDK    │ │ MSVC       │
              └─────────────┘ └────────┘ └────────────┘
                           │       │       │
              ┌────────────▼┐ ┌───▼───┐ ┌─▼──────────┐
              │  HarmonyOS  │ │       │ │            │
              │  NAPI+ArkTS  │ │       │ │            │
              │  OHOS clang  │ │       │ │            │
              └─────────────┘ └────────┘ └────────────┘
```

## Package Structure

```
moon-cross/
├── core/              # Core types and errors (Platform/Arch/TargetTriple)
├── config/            # moon-cross.json config parsing and validation
├── typesys/           # MoonBit → C → four-platform type mapping
├── codegen/           # Code generation engine
│   └── c/             #   C adapter generation
├── platform/          # Platform abstraction and implementation
│   ├── windows/       #   Windows MSVC cross-compilation
│   ├── android/       #   Android NDK cross-compilation
│   ├── ios/           #   iOS clang cross-compilation + XCFramework
│   └── ohos/          #   HarmonyOS OHOS cross-compilation
├── ffi/               # FFI binding generation
│   ├── jni/           #   JNI bindings (Android)
│   ├── swift/         #   Swift C interop (iOS)
│   └── napi/          #   NAPI bindings + ArkTS (HarmonyOS)
├── robust/            # Robustness (retry+recovery+validate+boundary)
├── security/          # Security (ASAN+FFI safety+sandbox+supply chain)
├── perf/              # Performance (parallel+cache+incremental+optimize)
├── docs/              # API doc generation
├── plugin/            # Plugin system + template library
├── discovery/         # Auto-discover export functions
├── diagnostic/        # Environment diagnostics (doctor command)
├── interactive/       # Interactive CLI (wizard+progress bar)
├── publish/           # mooncakes publishing tools
├── benchmark/         # Performance benchmarks (stats+comparison+suites)
├── trace/             # Compilation tracing and logging (events+spans+collector)
├── linter/            # Config lint rules (8 built-in rules)
├── formatter/         # Code formatter (indent+newline+rule engine)
├── coverage/          # Test coverage analysis (entries+reports+stats)
├── watcher/           # File watcher (events+filtering+dedup)
├── diff/              # Code diff analysis (line diff+format+reverse)
├── dependency/        # Dependency analysis (graph+cycle detection+topo sort)
├── integration/       # End-to-end integration tests (11 target libs)
├── scaffold/          # Scaffold (init cross-platform project)
├── sync/              # Incremental sync (auto-configure platforms after update)
├── cli/               # CLI entry point
└── examples/          # Example projects
    ├── zlib-cross/         # mizchi/zlib cross-platform export example
    ├── toml-cross/         # bobzhang/toml cross-platform export example
    ├── quickcheck-cross/   # moonbitlang/quickcheck cross-platform export example
    └── parser-cross/       # moonbitlang/parser cross-platform export example
```

## Type Mapping

| MoonBit | C Adapter | iOS (Swift) | Android (Kotlin) | Windows (C#) | HarmonyOS (ArkTS) |
|---------|-----------|-------------|------------------|--------------|-------------------|
| `Int` | `int32_t` | `Int32` | `Int` | `int` | `number` |
| `Double` | `double` | `Double` | `Double` | `double` | `number` |
| `Bool` | `int32_t` | `Bool` | `Boolean` | `bool` | `boolean` |
| `String` | `moonbit_string_t` | `String` | `String` | `string` | `string` |
| `Bytes` | `moonbit_bytes_t` | `Data` | `ByteArray` | `byte[]` | `Uint8Array` |
| `Array[T]` | `void*` | `UnsafePointer` | `Long` | `IntPtr` | `Object` |
| `Struct` | `void*` | `OpaquePointer` | `Long` | `IntPtr` | `Object` |

## Integration Tests

The framework has been verified with end-to-end cross-platform exports for the following mooncakes libraries:

| Library | Module Path | Exported Functions | Exported Types |
|---------|-------------|:------------------:|:--------------:|
| zlib | `mizchi/zlib` | 10 | 1 |
| openseek | `moonbitlang/openseek` | 5 | 0 |
| toml | `bobzhang/toml` | 5 | 2 |
| quickcheck | `moonbitlang/quickcheck` | 5 | 1 |
| parser | `moonbitlang/parser` | 5 | 1 |
| base64 | `moonbitlang/base64` | 5 | 0 |
| json | `moonbitlang/json` | 5 | 2 |
| hash | `moonbitlang/hash` | 5 | 0 |
| regexp | `moonbitlang/regexp` | 5 | 2 |
| uuid | `moonbitlang/uuid` | 5 | 1 |
| bufio | `moonbitlang/bufio` | 5 | 1 |

## Technical Highlights

1. **One compilation, four-platform delivery** — MoonBit native → C → iOS / Android / Windows / HarmonyOS
2. **Fills ecosystem gap** — First cross-platform (four-platform) MoonBit framework on mooncakes
3. **Platform-independent C code** — Runtime has zero platform dependencies, low embedding cost
4. **Automatic FFI binding generation** — Developers only declare function signatures; framework generates all platform bindings
5. **Refcount memory management** — No GC, suitable for embedded and performance-sensitive scenarios
6. **Scaffold + incremental sync** — `init` for instant cross-platform, `sync` for update propagation
7. **Full toolchain** — benchmark / trace / linter / formatter / coverage / watcher / diff / dependency
8. **2002 tests all passing** — 0 warnings, covering all 70 packages

## Toolchain Ecosystem

Moon Cross is not just a cross-platform framework — it provides a complete development toolchain:

```
Development → discovery (auto-discover) → linter (rule check) → formatter (format)
            → coverage (coverage) → benchmark (benchmarks) → trace (tracing)
            → diff (diff analysis) → dependency (dep analysis) → publish (publish)
```

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for development process, code conventions, and submission standards.

### Development Environment

```bash
# Clone and verify
git clone https://github.com/walkzzz/moon-cross.git
cd moon-cross
moon check   # 0 warnings
moon test    # 2002 tests passed
```

### Code Conventions

- **Bilingual comments**: All `///` comments use `/// Chinese | English` format
- **Package structure**: Hierarchical organization, no flat layout
- **Test coverage**: Every public function must have corresponding tests
- **Zero warnings**: `moon check` must produce zero warnings

## License

[MIT License](./LICENSE) — 2026 walkzzz
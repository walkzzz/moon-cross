# Moon Cross: MoonBit Cross-Platform Native Framework

> Write once, deliver to four platforms — iOS / Android / Windows / HarmonyOS

[中文](./README.md) | [Changelog](./docs/changelog.md) | [Roadmap](./docs/roadmap.md) | [Architecture](./docs/architecture.md)

**v1.0.0** | 21 packages | 489 tests | 200+ APIs | 0 warnings | MIT License

## Introduction

Moon Cross is a MoonBit cross-platform native framework that delivers any pure MoonBit library to four platforms with a single codebase. The framework provides a unified API abstraction layer, automatic FFI binding generation, per-platform runtime adaptation, and project templates. Developers only need to declare exported function signatures; the framework automatically handles: C code generation → cross-compilation → FFI binding generation → platform project packaging.

## Core Features

- **CLI tool**: `moon-cross build / check / plan / init / sync`
- **C adapter code generation**: auto-generate C wrapper functions with runtime init, parameter conversion, and refcount management
- **Four-platform cross-compilation**: iOS / Android / Windows / HarmonyOS
- **Automatic FFI binding generation**: JNI / NAPI / DllImport / Swift interop
- **Scaffold initialization**: `moon-cross init` generates a cross-platform project skeleton
- **Incremental sync**: `moon-cross sync` reconfigures per-platform bindings after MoonBit code updates
- **Type system support**: scalars / strings / bytes / containers / structs

## Quick Start

```bash
# Initialize a cross-platform project
moon-cross init --name my-lib --platform all

# Build for all four platforms
moon-cross build --config moon-cross.json --platform ios,android,windows,ohos

# Sync per-platform bindings after updating MoonBit code
moon-cross sync --config moon-cross.json

# Validate configuration
moon-cross check --config moon-cross.json

# Show build plan
moon-cross plan --config moon-cross.json
```

## Package Structure

```
moon-cross/
├── core/          # Core types and errors (Platform/Arch/TargetTriple)
├── config/        # moon-cross.json config parsing and validation
├── typesys/       # MoonBit → C → four-platform type mapping
├── codegen/       # Code generation engine
│   └── c/         #   C adapter generation
├── platform/      # Platform abstraction and implementation
│   ├── windows/   #   Windows platform
│   ├── android/   #   Android NDK cross-compilation
│   ├── ios/       #   iOS clang cross-compilation + XCFramework
│   └── ohos/      #   HarmonyOS OHOS cross-compilation
├── ffi/           # FFI binding generation
│   ├── jni/       #   JNI bindings (Android)
│   ├── swift/     #   Swift C interop (iOS)
│   └── napi/      #   NAPI bindings + ArkTS (HarmonyOS)
├── integration/   # End-to-end integration tests (mizchi/zlib)
├── scaffold/      # Scaffold (init cross-platform project)
├── sync/          # Incremental sync (auto-configure platforms after code update)
├── cli/           # CLI entry point
├── examples/      # Example projects
│   └── zlib-cross/  # mizchi/zlib cross-platform export example
└── docs/          # Documentation
```

## Technical Highlights

1. **One compilation, four-platform delivery** — MoonBit native → C → iOS/Android/Windows/HarmonyOS
2. **Fills ecosystem gap** — first cross-platform (four-platform) MoonBit framework on mooncakes
3. **Platform-independent C code** — runtime has zero platform dependencies
4. **Automatic FFI binding generation** — developers only declare function signatures
5. **Refcount memory management** — no GC, low embedding cost
6. **Scaffold + incremental sync** — initialize as cross-platform, sync on update

## License

MIT License
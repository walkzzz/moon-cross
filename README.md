<div align="center">

# Moon Cross

### MoonBit 跨平台 Native 框架

> 一次编写，五平台交付 — iOS / Android / Windows / 鸿蒙（HarmonyOS）/ Linux

[![Version](https://img.shields.io/badge/version-0.3.36-blue.svg)](./docs/changelog.md)
[![Tests](https://img.shields.io/badge/tests-2374%2B18-brightgreen.svg)]()
[![Packages](https://img.shields.io/badge/packages-80-green.svg)]()
[![Warnings](https://img.shields.io/badge/warnings-0-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![MoonBit](https://img.shields.io/badge/MoonBit-0.1.20261104-orange.svg)](https://moonbitlang.com)

**80 packages** · **2374 tests (main) + 18 tests (examples)** · **0 warnings** · **8 real CLI commands** · **4 runnable examples**

[English](./README.en.md) · [Changelog](./docs/changelog.md) · [Roadmap](./docs/roadmap.md) · [Contributing](./CONTRIBUTING.md)

</div>

---

## 目录

- [项目简介](#项目简介)
- [核心功能](#核心功能)
- [快速开始](#快速开始)
- [架构概览](#架构概览)
- [包结构](#包结构)
- [类型映射](#类型映射)
- [可运行示例](#可运行示例)
- [平台支持](#平台支持)
- [许可证](#许可证)

## 项目简介

Moon Cross 是一个 **MoonBit 跨平台 Native 框架**，将任意纯 MoonBit 库**一次编写，五平台交付**（iOS / Android / Windows / 鸿蒙 / Linux）。

框架基于 MoonBit native 后端的 **foreign_library + #export_name** 机制：MoonBit 代码编译为平台原生静态库（`.a`/`.lib`），框架自动生成 C 适配层、五平台 FFI 绑定代码与构建脚本，由外层 C 编译器封装为 `.so`/`.dll`/`.framework` 等动态产物。

## 核心功能

### CLI 工具（8 个真实命令）

```bash
moon-cross <command> [options]
```

| 命令 | 说明 | 状态 |
|------|------|:----:|
| `init` | 生成可构建的跨平台项目骨架（moon.mod + foreign_library 源码 + moon-cross.json + README） | ✅ |
| `build` | 读取 moon-cross.json，生成 C 适配层 + 五平台 FFI 绑定 + Makefile，落盘到输出目录 | ✅ |
| `check` | 校验配置：函数名唯一性、类型映射有效性、平台有效性 | ✅ |
| `plan` | 输出构建计划（dry-run） | ✅ |
| `sync` | 重新生成各平台绑定代码 | ✅ |
| `doctor` | 检测 moon 工具链与 C 编译器（clang-cl/clang/gcc/cc）与 NDK/OHOS SDK 环境 | ✅ |
| `publish` | moon.mod 元数据预检 + mooncakes 发布指引 | ✅ |
| `wizard` | 非交互展示 init 执行计划 | ✅ |

所有命令均真实读写磁盘（`moonbitlang/core/async/fs`），`doctor` 通过子进程探测（`core/async/process`）。

### 代码生成

- **C 适配层** — 运行时初始化、参数 marshalling、引用计数管理
- **五平台 FFI 绑定** — Swift interop (iOS) / JNI (Android) / DllImport (Windows) / NAPI+ArkTS (鸿蒙) / C header (Linux)
- **工程模板** — Makefile / CMake / Swift Package / Gradle / OHOS build profile / GitHub Actions

### 类型系统

标量（Int/Double/Bool/Unit）、String、Bytes、Array[T]、具名 Struct → 五平台原生类型映射；类型依赖无环检查。

## 快速开始

```bash
# 0. 准备（需 moon >= 0.1.20261104，https://www.moonbitlang.com/download）
git clone https://github.com/walkzzz/moon-cross.git
cd moon-cross

# 1. 验证框架自身（2374 测试）
moon check --deny-warn && moon test

# 2. 生成一个跨平台项目骨架（真实落盘 5 个文件）
moon run tools/cli -- init --name mylib --output mylib

# 3. 构建 mylib 为 native 静态库（含 #export_name 导出符号）
cd mylib && moon build --target native --release
# 产物：_build/native/release/build/src/src.a（Linux/macOS）/ src.lib（Windows）

# 4. 生成五平台 FFI 绑定与 Makefile（真实落盘 7 个文件）
moon run ../tools/cli -- build --config moon-cross.json --platform all --output moon-cross-output
```

端到端实证（Linux）：

```bash
bash scripts/e2e_linux.sh
# 脚手架 → 静态库 → C 宿主链接 → moonbit_init() → 调用导出函数 → 断言 PASS
# 第二段用真实第三方库 zlib-cross 走同样链路
```

## 架构概览

```
MoonBit 源码（纯 MoonBit 库，零平台依赖）
        │  moon build --target native --release（foreign_library + #export_name）
        ▼
平台原生静态库（src.a / src.lib）
        │  moon-cross build --config moon-cross.json
        ▼
┌─────────────────┬──────────────────┬─────────────────┐
│ C 适配层         │ 五平台 FFI 绑定    │ 构建脚本         │
│ wrapper + init  │ Swift/JNI/C#/    │ Makefile/CMake/ │
│ + 引用计数管理    │ NAPI/ArkTS/C头    │ build.sh        │
└────────┬────────┴────────┬─────────┴────────┬────────┘
         ▼                 ▼                  ▼
   各平台 C 编译器封装：-shared -fPIC → .so / .dll / .framework
```

## 包结构

```
moon-cross/                    # 80 packages, 10 一级分类
├── core/          # 核心类型 + trait + config（moon-cross.json 解析）+ typesys
├── testing/       # proof/mock/e2e/ai_test/crap/mutate/refactoring
├── platform/      # 5 平台编译配置（ios/android/windows/ohos/linux）+ executor
├── codegen/       # 代码生成引擎（C 适配层 + 15 类产物）+ FFI 绑定生成
├── integration/   # 端到端集成测试（20+ 目标库）
├── tools/         # cli（8 命令）/scaffold/builder/formatter/linter/docs/publish/plugin/...
├── runtime/       # cache/pool/timer/event/stream/sync/memory
├── analysis/      # coverage/profiler/benchmark/diff/discovery/perf
├── patterns/      # 设计模式（chain/visitor/observer/strategy/...）
├── security/      # security/robust/validator/crypto_util/http/uri
└── examples/      # 4 个真实第三方库导出示例（见下）
```

## 类型映射

| MoonBit | C | iOS (Swift) | Android (Kotlin) | Windows (C#) | 鸿蒙 (ArkTS) | Linux (C) |
|---------|---|-------------|------------------|--------------|--------------|-----------|
| `Int` | `int32_t` | `Int32` | `Int` | `int` | `number` | `int32_t` |
| `Double` | `double` | `Double` | `Double` | `double` | `number` | `double` |
| `Bool` | `int32_t` | `Bool` | `Boolean` | `bool` | `boolean` | `int32_t` |
| `Bytes` | `uint8_t*` | `Data` | `ByteArray` | `byte[]` | `Uint8Array` | `uint8_t*` |
| `String` | UTF-16 对象（经 UTF-8 转换层） | `String` | `String` | `string` | `string` | `char*` |
| `Array[T]` | 不透明指针 + 访问函数 | `UnsafePointer` | `Long` | `IntPtr` | `Object` | `void*` |

## 可运行示例

`examples/` 下 4 个示例均为**完整可构建的独立 MoonBit 模块**（真实 mooncakes 第三方库 + `#export_name` 导出层 + 测试 + moon-cross.json + README）：

| 示例 | 第三方库 | 导出函数 | 测试 |
|------|---------|:-------:|:----:|
| `zlib-cross` | mizchi/zlib@0.4.12（压缩/校验和，纯 MoonBit） | 9 | 6 |
| `toml-cross` | moonbit-community/toml@0.5.1（TOML 1.1 解析器） | 4 | 5 |
| `quickcheck-cross` | moonbitlang/quickcheck@0.15.1（属性测试，固定性质包装） | 3 | 3 |
| `parser-cross` | moonbitlang/parser@0.4.9（MoonBit 语言解析器） | 5 | 4 |

每个示例支持：

```bash
cd examples/<name>
moon check --deny-warn && moon test --target native   # 独立验证
moon build --target native --release                  # 构建静态库
```

## 平台支持

| 平台 | 产物 | 验证级别 |
|------|------|---------|
| Linux | `.a` → `.so`（gcc -shared） | **端到端实证**（`scripts/e2e_linux.sh`：生成→编译→C 调用→断言，CI ubuntu 跑） |
| Windows | `.lib` → `.dll`（clang-cl/MSVC） | 产物级（本机已验证静态库与符号导出；动态封装需 MSVC 环境） |
| iOS | `.a` → `.framework`（xcodebuild） | 产物级（需 macOS + Xcode，CI matrix 预留） |
| Android | `.a` → `.so`（NDK clang） | 产物级（需 NDK，`doctor` 检测 ANDROID_NDK_HOME） |
| 鸿蒙 | `.a` → `.so`（OHOS SDK clang） | 产物级（需 DevEco/OHOS SDK，`doctor` 检测 OHOS_SDK） |

MoonBit 侧全平台一致：native 后端产物为静态库，`#export_name` 提供稳定 C 符号，`moonbit_init()` 完成运行时初始化。

## 许可证

[MIT License](./LICENSE) — 2026 walkzzz

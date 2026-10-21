<div align="center">

# Moon Cross

### MoonBit 跨平台 Native 框架

> 一次编写，五平台交付 — iOS / Android / Windows / 鸿蒙（HarmonyOS）/ Linux

[![Version](https://img.shields.io/badge/version-0.3.9-blue.svg)](./docs/changelog.md)
[![Tests](https://img.shields.io/badge/tests-2170-brightgreen.svg)]()
[![Packages](https://img.shields.io/badge/packages-76-green.svg)]()
[![Warnings](https://img.shields.io/badge/warnings-0-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![MoonBit](https://img.shields.io/badge/MoonBit-0.1.20260920-orange.svg)](https://moonbitlang.com)

**76 packages** · **2170 tests** · **700+ APIs** · **0 warnings** · **26 集成目标**

[English](./README.en.md) · [Changelog](./docs/changelog.md) · [Roadmap](./docs/roadmap.md) · [Architecture](./docs/architecture.md) · [Contributing](./CONTRIBUTING.md)

</div>

---

## 目录

- [项目简介](#项目简介)
- [核心功能](#核心功能F)
- [快速开始](#快速开始)
- [架构概览](#架构概览)
- [包结构](#包结构)
- [类型映射](#类型映射)
- [集成测试](#集成测试)
- [技术亮点](#技术亮点)
- [工具链生态](#工具链生态)
- [贡献指南](#贡献指南)
- [许可证](#许可证)

## 项目简介

Moon Cross 是一个 **MoonBit 跨平台 Native 框架**，将任意纯 MoonBit 库**一次编写，四平台交付**。框架提供统一的 API 抽象层、自动 FFI 绑定生成、各平台运行时适配和工程模板。

**工作流程**：开发者只需声明导出函数签名 → 框架自动完成 C 代码生成 → 各平台交叉编译 → FFI 绑定代码生成 → 平台工程打包。

### 为什么选择 Moon Cross？

| 特性 | Moon Cross | 手动适配 | 其他框架 |
|------|:----------:|:--------:|:--------:|
| 四平台交付 | ✅ | ❌ | 部分 |
| 自动 FFI 绑定 | ✅ | ❌ | 罕见 |
| 零 GC 嵌入 | ✅ | ✅ | ❌ |
| 脚手架初始化 | ✅ | ❌ | 罕见 |
| 增量同步 | ✅ | ❌ | ❌ |
| 类型安全 | ✅ | ❌ | 部分 |

## 核心功能

### CLI 工具

```bash
moon-cross <command> [options]
```

| 命令 | 说明 |
|------|------|
| `build` | 一键四平台交叉编译 |
| `check` | 验证配置正确性 |
| `plan` | 查看构建计划 |
| `init` | 初始化跨平台项目骨架 |
| `sync` | 增量同步各平台绑定代码 |
| `doctor` | 环境诊断与依赖检查 |
| `publish` | mooncakes 发布准备 |
| `wizard` | 交互式项目向导 |

### 核心能力

- **C 适配层代码生成** — 自动生成 C wrapper 函数，处理运行时初始化、参数转换、引用计数管理
- **四平台交叉编译** — iOS (clang) / Android (NDK) / Windows (MSVC) / 鸿蒙 (OHOS clang)
- **自动 FFI 绑定生成** — JNI (Android) / NAPI+ArkTS (鸿蒙) / DllImport (Windows) / Swift interop (iOS)
- **类型系统支持** — 标量 / 字符串 / 字节 / 容器 / Struct，自动映射到各平台原生类型
- **脚手架 + 增量同步** — `init` 一键跨平台，`sync` 更新即同步

### 工具链生态

| 包 | 功能 | 测试数 |
|----|------|:------:|
| `benchmark` | 性能基准测试（统计+比较+套件） | 42 |
| `trace` | 编译追踪与日志（事件+区间+收集器） | 38 |
| `linter` | 配置 lint 规则（8 内置规则） | 39 |
| `formatter` | 代码格式化（缩进+换行+规则引擎） | 35 |
| `coverage` | 测试覆盖率分析（条目+报告+统计） | 38 |
| `watcher` | 文件监视器（事件+过滤+去重） | 25 |
| `diff` | 代码差异分析（行差异+格式化+反转） | 30 |
| `dependency` | 依赖分析（图+环检测+拓扑排序） | 30 |

## 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/walkzzz/moon-cross.git
cd moon-cross

# 安装 MoonBit 工具链（需 moon >= 0.1.20260920）
# 参考 https://moonbitlang.com
```

### 初始化项目

```bash
# 初始化跨平台项目
moon-cross init --name my-lib --platform all

# 生成的项目结构
my-lib/
├── moon.mod.json          # MoonBit 模块定义
├── moon-cross.json        # 跨平台配置
├── src/
│   └── my-lib.mbt         # MoonBit 源码
├── ios/                   # iOS XCFramework 工程
├── android/               # Android NDK + JNI 工程
├── windows/               # Windows DllImport 工程
└── ohos/                  # 鸿蒙 NAPI + ArkTS 工程
```

### 编译与同步

```bash
# 一键四平台编译
moon-cross build --config moon-cross.json --platform ios,android,windows,ohos

# 更新 MoonBit 代码后同步各平台绑定
moon-cross sync --config moon-cross.json

# 验证配置
moon-cross check --config moon-cross.json

# 查看构建计划
moon-cross plan --config moon-cross.json

# 环境诊断
moon-cross doctor
```

## 架构概览

```
                    ┌─────────────────────────────────┐
                    │         MoonBit 源码             │
                    │    (纯 MoonBit 库，零平台依赖)    │
                    └──────────────┬──────────────────┘
                                   │ moon build --target native
                    ┌──────────────▼──────────────────┐
                    │         C 适配层代码              │
                    │  (自动生成 wrapper + 引用计数管理)  │
                    └──────────────┬──────────────────┘
                                   │ moon-cross codegen
                    ┌──────────────▼──────────────────┐
                    │       FFI 绑定代码生成            │
                    └──────┬───────┬───────┬──────────┘
                           │       │       │
              ┌────────────▼┐ ┌───▼───┐ ┌─▼──────────┐
              │  iOS        │ │ Android│ │ Windows    │
              │  Swift      │ │ JNI    │ │ DllImport  │
              │  XCFramework│ │ NDK    │ │ MSVC       │
              └─────────────┘ └────────┘ └────────────┘
                           │       │       │
              ┌────────────▼┐ ┌───▼───┐ ┌─▼──────────┐
              │  鸿蒙        │ │       │ │            │
              │  NAPI+ArkTS  │ │       │ │            │
              │  OHOS clang  │ │       │ │            │
              └─────────────┘ └────────┘ └────────────┘
```

## 包结构

```
moon-cross/
├── core/              # 核心类型与错误（Platform/Arch/TargetTriple）
├── config/            # moon-cross.json 配置解析与校验
├── typesys/           # MoonBit → C → 四平台类型映射
├── codegen/           # 代码生成引擎
│   └── c/             #   C 适配层生成
├── platform/          # 平台抽象与实现
│   ├── windows/       #   Windows MSVC 交叉编译
│   ├── android/       #   Android NDK 交叉编译
│   ├── ios/           #   iOS clang 交叉编译 + XCFramework
│   └── ohos/          #   鸿蒙 OHOS 交叉编译
├── ffi/               # FFI 绑定生成
│   ├── jni/           #   JNI 绑定（Android）
│   ├── swift/         #   Swift C interop（iOS）
│   └── napi/          #   NAPI 绑定 + ArkTS（鸿蒙）
├── robust/            # 鲁棒性（重试+恢复+校验+边界）
├── security/          # 安全性（ASAN+FFI安全+沙箱+供应链）
├── perf/              # 性能（并行+缓存+增量+优化）
├── docs/              # API 文档生成
├── plugin/            # 插件机制 + 模板库
├── discovery/         # 自动发现导出函数
├── diagnostic/        # 环境诊断（doctor 命令）
├── interactive/       # 交互式 CLI（向导+进度条）
├── publish/           # mooncakes 发布工具
├── benchmark/         # 性能基准测试（统计+比较+套件）
├── trace/             # 编译追踪与日志（事件+区间+收集器）
├── linter/            # 配置 lint 规则（8 内置规则）
├── formatter/         # 代码格式化（缩进+换行+规则引擎）
├── coverage/          # 测试覆盖率分析（条目+报告+统计）
├── watcher/           # 文件监视器（事件+过滤+去重）
├── diff/              # 代码差异分析（行差异+<format+反转）
├── dependency/        # 依赖分析（图+环检测+拓扑排序）
├── integration/       # 端到端集成测试（11 个目标库）
├── scaffold/          # 脚手架（init 初始化跨平台项目）
├── sync/              # 增量同步（更新代码后自动配置各平台）
├── cli/               # CLI 入口
└── examples/          # 示例项目
    ├── zlib-cross/         # mizchi/zlib 跨平台导出示例
    ├── toml-cross/         # bobzhang/toml 跨平台导出示例
    ├── quickcheck-cross/   # moonbitlang/quickcheck 跨平台导出示例
    └── parser-cross/       # moonbitlang/parser 跨平台导出示例
```

## 类型映射

| MoonBit | C 适配层 | iOS (Swift) | Android (Kotlin) | Windows (C#) | 鸿蒙 (ArkTS) |
|---------|---------|-------------|-----------------|-------------|-------------|
| `Int` | `int32_t` | `Int32` | `Int` | `int` | `number` |
| `Double` | `double` | `Double` | `Double` | `double` | `number` |
| `Bool` | `int32_t` | `Bool` | `Boolean` | `bool` | `boolean` |
| `String` | `moonbit_string_t` | `String` | `String` | `string` | `string` |
| `Bytes` | `moonbit_bytes_t` | `Data` | `ByteArray` | `byte[]` | `Uint8Array` |
| `Array[T]` | `void*` | `UnsafePointer` | `Long` | `IntPtr` | `Object` |
| `Struct` | `void*` | `OpaquePointer` | `Long` | `IntPtr` | `Object` |

## 集成测试

框架已验证与以下 mooncakes 库的端到端跨平台导出：

| 库 | 模块路径 | 导出函数 | 导出类型 |
|----|---------|:--------:|:--------:|
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

## 技术亮点

1. **一次编译，四平台交付** — MoonBit native → C → iOS / Android / Windows / 鸿蒙
2. **填补生态空白** — mooncakes 首个跨平台（四平台）MoonBit 框架
3. **C 代码平台无关** — runtime 零平台依赖，嵌入成本低
4. **自动 FFI 绑定生成** — 开发者只需声明函数签名，框架自动生成各平台绑定
5. **引用计数内存管理** — 非 GC，适合嵌入式和性能敏感场景
6. **脚手架 + 增量同步** — `init` 即跨平台，`sync` 更新即同步
7. **全链路工具链** — benchmark / trace / linter / formatter / coverage / watcher / diff / dependency
8. **1096 个测试全通过** — 0 warnings，覆盖所有 35 个包

## 工具链生态

Moon Cross 不仅是一个跨平台框架，还提供完整的开发工具链：

```
开发流程 → discovery（自动发现）→ linter（规则检查）→ formatter（格式化）
         → coverage（覆盖率）→ benchmark（基准测试）→ trace（追踪）
         → diff（差异分析）→ dependency（依赖分析）→ publish（发布）
```

## 贡献指南

欢迎贡献代码！请阅读 [CONTRIBUTING.md](./CONTRIBUTING.md) 了解开发流程、代码规范和提交标准。

### 开发环境

```bash
# 克隆并检查
git clone https://github.com/walkzzz/moon-cross.git
cd moon-cross
moon check   # 0 warnings
moon test    # 2002 tests passed
```

### 代码规范

- **三级注释**：所有 `///` 注释使用中英双文格式 `/// 中文 | English`
- **包结构**：分层组织，禁止平铺
- **测试覆盖**：每个公开函数需有对应测试
- **0 warnings**：`moon check` 必须零警告

## 许可证

[MIT License](./LICENSE) — 2026 walkzzz
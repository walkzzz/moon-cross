# Architecture

> Moon Cross 架构文档 | Moon Cross Architecture Document

## 包结构（分层，禁止平铺）

```
src/
├── core/              # 核心类型与错误（Platform/Arch/TargetTriple/MoonCrossError）
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
├── diff/              # 代码差异分析（行差异+格式化+反转）
├── dependency/        # 依赖分析（图+环检测+拓扑排序）
├── integration/       # 端到端集成测试（11 个目标库）
├── scaffold/          # 脚手架（init 初始化跨平台项目）
├── sync/              # 增量同步（更新代码后自动配置各平台）
└── cli/               # CLI 入口（main 包）
```

## 依赖层次

```
core（无依赖）
  ← config, typesys
    ← codegen, codegen/c, platform/*, ffi/*
      ← scaffold, sync
        ← cli
```

## 分层架构图

```
┌─────────────────────────────────────────────────────────┐
│                    CLI 入口层 (cli)                      │
│  build · check · plan · init · sync · doctor · publish  │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                  工具链生态层 (toolchain)                 │
│  benchmark · trace · linter · formatter · coverage       │
│  watcher · diff · dependency · discovery · diagnostic    │
│  interactive · publish · docs · plugin                   │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                  质量保证层 (quality)                     │
│  robust (重试+恢复+校验+边界)                              │
│  security (ASAN+FFI安全+沙箱+供应链)                       │
│  perf (并行+缓存+增量+优化)                                │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                  代码生成层 (codegen)                     │
│  codegen/c (C 适配层) · ffi/jni · ffi/swift · ffi/napi   │
│  scaffold (脚手架) · sync (增量同步)                       │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                  平台抽象层 (platform)                    │
│  platform/windows · platform/android                     │
│  platform/ios · platform/ohos                            │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                  核心基础层 (core)                        │
│  Platform · Arch · TargetTriple · MoonCrossError         │
│  config (配置解析) · typesys (类型映射)                    │
└─────────────────────────────────────────────────────────┘
```

## 编译流水线

```
MoonBit 源码
    │
    │ moon build --target native
    ▼
C 代码 (平台无关)
    │
    │ moon-cross codegen
    ▼
C 适配层 (wrapper + 引用计数)
    │
    ├──→ iOS:          clang --target arm64-apple-ios → XCFramework
    ├──→ Android:      NDK clang --target aarch64-linux-android → .so
    ├──→ Windows:      MSVC cl.exe → .dll
    └──→ HarmonyOS:    OHOS clang --target aarch64-linux-ohos → .so
    │
    │ moon-cross ffi
    ▼
FFI 绑定代码
    ├──→ iOS:          Swift Package.swift + modulemap + bridging header
    ├──→ Android:      JNI Java/Kotlin bindings + Gradle module
    ├──→ Windows:      C# DllImport + NuGet package
    └──→ HarmonyOS:    NAPI + ArkTS import + oh-package.json5
```

## 设计原则

- **分层架构**：core ← config ← typesys ← codegen ← platform ← ffi ← scaffold/sync ← cli
- **禁止平铺**：每个职责独立包，子包层次清晰
- **pub(all) 可见性**：跨包构造的类型用 `pub(all)` 标记
- **derive(Debug, Eq)**：数据类型自动派生 Debug 和 Eq
- **三级注释**：所有 `///` 注释使用中英双文格式 `/// 中文 | English`
- **零警告**：`moon check` 必须产生 0 个 warning

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

## 集成测试架构

```
src/integration/
├── zlib_config.mbt              # mizchi/zlib 配置
├── zlib_pipeline.mbt            # zlib 流水线
├── openseek_config.mbt          # moonbitlang/openseek 配置
├── openseek_pipeline.mbt        # openseek 流水线
├── toml_config.mbt              # bobzhang/toml 配置
├── toml_pipeline.mbt            # toml 流水线
├── quickcheck_config.mbt        # moonbitlang/quickcheck 配置
├── quickcheck_pipeline.mbt      # quickcheck 流水线
├── parser_config.mbt            # moonbitlang/parser 配置
├── parser_pipeline.mbt          # parser 流水线
├── base64_json_hash_config.mbt  # base64+json+hash 配置
├── base64_json_hash_pipeline.mbt# base64+json+hash 流水线
├── regexp_uuid_bufio_config.mbt # regexp+uuid+bufio 配置
└── regexp_uuid_bufio_pipeline.mbt # regexp+uuid+bufio 流水线
```

每个集成测试验证：
1. 导出函数签名正确性
2. C 适配层头文件生成
3. 四平台编译命令生成
4. 四平台 FFI 绑定类型匹配
5. 完整流水线端到端验证

## 统计

| 指标 | 数值 |
|------|------|
| 总包数 | 35 |
| 总测试数 | 1096 |
| 总 API 数 | 550+ |
| Warning 数 | 0 |
| 集成目标数 | 11 |
| 代码生成目标 | 4 平台 |
| FFI 绑定类型 | 4 (JNI/NAPI/DllImport/Swift) |
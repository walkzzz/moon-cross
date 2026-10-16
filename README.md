# Moon Cross：MoonBit 跨平台 Native 框架

> 一次编写，四平台交付 — iOS / Android / Windows / 鸿蒙（HarmonyOS）

[English](./README.md) | [Changelog](./docs/changelog.md) | [Roadmap](./docs/roadmap.md) | [Architecture](./docs/architecture.md)

**v0.1.9** | 30 packages | 904 tests | 430+ APIs | 0 warnings | MIT License

## 项目简介

Moon Cross 是一个 MoonBit 跨平台 Native 框架，将任意纯 MoonBit 库**一次编写，四平台交付**。框架提供统一的 API 抽象层、自动 FFI 绑定生成、各平台运行时适配和工程模板，开发者只需声明导出函数签名，框架自动完成：C 代码生成 → 各平台交叉编译 → FFI 绑定代码生成 → 平台工程打包。

## 核心功能

- **CLI 工具**：`moon-cross build / check / plan / init / sync`
- **C 适配层代码生成**：自动生成 C wrapper 函数，处理运行时初始化、参数转换、引用计数管理
- **四平台交叉编译**：iOS / Android / Windows / 鸿蒙
- **自动 FFI 绑定生成**：JNI / NAPI / DllImport / Swift interop
- **脚手架初始化**：`moon-cross init` 一键生成跨平台项目骨架
- **增量同步**：`moon-cross sync` 更新 MoonBit 代码后自动重新配置各平台绑定代码
- **类型系统支持**：标量 / 字符串 / 字节 / 容器 / Struct

## 快速开始

```bash
# 初始化跨平台项目
moon-cross init --name my-lib --platform all

# 一键四平台编译
moon-cross build --config moon-cross.json --platform ios,android,windows,ohos

# 更新 MoonBit 代码后同步各平台绑定
moon-cross sync --config moon-cross.json

# 验证配置
moon-cross check --config moon-cross.json

# 查看构建计划
moon-cross plan --config moon-cross.json
```

## 包结构

```
moon-cross/
├── core/          # 核心类型与错误（Platform/Arch/TargetTriple）
├── config/        # moon-cross.json 配置解析与校验
├── typesys/       # MoonBit → C → 四平台类型映射
├── codegen/       # 代码生成引擎
│   └── c/         #   C 适配层生成
├── platform/      # 平台抽象与实现
│   ├── windows/   #   Windows 平台
│   ├── android/   #   Android NDK 交叉编译
│   ├── ios/       #   iOS clang 交叉编译 + XCFramework
│   └── ohos/      #   鸿蒙 OHOS 交叉编译
├── ffi/           # FFI 绑定生成
│   ├── jni/       #   JNI 绑定（Android）
│   ├── swift/     #   Swift C interop（iOS）
│   └── napi/      #   NAPI 绑定 + ArkTS（鸿蒙）
├── robust/        # 鲁棒性（重试+恢复+校验+边界）
├── security/      # 安全性（ASAN+FFI安全+沙箱+供应链）
├── perf/          # 性能（并行+缓存+增量+优化）
├── docs/          # API 文档生成
├── plugin/        # 插件机制 + 模板库
├── discovery/     # 自动发现导出函数
├── diagnostic/    # 环境诊断（doctor 命令）
├── interactive/   # 交互式 CLI（向导+进度条）
├── publish/       # mooncakes 发布工具
├── integration/   # 端到端集成测试（zlib+openseek+toml+quickcheck+parser）
├── scaffold/      # 脚手架（init 初始化跨平台项目）
├── sync/          # 增量同步（更新代码后自动配置各平台）
├── cli/           # CLI 入口
├── examples/      # 示例项目
│   ├── zlib-cross/       # mizchi/zlib 跨平台导出示例
│   ├── toml-cross/       # bobzhang/toml 跨平台导出示例
│   ├── quickcheck-cross/ # moonbitlang/quickcheck 跨平台导出示例
│   └── parser-cross/     # moonbitlang/parser 跨平台导出示例
└── docs/          # 文档
```

## 技术亮点

1. **一次编译，四平台交付** — MoonBit native → C → iOS/Android/Windows/鸿蒙
2. **填补生态空白** — mooncakes 首个跨平台（四平台）MoonBit 框架
3. **C 代码平台无关** — runtime 零平台依赖
4. **自动 FFI 绑定生成** — 开发者只需声明函数签名
5. **引用计数内存管理** — 非 GC，嵌入成本低
6. **脚手架 + 增量同步** — 初始化即跨平台，更新即同步

## 许可证

MIT License
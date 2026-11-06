# 包分类与收缩计划 | Package Classification & Trimming Plan

> 评审意见 P4：80 个包中 81% 是通用工具，与跨平台编译无关。
> 本文档明确核心包与辅助包的边界，制定收缩计划。

## 分类标准

- **核心包**：与"MoonBit 跨平台原生编译"直接相关的包
- **辅助包**：通用工具/运行时/设计模式，可独立发布或贡献到 MoonBit 标准库

## 核心包（21 个）— 跨平台编译使命

| 包路径 | 职责 | 保留理由 |
|--------|------|----------|
| `core/core` | Platform/Arch/TargetTriple 核心类型 | 框架基石 |
| `core/config` | moon-cross.json 配置解析 | 编译配置 |
| `core/typesys` | MoonBit→C 类型映射 | codegen 依赖 |
| `core/trait` | 公共 trait 定义 | 抽象层 |
| `platform/platform` | 平台规格 + 编译执行器 | 5 平台编译 |
| `platform/platform/android` | Android NDK 编译 | 平台覆盖 |
| `platform/platform/ios` | iOS clang 编译 | 平台覆盖 |
| `platform/platform/windows` | Windows clang-cl 编译 | 平台覆盖 |
| `platform/platform/ohos` | 鸿蒙 OHOS 编译 | 平台覆盖 |
| `platform/platform/linux` | Linux gcc 编译 | 平台覆盖 |
| `codegen/codegen` | 代码生成引擎 | 核心卖点 |
| `codegen/codegen/c` | C wrapper 生成 | codegen 子模块 |
| `codegen/ffi` | FFI 绑定类型 | codegen 子模块 |
| `codegen/ffi/jni` | JNI 绑定生成 | Android FFI |
| `codegen/ffi/swift` | Swift interop 生成 | iOS FFI |
| `codegen/ffi/napi` | NAPI 绑定生成 | 鸿蒙 FFI |
| `integration/integration` | 集成 pipeline | 端到端验证 |
| `integration/pinyin_integration` | pinyin 集成示例 | 集成示例 |
| `tools/cli` | CLI 命令分发 | 用户入口 |
| `tools/scaffold` | 脚手架生成 | 项目初始化 |
| `runtime/sync` | 增量同步 | 代码更新同步 |

## 辅助包（60 个）— 通用工具，可拆分

### testing/（7 个）— 多手段测试框架
| 包路径 | 职责 | 拆分建议 |
|--------|------|----------|
| `testing/proof` | 契约检查 | 保留（测试基础设施） |
| `testing/mock` | Mock 框架 | 保留 |
| `testing/e2e` | E2E + 编译验证 | 保留 |
| `testing/ai_test` | AI 测试 | 可拆到 `moon-testing` |
| `testing/crap` | CRAP 指标 | 可拆到 `moon-testing` |
| `testing/mutate` | 变异测试 | 可拆到 `moon-testing` |
| `testing/refactoring` | 重构辅助 | 可拆到 `moon-testing` |

### runtime/（13 个）— 运行时设施 → 可拆到 `moon-stdlib`
cache, compress, concurrency, event, logging, memory, pool, resource, scheduler, signal, stream, timer
（sync 已列入核心包）

### security/（11 个）— 安全/工具 → 可拆到 `moon-stdlib`
algorithm, argparse, crypto_util, http, regex_enhanced, robust, security, serializer, template, uri, validator

### patterns/（10 个）— 设计模式 → 可拆到 `moon-patterns`
chain, factory, interpreter, memento, observer, proxy, state_pattern, state, strategy, visitor

### analysis/（11 个）— 分析工具 → 可拆到 `moon-analysis`
benchmark, cov, dependency, diagnostic, diff, discovery, graph, perf, profiler, trace, watcher

### tools/ 其他（8 个）— 工具 → 部分保留
builder, command, docs, formatter, interactive, linter, plugin, publish

## 收缩计划

### 短期（v0.3.x）— 不拆分，但停止扩展
- 不再向 `runtime/`、`security/`、`patterns/` 添加新包
- 新功能优先复用现有包
- 在 AGENTS.md 中标记核心包 vs 辅助包

### 中期（v0.4.x）— 标记可选依赖
- 辅助包标记为 `optional-dependency`
- 核心包不依赖辅助包（除 testing）
- 用户可按需启用辅助包

### 长期（v1.0.x）— 拆分独立仓库
- `moon-stdlib`：runtime/ + security/（24 包）
- `moon-patterns`：patterns/（10 包）
- `moon-analysis`：analysis/（11 包）
- `moon-testing`：testing/ 部分（4 包）
- moon-cross 核心保留 ~21 包

## 当前状态（v0.3.33）

- 核心包：21 个（26%）
- 辅助包：60 个（74%）
- 总计：81 个
- 目标：核心包占比提升至 50%+（通过拆分辅助包）
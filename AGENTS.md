# Moon Cross — 项目 Agent 指南

> MoonBit 跨平台 Native 框架 | 2026 MoonBit 十月赛参赛项目 | 参赛者 walkzzz

## 项目定位

**Moon Cross** 是一个 MoonBit 跨平台 Native 框架，将任意纯 MoonBit 库一次编写，多平台交付（iOS/Android/Windows/鸿蒙/Linux）。

## 当前状态

- **77 包** · **2193 测试** · **0 warnings** · **5 平台**
- **14 个 trait 定义** · **157+ trait 实现** · **68/77 包有 trait（88% 覆盖）**
- R1-R19 规则全合规
- 工具链：MoonBit v0.1.20260920

## 项目结构

```
moon-cross/
├── moon.mod / moon.pkg / reexport.mbt   # 根包统一入口
├── core/          # 核心类型 + trait + config + typesys
├── testing/       # proof/mock/e2e/ai_test/crap/mutate/refactoring
├── platform/      # 5 平台编译配置（ios/android/windows/ohos/linux）
├── codegen/       # 代码生成引擎 + FFI 绑定
├── integration/   # 集成目标库 pipeline
├── tools/         # CLI/scaffold/builder/formatter/linter/docs/publish
├── runtime/       # cache/pool/timer/event/stream/sync/memory
├── analysis/      # coverage/profiler/benchmark/diff/discovery/perf
├── patterns/      # 设计模式（chain/visitor/observer/strategy/state/...）
├── security/      # security/robust/validator/crypto/algorithm/http/uri
└── docs/
    ├── rules.md       # R1-R19 规则全集
    ├── roadmap.md     # 迭代路线
    ├── changelog.md   # 变更日志
    └── arch_test_report.md  # 多手段测试报告
```

## 规则要点（R1-R19）

- **R1** 源码在 `src/` 下按职责分包
- **R2** 多手段测试：形式化证明 + AI/FAKE/MOCK/E2E
- **R3** 所有 `pub fn` 必须有 `///` 注释
- **R4** 每个子包有 README.md
- **R13** Warning 治理目标 0，禁止简单抑制
- **R16** 连续迭代不停顿
- **R17** 五类多手段测试全 Pass 才放行
- **R18** 优先用 `pub(open) trait` 抽象公共行为
- **R19** 尽可能使用 trait，新代码必须优先 trait 化

## Trait 系统

14 个 `pub(open) trait`：
- `Named` / `Checkable` / `Resettable` / `Verifiable` / `Runnable`
- `Countable` / `Describable` / `Summarizable` / `Cloneable` / `Serializable`
- `Iterable` / `Versioned` / `Ordered` / `Displayable`

子特征层次：
- `Verifiable : Checkable`
- `Displayable : Named + Describable`

## MoonBit 技术要点

| 要点 | 说明 |
|------|------|
| 方法定义 | `fn Type::meth(self : Type, ..)`（新语法）|
| 布尔取反 | `!expr`（`not(x)` 已废弃）|
| trait impl | `pub impl Trait for Type with method` + `pub extend Type with Trait::{method}` |
| `pub(open) trait` | 跨包实现必须用 `pub(open)` |
| derive | `derive(Debug, Eq)` + `pub extend Type with Trait::{method}` |
| 文件名陷阱 | 源文件名不能含 `_test`（会被视为测试文件）|
| Array.push | 不需要 `mut`（Array 默认可变）|
| range | `0..<n`（排他）/ `0..=n`（包含）|
| 字符串插值 | `\{expr}` 需 expr 实现 Show |
| 跨包导入 | `walkzzz/moon-cross/src/pkg_name` |

## 常用命令

```bash
moon check                    # 类型检查 + warning 治理（目标 0）
moon test                     # 运行全量测试
moon fmt                      # 格式化
moon info                     # 生成 .mbti，检查 API 变更
moon clean                    # 切换版本后必须先 clean
moon coverage analyze         # 分析未覆盖代码
```

## Sprint 迭代流程

1. 查架构 → 2. 实现 → 3. 验证 → 4. Warning 治理 → 5. 重导出 → 6. 文档治理 → 7. 经验沉淀 → 8. 提交

## 验收门禁

- `moon check` 0 warning 0 error
- `moon test` 全通过
- 所有 `pub fn` 有 `///` 注释
- roadmap 状态 + commit hash 已回写

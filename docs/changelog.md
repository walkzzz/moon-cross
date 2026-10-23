# Changelog

## v0.3.22 (2026-10-23) — pinyin@0.1.0 集成测试

### Highlights
- 添加 `walkzzz/pinyin@0.1.0` 依赖
- 新增 `integration/pinyin_integration/` 包（8 个测试）
  - 中文检测：`contains_chinese` / `is_chinese`
  - 拼音转换：`convert_chinese` / `convert_with_tone` / `convert_without_tone`
  - 首字母提取：`get_short_pinyin`
  - 混合字符串处理：中英文混合
- 所有测试通过

### Stats
- 新增包: integration/pinyin_integration/（1 个）
- 新增测试: 8 个（总计 2261 个，全部通过）
- 包数: 80
- Warning: 0

## v0.3.21 (2026-10-23) — 所有高 CRAP 函数清零

### Highlights
- 重构最后一个高 CRAP 函数 `parse_args`（complexity 21→7）
  - 提取 4 个辅助函数：`match_option_def` / `parse_long_opt` / `parse_short_opt` / `check_required_args`
- **高复杂度函数(≥12): 1 → 0**（全部清零）
- **平均 CRAP: 1.9**
- 更新 AGENTS/AGENTS.md 项目结构（移除 src/ 引用）

### Stats
- 包数: 79（不变）
- 测试: 2253（不变）
- 平均 CRAP: 1.9
- 高复杂度(≥12): 0
- 变异分数: 100%
- Warning: 0

## v0.3.20 (2026-10-23) — 高 CRAP 函数重构：平均 1.9

### Highlights
- 重构 2 个高 CRAP 函数（if-else → match）
  - `status_text`: complexity 15 → 2（match 替代 14 个 if-else）
  - `method_from_string`: complexity 7 → 2（match 替代 6 个 if-else）
- 重构 `affected_platforms`：提取辅助函数消除重复
  - complexity 20 → 8（提取 `platform_exists` + `add_platform_if_new`）
- **平均 CRAP: 2.0 → 1.9**
- 高复杂度函数: 3 → 1（仅剩 `parse_args` = 21）
- trait 实现: 184 个跨 71 包

### Stats
- 包数: 79（不变）
- 测试: 2253（不变）
- 平均 CRAP: 1.9
- 变异分数: 100%
- Warning: 0

## v0.3.19 (2026-10-23) — 变异分数提升到 100%

### Highlights
- 修复 2 个存活变异体（proof + ai_test 套件）
- 新增 9 个变异测试套件覆盖所有 10 个分类
  - patterns / runtime / security / analysis / tools / codegen / platform / integration
  - all categories 100%（50 变异体全部杀死）
- **变异分数 = 100%**（等级 A，20 套件，110 变异体，0 存活）

### Stats
- 包数: 79（不变）
- 测试: 2253（+9 变异测试套件）
- 平均 CRAP: 2.0
- 变异分数: 100%（从 97% 提升）
- Warning: 0

## v0.3.18 (2026-10-23) — CRAP 指标 + 变异测试全面执行

### Highlights
- CRAP 指标分析（1346 个 pub fn）
  - **平均 CRAP = 2.0**（目标 < 12）：✅ PASS
  - 99.8% 函数 CRAP < 12
  - 仅 3 个函数 CRAP ≥ 12（parse_args=21, affected_platforms=20, status_text=15）
- 变异测试全面执行（11 个测试套件，61 个变异体）
  - **变异分数 = 97%**（等级 A）
  - 59/61 变异体被杀死，2 个存活
  - 覆盖：core/proof/mock/e2e/ai_test/crap/refactoring/trait/算子
- 新增 `docs/crap_mutation_report.md` 综合报告

### Stats
- 包数: 79（不变）
- 测试: 2244（+11 变异测试）
- 平均 CRAP: 2.0
- 变异分数: 97%
- Warning: 0

## v0.3.17 (2026-10-23) — 平铺到根目录：移除 src/ 前缀

### Highlights
- 将所有包从 `src/` 平铺到根目录，移除 `src/` 前缀
  - `src/core/core/` → `core/core/`
  - `src/testing/proof/` → `testing/proof/`
  - 所有 10 个一级分类目录直接在根目录下
- 更新 74 个 moon.pkg 导入路径：`walkzzz/moon-cross/src/` → `walkzzz/moon-cross/`
- 删除 `src/` 目录

### Stats
- 包数: 79（不变）
- 测试: 2233（不变）
- Warning: 0

## v0.3.16 (2026-10-23) — 多根包重构：79 包 → 10 一级分类

### Highlights
- 多根包重构：将 79 个平铺包组织为 10 个一级分类目录
  - `core/` — core, trait, config, typesys（4 包）
  - `testing/` — proof, mock, e2e, ai_test, crap, mutate, refactoring（7 包）
  - `platform/` — platform（5 子包）
  - `codegen/` — codegen, ffi（5 子包）
  - `integration/` — integration（1 包）
  - `tools/` — cli, scaffold, builder, formatter, linter, docs, interactive, publish, command, plugin（10 包）
  - `runtime/` — cache, pool, scheduler, timer, event, signal, stream, sync, concurrency, memory, resource, compress, logging（13 包）
  - `analysis/` — coverage, profiler, benchmark, diagnostic, diff, discovery, trace, dependency, graph, perf, watcher（11 包）
  - `patterns/` — chain, visitor, observer, strategy, state, state_pattern, interpreter, memento, factory, proxy（10 包）
  - `security/` — security, robust, validator, crypto_util, algorithm, regex_enhanced, serializer, uri, http, argparse, template（11 包）
- 更新 74 个 moon.pkg 导入路径
- 更新子包路径（codegen/c, platform/*, ffi/*）

### Stats
- 包数: 79（不变）
- 测试: 2233（不变）
- 一级分类: 10
- Warning: 0

## v0.3.15 (2026-10-23) — CRAP 指标 + 变异测试框架

### Highlights
- 新增 `src/crap/` 包（CRAP 指标计算）
  - CRAP = complexity² × (1 − coverage)³ + complexity
  - FuncComplexity / CoverageInfo / CrapResult / CrapReport 结构体
  - 复杂度计算、覆盖率计算、CRAP 指标计算
  - 风险分级：high (>30) / medium (>10) / low
  - 实现 Named / Countable / Checkable / Summarizable trait
  - 16 个测试
- 新增 `src/mutate/` 包（变异测试框架）
  - 6 种变异算子：AOR / ROR / COR / UOI / ROI / SDL
  - Mutant / MutantResult / MutationReport 结构体
  - 变异体生成（算术/关系）、变异测试运行、变异分数计算
  - 变异分数等级：A(≥90%) / B(≥80%) / C(≥70%) / D(≥60%) / F
  - 实现 Named / Countable / Checkable / Summarizable trait
  - 24 个测试
- 更新 AGENTS.md 为 moon-cross 项目版本

### Stats
- 新增包: src/crap/ + src/mutate/（2 个）
- 新增测试: 40 个（总计 2233 个，全部通过）
- 包数: 79
- Warning: 0

## v0.3.14 (2026-10-21) — moonbit-refactoring + moonbit-proof 扩展

### Highlights
- 新增 `src/refactoring/` 包（重构工具 + 模式）
  - RefactorSuggestion / RefactorReport / RefactorPattern 结构体
  - 5 种重构模式：traitify / extract_method / operator_overload / derive / trait_object
  - 实现 Named / Describable / Countable / Summarizable trait
  - 11 个测试
- 扩展 `src/proof/` 包（形式化验证）
  - InductiveStep（归纳证明）：base_case + inductive_step + conclusion
  - ContradictionProof（反证法证明）：assumption + contradiction + conclusion
  - TraitVerification（trait 层次验证）：验证 Verifiable : Checkable 等层次
  - InvariantProof（不变量证明）：pre_condition + post_condition + preserves
  - verify_sorted / verify_length_preserved / verify_idempotent
  - compose_proofs（证明链组合）
  - 新类型实现 Named / Checkable trait
  - 12 个新测试

### Stats
- 新增包: src/refactoring/（1 个）
- 新增测试: 23 个（总计 2193 个，全部通过）
- 包数: 77
- Warning: 0

## v0.3.13 (2026-10-21) — Trait 系统重构：子特征 + 新 trait

### Highlights
- 子特征层次结构（trait hierarchy）
  - `Verifiable : Checkable`（可验证 ⇒ 可检查）
  - `Displayable : Named + Describable`（可展示 ⇒ 可命名 + 可描述）
- 新增 3 个 trait
  - `Versioned`：有版本类型 `version(Self) -> String`
  - `Ordered`：可排序类型 `compare(Self, Self) -> Int`
  - `Displayable`：可展示类型（Named + Describable 子特征）
- 为 Mock 添加 Checkable 实现（满足 Verifiable : Checkable 约束）
- 根包重导出更新：新增 Versioned / Ordered / Displayable
- trait 定义总数：14 个

### Stats
- 包数: 76（不变）
- 测试: 2170（不变）
- trait 定义: 14 个
- trait 实现: 157 个跨 68 包
- Warning: 0

## v0.3.12 (2026-10-21) — Trait 覆盖 89%：156 实现跨 68 包

### Highlights
- 新增 20 个 trait 实现（Checkable/Countable/Named/Iterable）
  - Checkable: SearchResult, DiffConfig, PlatformDetection, SourceAnalysis, PoolConfig
  - Countable: SearchResult, CompressionResult, DiffResult, DiffStats, Caretaker, Pool, PoolStats, StreamStats, TemplateContext
  - Named: HashConfig, Template, PlatformSpec
  - Iterable: DiffResult, Caretaker, TemplateContext
- trait 实现总数：156 个跨 68 包（89% 覆盖）

### Stats
- 包数: 76（不变）
- 测试: 2170（不变）
- trait 实现: 156 个跨 68 包
- Warning: 0

## v0.3.11 (2026-10-21) — Named trait 补全：136 实现跨 58 包（76% 覆盖）

### Highlights
- 为 10 个结构体用 xxx_name 字段实现 Named trait
  - CodegenResult(filename), FfiBindingResult(filename)
  - JniBindingConfig(class_name), NapiBindingConfig(module_name), SwiftBindingConfig(module_name)
  - AndroidCompileConfig(output_name), IosCompileConfig(output_name), LinuxCompileConfig(output_name), OhosCompileConfig(output_name), WindowsCompileConfig(output_name)
- trait 实现总数：136 个跨 58 包（76% 覆盖）

### Stats
- 包数: 76（不变）
- 测试: 2170（不变）
- trait 实现: 136 个跨 58 包
- Warning: 0

## v0.3.10 (2026-10-21) — 新增 3 trait + 126 实现跨 48 包

### Highlights
- 新增 3 个 pub(open) trait：Cloneable / Serializable / Iterable
  - Cloneable: clone(Self) -> Self
  - Serializable: serialize(Self) -> String
  - Iterable: iter_count(Self) -> Int
- 新增 16 个 trait 实现
  - Cloneable: ProofResult, Contract, Invariant, Step, TestCase, BoundaryCase, Fake, Stub
  - Serializable: ProofResult, Step, TestCase, CoverageReport
  - Iterable: Scenario, E2EReport, Mock, Spy
- trait 分布：Named(55) + Describable(16) + Countable(15) + Checkable(14) + Cloneable(8) + Resettable(5) + Summarizable(4) + Serializable(4) + Iterable(4) + Verifiable(1)
- 根包重导出更新：新增 Cloneable/Serializable/Iterable

### Stats
- 包数: 76（不变）
- 测试: 2170（不变）
- trait 定义: 11 个
- trait 实现: 126 个跨 48 包
- Warning: 0

## v0.3.9 (2026-10-21) — Describable/Resettable 扩展：110 实现跨 48 包

### Highlights
- 新增 11 个 Describable trait 实现（有 description 字段的类型）
  - ArgDef, ArgParser, ApiDocEntry, DocSection, FormatRule, LintRule, PluginInfo, TemplateInfo, PublishConfig, MooncakesMetadata, ValidationRule
- 新增 4 个 Resettable trait 实现（有 reset 方法的类型）
  - Builder, Arena, StateMachine, StateContext
- trait 实现总数：110 个跨 48 包（63%）

### Stats
- 包数: 76（不变）
- 测试: 2170（不变）
- trait 实现: 110 个跨 48 包
- Warning: 0

## v0.3.8 (2026-10-21) — Checkable/Countable trait 扩展：95 实现跨 47 包

### Highlights
- 新增 20 个 Checkable/Countable trait 实现
  - Checkable: CacheConfig/ParallelConfig/ProxyConfig/AsanConfig/AsanResult/SandboxResult/PlatformCompileResult/RetryResult/ValidationResult/StrategyResult/SyncResult
  - Countable: CacheStats/Cache/CoverageReport/Graph/Logger/TaskSchedule/CompileSummary/AsanResult/FileChange/WatchResult
- trait 实现总数：95 个跨 47 包（62%）

### Stats
- 包数: 76（不变）
- 测试: 2170（不变）
- trait 实现: 95 个跨 47 包
- Warning: 0

## v0.3.7 (2026-10-21) — Trait 全面覆盖：75 实现跨 36 包

### Highlights
- Named trait 全面铺开：75 个 trait 实现跨 36 个包
  - 新增 35 个类型的 Named trait 实现（argparse/benchmark/config/diagnostic/docs/ffi/formatter/interactive/linter/observer/plugin/publish/scaffold/scheduler/security/serializer/uri/validator 等）
  - 移除 18 个无 `name` 字段类型的错误实现
- trait 覆盖率：36/76 包（47%），75 个类型实现

### Stats
- 包数: 76（不变）
- 测试: 2170（不变）
- trait 实现: 75 个跨 36 包
- Warning: 0

## v0.3.6 (2026-10-21) — Trait 覆盖扩展：15 包 18 类型实现 Named trait

### Highlights
- 为 15 个包的 18 个类型实现 Named trait（R19 推进）
  - builder: Builder, Product
  - command: Command
  - event: Event, EventHandler
  - memory: Arena
  - state: State
  - timer: Timer
  - resource: Resource
  - signal: Signal
  - visitor: Element, VisitResult
  - http: HttpHeader
  - chain: Handler
  - factory: ProductInfo (type_name → Named)
  - profiler: ProfileEntry
  - trace: TraceSpan
  - dependency: DependencyNode
- trait 实现总数：31 个类型跨 19 个包实现 trait

### Stats
- 包数: 76（不变）
- 测试: 2170（不变）
- Warning: 0

## v0.3.5 (2026-10-21) — R3/R4 合规：pub fn 注释 + 子包 README

### Highlights
- R3 合规验证：所有 `pub fn` 均有 `///` 注释（0 缺失）
- R4 合规：为全部 76 个子包创建 README.md
  - 每个子包 README 包含：包名、Types 列表、Public API 列表
  - 链接回根 README

### Stats
- 新增文件: 76 个子包 README.md
- 包数: 76（不变）
- 测试: 2170（不变）
- Warning: 0

## v0.3.4 (2026-10-21) — 根包重导出 + 多手段测试报告（R12/R17 合规）

### Highlights
- 新增根包重导出（R12 合规）
  - 根目录 `moon.pkg` + `reexport.mbt`
  - 重导出 6 个核心包的公共类型和 trait
  - 对外提供统一入口 `@moon-cross`
  - 重导出类型：Platform / Arch / TargetTriple / ProofResult / Contract / Invariant / Mock / Stub / Spy / Fake / Step / Scenario / ScenarioResult / E2EReport / TestCase / BoundaryCase / CoverageReport / AITestResult
  - 重导出 trait：Named / Checkable / Resettable / Verifiable / Runnable / Countable / Describable / Summarizable
- 新增多手段测试报告（R17 合规）
  - `docs/arch_test_report.md`：五类多手段测试 + Trait 验证报告
  - 形式化证明：30 测试 ✅
  - AI 测试：28 测试 ✅
  - FAKE 测试：5 测试 ✅
  - MOCK 测试：24 测试 ✅
  - E2E 测试：28 测试 ✅
  - Trait 验证：30 测试 ✅
  - 总计 145 测试，六维度全覆盖

### Stats
- 新增文件: moon.pkg + reexport.mbt + docs/arch_test_report.md
- 包数: 76（不变）
- 测试: 2170（不变）
- Warning: 0

## v0.3.3 (2026-10-21) — Trait 抽象与去重（R18/R19 合规）

### Highlights
- 新增 `src/trait/` 包，定义 8 个公共行为 trait
  - `Named`：有名称的类型 `name(Self) -> String`
  - `Checkable`：可检查的类型 `check(Self) -> Bool`
  - `Resettable`：可重置的类型 `reset(Self) -> Self`
  - `Verifiable`：可验证的类型 `verify(Self) -> Bool`
  - `Runnable`：可运行的类型 `run(Self) -> Bool`
  - `Countable`：可计数的类型 `count(Self) -> Int`
  - `Describable`：可描述的类型 `describe(Self) -> String`
  - `Summarizable`：可摘要的类型 `summary(Self) -> String`
- 为 proof 包实现 trait（ProofResult: Named/Checkable/Summarizable, Contract: Named/Describable, Invariant: Named/Describable/Checkable）
- 为 mock 包实现 trait（Mock: Verifiable/Resettable/Countable, Stub: Named/Countable, Spy: Named/Countable, Fake: Named/Countable）
- 为 e2e 包实现 trait（Step: Named/Describable, Scenario: Named/Describable, ScenarioResult: Named/Checkable, E2EReport: Countable/Summarizable）
- 为 ai_test 包实现 trait（TestCase: Named/Describable, BoundaryCase: Named, CoverageReport: Summarizable, AITestResult: Named/Countable/Summarizable）
- 新增 R19 规则：尽可能使用 trait，强制要求新代码优先 trait 化
- 30 个 trait 测试验证所有实现

### Stats
- 新增包: src/trait/（1 个）
- 新增测试: 31 个（总计 2170 个，全部通过）
- Warning: 0

## v0.3.2 (2026-10-16) — 形式化证明 + 多手段测试框架

### Highlights
- 新增形式化证明包 `src/proof/`
  - ProofResult / Contract / Invariant 结构体
  - 契约验证（前条件 + 后条件）、不变量检查、性质成立检查
  - 证明链（proof_chain）：所有证明必须同时成立
  - 常见性质验证：幂等性、交换律、结合律、互逆性、单位元、范围不变量
  - 排序不变量：长度保持、有序性检查
  - 30 个测试
- 新增 Mock/Fake/Stub/Spy 测试框架 `src/mock/`
  - Mock：调用记录、期望设置、验证、调用计数、重置
  - Stub：固定返回值、调用计数
  - Spy：包装真实对象、调用记录、调用计数
  - Fake：自定义行为、调用计数
  - 19 个测试
- 新增 E2E 端到端测试框架 `src/e2e/`
  - Step / StepResult / Scenario / ScenarioResult / E2EReport 结构体
  - 场景创建、步骤添加、场景执行、报告生成
  - 通过率计算、失败场景提取、步骤总数统计
  - 20 个测试
- 新增 AI 辅助测试工具 `src/ai_test/`
  - TestCase / BoundaryCase / CoverageReport / AITestResult 结构体
  - 批量用例生成、边界值分析（含中间值）、覆盖率报告
  - 边缘用例检测、变异测试、测试套件运行
  - AI 测试摘要、结果合并
  - 21 个测试

### Stats
- 新增包: src/proof/, src/mock/, src/e2e/, src/ai_test/（4 个）
- 新增测试: 90 个（总计 2139 个，全部通过）
- Warning: 0

## v0.3.1 (2026-10-16) — Linux 平台支持 + iOS/鸿蒙增强

### Highlights
- 新增 Linux 平台支持（第五平台）
  - `Platform` 枚举新增 `Linux` 变体
  - 新增 `src/platform/linux/` 包：gcc 编译配置、交叉编译、pkg-config、动态链接器
  - 目标三元组：`x86_64-unknown-linux-gnu` / `aarch64-unknown-linux-gnu`
  - FFI 绑定类型新增 `CffiBinding`（C FFI 直接调用）
  - 平台规格：compiler=gcc, output_format=.so, ffi_mechanism=cffi
- iOS 功能增强
  - bitcode 编译标志（-fembed-bitcode / -fembed-bitcode-marker）
  - Framework 版本管理、Info.plist 内容生成
  - Swift Package.swift 内容生成
  - 优化级别、可用性检查标志
  - Bridging Header / modulemap 名称生成
- 鸿蒙功能增强
  - HAP/HSP 包名生成
  - Stage 模型标识、bundle 名称、模块类型（entry/feature）
  - hvigorw 构建命令、签名配置
  - oh-package.json5 / build-profile.json5 内容生成
  - 最低 Harmony API 版本（12）
- 所有 pipeline 验证函数和测试已适配 5 平台
- 新增 47 个测试（总计 2049 个，全部通过）

### Stats
- 新增包: src/platform/linux/
- 新增测试: 47 个（总计 2049 个，全部通过）
- Warning: 0
- 总包数: 71
- 平台数: 5（iOS / Android / Windows / HarmonyOS / Linux）

### Breaking Changes
- `Platform` 枚举新增 `Linux` 变体（所有 match 表达式已补全）
- `FfiBindingType` 枚举新增 `CffiBinding` 变体
- `all_platforms()` 返回 5 个平台（原 4 个）

## v0.3.0 (2026-10-16) — 参赛发布版

### Highlights
- 新增 `src/compress/` 包：压缩工具集
  - RLE 编解码：rle_encode / rle_decode
  - 字典编码：dict_encode
  - 压缩统计：compress_stats（原始大小/压缩大小/压缩率）
- 新增 `src/algorithm/` 包：算法工具集
  - 搜索：linear_search / binary_search（含比较次数统计）
  - 排序：bubble_sort / insertion_sort / selection_sort / quick_sort
  - 工具：array_min / array_max / array_reverse / array_dedup
- 新增 `src/stream/` 包：流处理工具集
  - 操作：stream_map / stream_filter / stream_reduce / stream_take / stream_drop
  - 高级：stream_chain / stream_zip / stream_flatten / stream_enumerate
  - 统计：stream_stats
- 新增 12 个设计模式包（observer/strategy/builder/factory/scheduler/proxy/command/chain/visitor/memento/state_pattern/interpreter）
  - 观察者模式：事件订阅/通知/取消
  - 策略模式：运行时策略切换
  - 建造者模式：流式 API 构建复杂对象
  - 工厂模式：注册/创建/类型映射
  - 调度器模式：延迟/优先级/时间推进
  - 代理模式：访问控制/缓存代理
  - 命令模式：执行/撤销/重做
  - 责任链模式：处理器链/顺序处理
  - 访问者模式：元素遍历/批量操作
  - 备忘录模式：状态快照/撤销/重做
  - 状态模式：交通灯状态机/转换/重置
  - 解释器模式：AST 求值/表达式转字符串/深度/节点数
- 参赛发布版里程碑：70 包 · 2002 测试 · 700+ API · 0 warning · 26 集成目标
- 新增 221 个测试（总计 2002 个，全部通过）

### Stats
- 新增包: src/compress/ + src/algorithm/ + src/stream/ + 12 设计模式包
- 新增测试: 221 个（总计 2002 个，全部通过）
- Warning: 0
- 总包数: 70
- 集成目标数: 26

### Breaking Changes
- 无（纯新增功能）

## v0.2.30 (2026-10-16) — 集成测试扩展（math64+bits+fmt）

### Highlights
- 新增 `src/integration/math64_bits_fmt_*` 集成测试
  - math64 模块：add/sub/mul/div/mod/compare + Int64 类型（6 函数 + 1 类型）
  - bits 模块：and/or/xor/not/shift_left/shift_right + BitField 类型（6 函数 + 1 类型）
  - fmt 模块：int/float/string/bool/array + FormatSpec 类型（5 函数 + 1 类型）
  - 每模块含跨平台配置 + 流水线测试
- 新增 30 个测试（总计 1781 个，全部通过）

### Stats
- 新增集成测试: 30 个（总计 1781 个，全部通过）
- Warning: 0
- 总包数: 57
- 集成目标数: 26

### Breaking Changes
- 无（纯新增功能）

## v0.2.29 (2026-10-16) — 内存管理包

### Highlights
- 新增 `src/memory/` 包：内存管理工具集
  - 内存追踪器（MemoryTracker）：tracker_create / tracker_allocate / tracker_free / tracker_live_count / tracker_live_bytes / tracker_has_leaks
  - 竞技场分配器（Arena）：arena_create / arena_alloc / arena_reset / arena_block_count
  - 引用计数器（RefCounter）：refcount_create / refcount_increment / refcount_decrement / refcount_is_zero
  - 内存池（MemoryPool）：pool_create / pool_allocate / pool_deallocate / pool_usage
  - GC 统计（GcStats）：gc_stats_create / gc_record_alloc / gc_record_collect
- 新增 23 个测试（总计 1751 个，全部通过）

### Stats
- 新增包: src/memory/
- 新增测试: 23 个（总计 1751 个，全部通过）
- Warning: 0
- 总包数: 57
- 集成目标数: 23

### Breaking Changes
- 无（纯新增功能）

## v0.2.28 (2026-10-16) — 并发原语包

### Highlights
- 新增 `src/concurrency/` 包：并发原语集
  - 互斥锁（Mutex）：mutex_create / mutex_lock / mutex_unlock / mutex_try_lock
  - 信号量（Semaphore）：semaphore_create / semaphore_acquire / semaphore_release
  - 缓冲通道（Channel）：channel_create / channel_send / channel_receive / channel_close
  - 未来值（Future）：future_create / future_complete / future_is_complete / future_get
  - 原子计数器（AtomicCounter）：atomic_create / atomic_increment / atomic_decrement / atomic_get / atomic_set / atomic_add
  - 任务队列（TaskQueue）：task_queue_create / task_enqueue / task_dequeue / task_queue_size / task_queue_is_empty（优先级排序）
- 新增 26 个测试（总计 1728 个，全部通过）

### Stats
- 新增包: src/concurrency/
- 新增测试: 26 个（总计 1728 个，全部通过）
- Warning: 0
- 总包数: 56
- 集成目标数: 23

### Breaking Changes
- 无（纯新增功能）

## v0.2.27 (2026-10-16) — 加密工具包

### Highlights
- 新增 `src/crypto_util/` 包：加密工具集
  - 哈希函数：hash_djb2 / hash_fnv1 / hash_sdbm / hash_with_salt
  - 哈希配置（HashConfig）：算法选择 + 盐值
  - 十六进制编解码：hex_encode / hex_decode
  - XOR 加解密：xor_encrypt / xor_decrypt（自逆运算）
  - 凯撒加解密：caesar_encrypt / caesar_decrypt（字母移位，非字母保留）
  - 随机数生成器（RngState）：rng_create / rng_next / rng_range
  - 盐生成：generate_salt
- 新增 24 个测试（总计 1702 个，全部通过）

### Stats
- 新增包: src/crypto_util/
- 新增测试: 24 个（总计 1702 个，全部通过）
- Warning: 0
- 总包数: 55
- 集成目标数: 23

### Breaking Changes
- 无（纯新增功能）

## v0.2.26 (2026-10-16) — 正则增强包

### Highlights
- 新增 `src/regex_enhanced/` 包：正则表达式增强引擎
  - 正则模式（RegexPattern）：pattern + 锚点标记 + 核心模式
  - 匹配结果（RegexMatch）：matched + start + end
  - 编译操作：compile_pattern（支持 `^` 前缀锚和 `$` 后缀锚）
  - 匹配操作：regex_match / simple_match
  - 批量操作：regex_find_all / regex_replace / regex_split
  - 模式语法：`.` 任意单字符、`X*` 零或多个X、`^` 前缀锚、`$` 后缀锚
  - 验证操作：regex_is_valid
- 新增 24 个测试（总计 1678 个，全部通过）

### Stats
- 新增包: src/regex_enhanced/
- 新增测试: 24 个（总计 1678 个，全部通过）
- Warning: 0
- 总包数: 54
- 集成目标数: 23

### Breaking Changes
- 无（纯新增功能）

## v0.2.25 (2026-10-16) — 模板引擎包

### Highlights
- 新增 `src/template/` 包：模板引擎
  - 模板上下文（TemplateContext）：变量键值对存储
  - 模板（Template）：源码存储
  - 上下文操作：empty_context / context_set / context_get / context_has / context_remove / context_size
  - 模板操作：parse_template / render_template / template_render（一步渲染）
  - 变量替换：`{{variable}}`
  - 条件渲染：`{{#if variable}}...{{/if}}` / `{{#unless variable}}...{{/unless}}`
  - 循环渲染：`{{#each variable}}...{{this}}...{{/each}}`（逗号分隔列表）
  - 支持嵌套块和空格容忍（`{{ name }}` 等价于 `{{name}}`）
- 新增 27 个测试（总计 1654 个，全部通过）

### Stats
- 新增包: src/template/
- 新增测试: 27 个（总计 1654 个，全部通过）
- Warning: 0
- 总包数: 53
- 集成目标数: 23

### Breaking Changes
- 无（纯新增功能）

## v0.2.24 (2026-10-16) — 集成测试扩展（fs+path+process）

### Highlights
- 新增 `src/integration/fs_path_process_*` 集成测试
  - fs 模块：read/write/exists/mkdir/remove/stat + FileInfo 类型（6 函数 + 1 类型）
  - path 模块：join/normalize/dirname/basename/extname/is_absolute + Path 类型（6 函数 + 1 类型）
  - process 模块：spawn/wait/kill/exit/env + Process 类型（5 函数 + 1 类型）
  - 每模块含跨平台配置 + 流水线测试
- 新增 35 个测试（总计 1627 个，全部通过）

### Stats
- 新增集成测试: 35 个（总计 1627 个，全部通过）
- Warning: 0
- 总包数: 52
- 集成目标数: 23

### Breaking Changes
- 无（纯新增功能）

## v0.2.23 (2026-10-16) — URI 解析包

### Highlights
- 新增 `src/uri/` 包：URI 解析引擎
  - 查询参数（QueryParam）：名称/值
  - URI 结构体（Uri）：scheme/host/port/path/query/fragment
  - 解析操作：parse_uri（支持 scheme://host:port/path?query#fragment 完整解析）
  - 构建操作：build_uri / make_uri / empty_uri
  - 编码解码：uri_encode / uri_decode（百分号编码 + 加号转空格）
  - 查询操作：parse_query / build_query / add_query_param / get_query_param
  - 工具函数：uri_is_valid / uri_full_path / merge_uris / uri_version
- 新增 28 个测试（总计 1592 个，全部通过）

### Stats
- 新增包: src/uri/
- 新增测试: 28 个（总计 1592 个，全部通过）
- Warning: 0
- 总包数: 52
- 集成目标数: 20

### Breaking Changes
- 无（纯新增功能）

## v0.2.22 (2026-10-16) — HTTP 协议包

### Highlights
- 新增 `src/http/` 包：HTTP 协议引擎
  - HTTP 方法（HttpMethod）：Get / Post / Put / Delete / Patch / Head / Options
  - HTTP 头部（HttpHeader）：名称/值
  - HTTP 请求（HttpRequest）：方法/URL/头部列表/请求体
  - HTTP 响应（HttpResponse）：状态码/头部列表/响应体
  - 请求操作：make_request / make_get_request / make_post_request / request_add_header / request_get_header / request_set_body / format_request
  - 响应操作：make_response / make_response_with_body / response_add_header / response_get_header / format_response
  - 状态码工具：status_text / is_success_code / is_redirect_code / is_error_code / is_client_error / is_server_error
  - 方法工具：method_name / method_from_string
  - 合并操作：merge_requests
- 新增 27 个测试（总计 1564 个，全部通过）

### Stats
- 新增包: src/http/
- 新增测试: 27 个（总计 1564 个，全部通过）
- Warning: 0
- 总包数: 51
- 集成目标数: 20

### Breaking Changes
- 无（纯新增功能）

## v0.2.21 (2026-10-16) — 命令行解析包

### Highlights
- 新增 `src/argparse/` 包：命令行参数解析引擎
  - 参数类型（ArgType）：String / Int / Bool / Flag
  - 参数定义（ArgDef）：名称/短选项/长选项/类型/必需/默认值/描述
  - 解析结果（ParseResult）：键值对/位置参数/错误列表
  - 参数解析器（ArgParser）：名称/描述/参数定义/子命令
  - 核心操作：create_parser / add_arg / add_subcommand / parse_args
  - 参数工厂：make_arg / make_flag / make_string_arg / make_int_arg
  - 结果查询：get_value / get_value_or / has_flag / parse_success / error_count / positional_count
  - 帮助生成：generate_help（自动生成 Usage + Options + Subcommands）
  - 合并操作：merge_parsers
  - 支持长选项（--option）、短选项（-o）、标志参数、位置参数、必需参数校验
- 新增 22 个测试（总计 1537 个，全部通过）

### Stats
- 新增包: src/argparse/
- 新增测试: 22 个（总计 1537 个，全部通过）
- Warning: 0
- 总包数: 50
- 集成目标数: 20

### Breaking Changes
- 无（纯新增功能）

## v0.2.20 (2026-10-16) — 集成测试扩展：encoding + container + random

### Highlights
- 新增 `moonbitlang/encoding` 端到端集成测试
  - 5 导出函数（encoding_encode / encoding_decode / encoding_convert / encoding_detect / encoding_validate）
  - 1 导出类型（EncodingScheme）
- 新增 `moonbitlang/container` 端到端集成测试
  - 5 导出函数（container_push / container_pop / container_peek / container_size / container_clear）
  - 2 导出类型（Container / ContainerType）
- 新增 `moonbitlang/random` 端到端集成测试
  - 5 导出函数（random_next / random_range / random_seed / random_shuffle / random_sample）
  - 1 导出类型（RngState）
- 新增 34 个测试（总计 1515 个，全部通过）

### Stats
- 新增集成目标: moonbitlang/encoding + moonbitlang/container + moonbitlang/random
- 新增测试: 34 个（总计 1515 个，全部通过）
- Warning: 0
- 总包数: 49
- 集成目标数: 20

### Breaking Changes
- 无（纯新增功能）

## v0.2.19 (2026-10-16) — 资源管理包

### Highlights
- 新增 `src/resource/` 包：资源管理引擎
  - 资源类型（ResourceType）：File / Memory / Network / Handle / Custom
  - 资源（Resource）：ID/名称/类型/大小/获取时间/释放时间/活跃
  - 资源配置（ResourceConfig）：最大资源数/追踪大小/泄漏检测
  - 资源统计（ResourceStats）：获取总数/释放总数/泄漏数/活跃数/总大小
  - 资源管理器（ResourceManager）：资源列表/配置/统计
  - 核心操作：create_resource_manager / resource_acquire / resource_release / resource_release_all
  - 泄漏检测：resource_check_leaks / resource_leak_count
  - 过滤操作：resource_filter_by_type / resource_filter_active / resource_filter_released
  - 查询操作：resource_get / resource_has / resource_is_active / resource_active_count / resource_total_count / resource_total_size
  - 统计操作：resource_stats
  - 合并操作：merge_resource_managers
- 新增 24 个测试（总计 1481 个，全部通过）

### Stats
- 新增包: src/resource/
- 新增测试: 24 个（总计 1481 个，全部通过）
- Warning: 0
- 总包数: 48
- 集成目标数: 17

### Breaking Changes
- 无（纯新增功能）

## v0.2.18 (2026-10-16) — 日志系统包

### Highlights
- 新增 `src/logging/` 包：日志系统引擎
  - 日志级别（LogLevel）：Debug / Info / Warn / Error / Fatal
  - 日志条目（LogEntry）：级别/消息/时间戳/来源/上下文
  - 日志配置（LogConfig）：最低级别/包含时间戳/包含来源/最大条目数
  - 日志统计（LogStats）：总条目/各级别计数/丢弃计数
  - 日志器（Logger）：配置/条目列表/统计
  - 核心操作：create_logger / log_at / log_debug / log_info / log_warn / log_error / log_fatal
  - 过滤操作：log_filter_by_level / log_filter_by_source / log_filter_by_message
  - 格式化：log_format_entry（可配置时间戳/来源/上下文）
  - 查询操作：log_count / log_last_n / log_is_enabled
  - 统计操作：log_stats
  - 合并操作：merge_loggers
  - 容量管理：max_entries 自动淘汰旧条目
- 新增 24 个测试（总计 1457 个，全部通过）

### Stats
- 新增包: src/logging/
- 新增测试: 24 个（总计 1457 个，全部通过）
- Warning: 0
- 总包数: 47
- 集成目标数: 17

### Breaking Changes
- 无（纯新增功能）

## v0.2.17 (2026-10-16) — 定时器包

### Highlights
- 新增 `src/timer/` 包：定时器引擎
  - 定时器类型（TimerType）：OneShot / Periodic
  - 定时器配置（TimerConfig）：间隔/类型/自动启动
  - 定时器（Timer）：ID/名称/配置/创建时间/最后触发/触发次数/活跃
  - 定时器管理器（TimerManager）：定时器列表/统计
  - 核心操作：create_timer_manager / timer_add / timer_remove / timer_start / timer_stop / timer_fire
  - 查询操作：timer_count / timer_active_count / timer_has / timer_get / timer_fire_count
  - 触发判断：timer_should_fire（基于间隔和最后触发时间）
  - 重置操作：timer_reset
  - 统计操作：timer_stats
  - 合并操作：merge_timer_managers
- 新增 23 个测试（总计 1433 个，全部通过）

### Stats
- 新增包: src/timer/
- 新增测试: 23 个（总计 1433 个，全部通过）
- Warning: 0
- 总包数: 46
- 集成目标数: 17

### Breaking Changes
- 无（纯新增功能）

## v0.2.16 (2026-10-16) — 信号处理包

### Highlights
- 新增 `src/signal/` 包：信号处理引擎
  - 信号类型（SignalType）：User / System / Interrupt / Error / Custom
  - 信号（Signal）：ID/名称/类型/数据/时间戳/优先级
  - 信号处理器（SignalHandler）：ID/信号名/处理器名/优先级/活跃/调用计数
  - 信号管理器（SignalManager）：处理器注册表/历史/统计
  - 核心操作：create_signal_manager / signal_register / signal_unregister / signal_send
  - 批量操作：signal_batch_send
  - 处理器管理：signal_disable_handler / signal_enable_handler / signal_handlers_for
  - 过滤操作：signal_filter_by_name / signal_filter_by_type
  - 统计操作：signal_stats / signal_handler_call_count
  - 合并操作：merge_signal_managers
- 新增 22 个测试（总计 1410 个，全部通过）

### Stats
- 新增包: src/signal/
- 新增测试: 22 个（总计 1410 个，全部通过）
- Warning: 0
- 总包数: 45
- 集成目标数: 17

### Breaking Changes
- 无（纯新增功能）

## v0.2.15 (2026-10-16) — 集成测试扩展：net + io + math

### Highlights
- 新增 `moonbitlang/net` 端到端集成测试
  - 5 导出函数（net_connect / net_listen / net_send / net_recv / net_close）
  - 2 导出类型（Socket / Address）
- 新增 `moonbitlang/io` 端到端集成测试
  - 5 导出函数（io_open / io_read / io_write / io_seek / io_close）
  - 2 导出类型（FileHandle / Buffer）
- 新增 `moonbitlang/math` 端到端集成测试
  - 8 导出函数（math_sin / math_cos / math_sqrt / math_pow / math_abs / math_floor / math_ceil / math_log）
  - 2 导出类型（Vector2 / Vector3）
- 新增 37 个测试（总计 1388 个，全部通过）

### Stats
- 新增集成目标: moonbitlang/net + moonbitlang/io + moonbitlang/math
- 新增测试: 37 个（总计 1388 个，全部通过）
- Warning: 0
- 总包数: 44
- 集成目标数: 17

### Breaking Changes
- 无（纯新增功能）

## v0.2.14 (2026-10-16) — 状态机包

### Highlights
- 新增 `src/state/` 包：有限状态机引擎
  - 状态（State）：名称/是否初始/是否终态
  - 状态转换（Transition）：源状态/目标状态/事件
  - 状态机统计（StateMachineStats）：转换次数/访问状态数
  - 状态机（StateMachine）：状态集/转换集/当前状态/历史/统计
  - 核心操作：create_state_machine / sm_add_state / sm_add_transition / sm_start / sm_trigger
  - 查询操作：sm_current_state / sm_can_transition / sm_is_final / sm_state_exists / sm_get_state
  - 历史操作：sm_history / sm_history_length / sm_reset
  - 列表操作：sm_valid_events / sm_state_names / sm_transitions
  - 统计操作：sm_stats
  - 合并操作：merge_state_machines
  - 状态工厂：make_state / make_initial_state / make_final_state
- 新增 25 个测试（总计 1351 个，全部通过）

### Stats
- 新增包: src/state/
- 新增测试: 25 个（总计 1351 个，全部通过）
- Warning: 0
- 总包数: 43
- 集成目标数: 14

### Breaking Changes
- 无（纯新增功能）

## v0.2.13 (2026-10-16) — 事件系统包

### Highlights
- 新增 `src/event/` 包：事件系统引擎
  - 事件优先级（EventPriority）：Low / Normal / High / Critical
  - 事件（Event）：名称/数据/时间戳/来源/优先级
  - 事件处理器（EventHandler）：ID/事件名/处理器名/优先级/活跃状态
  - 事件总线（EventBus）：处理器注册表/事件历史/统计
  - 核心操作：create_event_bus / event_subscribe / event_unsubscribe / event_publish
  - 批量操作：event_batch_publish
  - 过滤操作：event_filter_by_name / event_filter_by_priority / event_filter_by_source
  - 处理器管理：event_disable_handler / event_enable_handler / event_handlers_for
  - 查询操作：event_handler_count / event_active_handler_count / event_has_handler
  - 统计操作：event_stats / event_history_count
  - 合并操作：merge_event_buses
  - 优先级工具：priority_value / priority_name / priority_from_value
- 新增 25 个测试（总计 1326 个，全部通过）

### Stats
- 新增包: src/event/
- 新增测试: 25 个（总计 1326 个，全部通过）
- Warning: 0
- 总包数: 42
- 集成目标数: 14

### Breaking Changes
- 无（纯新增功能）

## v0.2.12 (2026-10-16) — 对象池包

### Highlights
- 新增 `src/pool/` 包：对象池引擎
  - 池配置（PoolConfig）：最小/最大容量/空闲超时/自动收缩
  - 池条目（PoolEntry）：值/创建时间/最后使用/使用计数
  - 池统计（PoolStats）：活跃/空闲/创建总数/销毁总数/获取次数/释放次数
  - 核心操作：create_pool / pool_acquire / pool_release / pool_clear / pool_shrink
  - 预分配：pool_preallocate（批量预创建对象，尊重 max_size 上限）
  - 过期管理：is_idle_expired / pool_evict_expired
  - 查询操作：pool_size / pool_idle_count / pool_active_count / pool_contains / pool_idle_values
  - 统计操作：pool_stats / pool_utilization
  - 合并操作：merge_pools
  - 容量检查：pool_is_full / pool_is_empty
- 新增 27 个测试（总计 1301 个，全部通过）

### Stats
- 新增包: src/pool/
- 新增测试: 27 个（总计 1301 个，全部通过）
- Warning: 0
- 总包数: 41
- 集成目标数: 14

### Breaking Changes
- 无（纯新增功能）

## v0.2.11 (2026-10-16) — 缓存管理包

### Highlights
- 新增 `src/cache/` 包：缓存管理引擎
  - 淘汰策略（EvictionPolicy）：LRU / FIFO / TTL
  - 缓存条目（CacheEntry）：键/值/时间戳/访问计数/最后访问时间
  - 缓存配置（CacheConfig）：最大容量/TTL/淘汰策略
  - 缓存统计（CacheStats）：命中/未命中/淘汰/当前大小
  - 核心操作：create_cache / cache_get / cache_put / cache_remove / cache_clear
  - 查询操作：cache_size / cache_contains / cache_keys / cache_values
  - 统计操作：cache_stats / cache_hit_ratio / record_hit / record_miss
  - 过期管理：is_expired / evict_expired
  - 合并操作：merge_caches
  - LRU 自动淘汰：cache_put 超容量时自动淘汰 last_access 最小条目
- 新增 26 个测试（总计 1274 个，全部通过）

### Stats
- 新增包: src/cache/
- 新增测试: 26 个（总计 1274 个，全部通过）
- Warning: 0
- 总包数: 40
- 集成目标数: 14

### Breaking Changes
- 无（纯新增功能）

## v0.2.10 (2026-10-16) — 集成测试扩展：crypto + time + sort

### Highlights
- 新增 `moonbitlang/crypto` 端到端集成测试
  - 5 导出函数（aes_encrypt / aes_decrypt / hmac / random_bytes / rsa_sign）
  - 1 导出类型（CipherKey）
- 新增 `moonbitlang/time` 端到端集成测试
  - 5 导出函数（now / format / parse / duration / sleep）
  - 1 导出类型（Duration）
- 新增 `moonbitlang/sort` 端到端集成测试
  - 5 导出函数（quick_sort / merge_sort / bubble_sort / binary_search / is_sorted）
- 新增 32 个测试（总计 1248 个，全部通过）

### Stats
- 新增集成目标: moonbitlang/crypto + moonbitlang/time + moonbitlang/sort
- 新增测试: 32 个（总计 1248 个，全部通过）
- Warning: 0
- 总包数: 39
- 集成目标数: 14

### Breaking Changes
- 无（纯新增功能）

## v0.2.9 (2026-10-16) — 数据验证包

### Highlights
- 新增 `src/validator/` 包：数据验证引擎
  - 验证错误（ValidationError）：字段/消息/错误码
  - 验证结果（ValidationResult）：有效标志/错误列表
  - 验证配置（ValidationConfig）：严格模式/首个错误即停
  - 验证规则（ValidationRule）：名称/描述/启用状态
  - 内置验证器：validate_required / validate_min_length / validate_max_length
  - 数值验证：validate_min_value / validate_max_value
  - 集合验证：validate_not_empty
  - 结果操作：create_result / merge_results / batch_validate
  - 错误过滤：filter_errors_by_field / filter_errors_by_code / error_fields
  - 格式化：format_errors / format_result
  - 8 条内置规则
- 新增 34 个测试（总计 1216 个，全部通过）

### Stats
- 新增包: src/validator/
- 新增测试: 34 个（总计 1216 个，全部通过）
- Warning: 0
- 总包数: 39

### Breaking Changes
- 无（纯新增功能）

## v0.2.8 (2026-10-16) — 图算法包

### Highlights
- 新增 `src/graph/` 包：图算法引擎
  - 图类型（GraphType）：Directed / Undirected
  - 图边（GraphEdge）：起点/终点/权重
  - 图（Graph）：节点列表/边列表/类型
  - 遍历算法：bfs（广度优先）/ dfs（深度优先）
  - 路径算法：has_path / shortest_path（BFS 最短路径）
  - 连通性：connected_components / is_connected
  - 图操作：add_node / add_edge / build_graph / empty_graph
  - 节点属性：degree / is_isolated / neighbors
  - 格式化：format_graph
  - 统计：node_count / edge_count
- 新增 32 个测试（总计 1182 个，全部通过）

### Stats
- 新增包: src/graph/
- 新增测试: 32 个（总计 1182 个，全部通过）
- Warning: 0
- 总包数: 38

### Breaking Changes
- 无（纯新增功能）

## v0.2.7 (2026-10-16) — 序列化包

### Highlights
- 新增 `src/serializer/` 包：序列化/反序列化引擎
  - 序列化格式（SerializeFormat）：Json / Binary / Text
  - 字段类型（FieldType）：Int / Double / String / Bool / Array / Object
  - 序列化字段（SerializedField）：名称/类型/值
  - 序列化配置（SerializeConfig）：格式/缩进/包含null/最大深度
  - 序列化：serialize_int / serialize_double / serialize_bool / serialize_string
  - 数组序列化：serialize_array / serialize_int_array
  - 对象序列化：serialize_object / merge_objects
  - 反序列化：deserialize_int / deserialize_bool / deserialize_string
  - 字符串转义：escape_string（处理引号/反斜杠/换行/制表符）
  - 字段操作：find_field / filter_by_type / field_names / field_count
- 新增 29 个测试（总计 1150 个，全部通过）

### Stats
- 新增包: src/serializer/
- 新增测试: 29 个（总计 1150 个，全部通过）
- Warning: 0
- 总包数: 37

### Breaking Changes
- 无（纯新增功能）

## v0.2.6 (2026-10-16) — 性能分析器包

### Highlights
- 新增 `src/profiler/` 包：性能分析引擎
  - 性能条目（ProfileEntry）：函数名/调用次数/总时间/最小时间/最大时间
  - 性能配置（ProfilerConfig）：启用/采样率/最大条目/内存追踪
  - 性能统计（ProfileStats）：总调用/总时间/平均时间/热点函数
  - 性能报告（ProfileReport）：条目列表/总时间/总调用
  - 核心功能：make_entry / create_report / find_hotspot / summary_stats
  - 排序功能：sort_by_total_time / sort_by_call_count
  - 合并条目：merge_entries（同名合并统计）
  - 格式化输出：format_report_text / format_report_json
  - 时间转换：average_time_ms / total_time_ms / total_time_sec
  - 过滤功能：filter_above_threshold / find_entry
- 新增 25 个测试（总计 1121 个，全部通过）

### Stats
- 新增包: src/profiler/
- 新增测试: 25 个（总计 1121 个，全部通过）
- Warning: 0
- 总包数: 36

### Breaking Changes
- 无（纯新增功能）

## v0.2.5 (2026-10-16) — 依赖分析包

### Highlights
- 新增 `src/dependency/` 包：依赖分析引擎
  - 依赖边（DependencyEdge）：起点/终点
  - 依赖节点（DependencyNode）：包名/依赖列表/依赖者列表
  - 依赖图（DependencyGraph）：节点列表/边列表
  - 依赖配置（DependencyConfig）：包含开发依赖/包含传递依赖/最大深度
  - 图构建：build_graph / make_edge / empty_graph / merge_graphs
  - 查询功能：find_node / direct_deps / direct_dependents / transitive_deps / transitive_dependents
  - 节点分类：is_leaf / is_root / orphan_nodes
  - 深度计算：dependency_depth
  - 环检测：has_cycle（DFS 算法）
  - 拓扑排序：topological_sort（DFS 算法）
  - 格式化：format_graph
  - 统计：node_count / edge_count
- 新增 30 个测试（总计 1096 个，全部通过）

### Stats
- 新增包: src/dependency/
- 新增测试: 30 个（总计 1096 个，全部通过）
- Warning: 0
- 总包数: 35

### Breaking Changes
- 无（纯新增功能）

## v0.2.4 (2026-10-16) — 代码差异分析包

### Highlights
- 新增 `src/diff/` 包：代码差异分析引擎
  - 差异行类型（DiffLineType）：Added / Removed / Unchanged / Context
  - 差异行（DiffLine）：内容/类型/旧行号/新行号
  - 差异结果（DiffResult）：行列表/新增数/删除数/未变更数
  - 差异配置（DiffConfig）：上下文行数/忽略空白/最大差异行数
  - 差异统计（DiffStats）：总行数/变更比率/新增/删除/未变更
  - 核心功能：diff_lines / diff_text / diff_text_with_config
  - 过滤功能：filter_added / filter_removed / filter_unchanged
  - 格式化输出：format_diff / diff_summary
  - 差异操作：merge_diffs / reverse_diff / empty_diff
  - 统计功能：diff_stats / total_lines / has_changes
- 新增 30 个测试（总计 1066 个，全部通过）

### Stats
- 新增包: src/diff/
- 新增测试: 30 个（总计 1066 个，全部通过）
- Warning: 0
- 总包数: 34

### Breaking Changes
- 无（纯新增功能）

## v0.2.3 (2026-10-16) — 集成测试扩展：regexp + uuid + bufio

### Highlights
- 新增 `moonbitlang/regexp` 端到端集成测试
  - 5 导出函数（compile / match / replace / split / find）
  - 2 导出类型（Regexp / MatchResult）
- 新增 `moonbitlang/uuid` 端到端集成测试
  - 5 导出函数（v4 / v7 / parse / to_string / validate）
  - 1 导出类型（Uuid）
- 新增 `moonbitlang/bufio` 端到端集成测试
  - 5 导出函数（new_buffer / write_string / read_line / flush / capacity）
  - 1 导出类型（Buffer）
- 新增 34 个测试（总计 1036 个，全部通过）

### Stats
- 新增集成目标: moonbitlang/regexp + moonbitlang/uuid + moonbitlang/bufio
- 新增测试: 34 个（总计 1036 个，全部通过）
- Warning: 0
- 总包数: 33

### Breaking Changes
- 无（纯新增功能）

## v0.2.2 (2026-10-16) — 文件监视器包

### Highlights
- 新增 `src/watcher/` 包：文件监视器引擎
  - 事件类型（EventType）：Created / Modified / Deleted / Renamed
  - 监视事件（WatchEvent）：路径/事件类型/时间戳
  - 监视配置（WatchConfig）：路径列表/忽略模式/轮询间隔/递归
  - 文件变更（FileChange）：路径/旧路径/大小/哈希
  - 监视结果（WatchResult）：事件列表/总变更数/错误标志
  - 事件过滤：filter_events / filter_by_path
  - 事件去重：deduplicate_events
  - 事件排序：sort_by_timestamp / latest_events
  - 结果合并：merge_results / make_watch_result / make_error_result
  - 配置管理：add_watch_path / add_ignore_pattern
  - 辅助函数：is_ignored / count_by_type / has_changes / event_summary / format_event
- 新增 25 个测试（总计 1002 个，全部通过）

### Stats
- 新增包: src/watcher/
- 新增测试: 25 个（总计 1002 个，全部通过）
- Warning: 0
- 总包数: 33

### Breaking Changes
- 无（纯新增功能）

## v0.2.1 (2026-10-16) — 测试覆盖率分析包

### Highlights
- 新增 `src/coverage/` 包：测试覆盖率分析引擎
  - 覆盖率条目（CoverageEntry）：文件路径/总行数/覆盖行数/缺失行
  - 覆盖率报告（CoverageReport）：条目聚合/总行数/覆盖行数/缺失行数
  - 覆盖率配置（CoverageConfig）：最低阈值/失败策略/显示缺失/排序
  - 覆盖率统计（CoverageStats）：最小/最大/均值/文件数
  - 行覆盖状态（LineStatus）：Covered / Uncovered / Partial
  - 核心功能：make_entry / merge_entries / coverage_percentage / entry_percentage
  - 报告生成：format_report_text / format_report_json
  - 阈值检查：is_passing / filter_below_threshold / coverage_grade
  - 排序功能：sort_by_coverage_ascending / sort_by_coverage_descending
  - 报告合并：merge_reports / empty_report
  - 行状态查询：line_status / missing_lines_summary
- 新增 38 个测试（总计 977 个，全部通过）

### Stats
- 新增包: src/coverage/
- 新增测试: 38 个（总计 977 个，全部通过）
- Warning: 0
- 总包数: 32

### Breaking Changes
- 无（纯新增功能）

## v0.2.0 (2026-10-16) — 代码格式化包

### Highlights
- 新增 `src/formatter/` 包：代码格式化引擎
  - 格式化配置（FormatConfig）：缩进风格/缩进宽度/最大行宽/尾逗号/导出前空行/注释对齐
  - 格式化结果（FormatResult）：原始文本/格式化文本/变更标志/行数差异
  - 格式化规则（FormatRule）：规则名/描述/启用状态
  - 缩进风格（IndentStyle）：Spaces / Tabs
  - 核心功能：strip_trailing_whitespace / ensure_trailing_newline / format_text
  - 语言预设：format_c_code / format_moonbit_code / format_json
  - 规则管理：builtin_format_rules / disable_rule / enable_rule / enabled_rules
  - 批量格式化：batch_format / count_changes
  - 辅助函数：indent_string / count_lines / find_long_lines / is_line_too_long
- 新增 35 个测试（总计 939 个，全部通过）

### Stats
- 新增包: src/formatter/
- 新增测试: 35 个（总计 939 个，全部通过）
- Warning: 0
- 总包数: 31

### Breaking Changes
- 无（纯新增功能）

## v0.1.9 (2026-10-16) — 集成测试扩展：base64 + json + hash

### Highlights
- 新增 `moonbitlang/base64` 端到端集成测试
  - 5 导出函数（encode / decode / encode_urlsafe / decode_urlsafe / validate）
- 新增 `moonbitlang/json` 端到端集成测试
  - 5 导出函数（parse / to_string / get / get_array / value_type）
  - 2 导出类型（JsonValue / JsonError）
- 新增 `moonbitlang/hash` 端到端集成测试
  - 5 导出函数（md5 / sha1 / sha256 / sha512 / hmac_sha256）
- 新增 30 个测试（总计 904 个，全部通过）

### Stats
- 新增集成目标: moonbitlang/base64 + moonbitlang/json + moonbitlang/hash
- 新增测试: 30 个（总计 904 个，全部通过）
- Warning: 0
- 总包数: 30

### Breaking Changes
- 无（纯新增功能）

## v0.1.8 (2026-10-16) — 配置 lint 规则包

### Highlights
- 新增 `src/linter/` 包：配置 lint 规则引擎
  - 8 条内置规则：模块路径/函数名格式/非空导出/非空目标/版本格式/重复函数/返回类型/参数类型
  - Lint 严重级别（Info/Warning/Error）
  - 规则启用/禁用管理
  - 按严重级别过滤问题
  - 格式化输出（format_issue/format_result）
  - 完整配置 lint 检查（lint_config）
- 新增 39 个测试（总计 874 个，全部通过）

### Stats
- 新增包: src/linter/
- 新增测试: 39 个（总计 874 个，全部通过）
- Warning: 0
- 总包数: 30

### Breaking Changes
- 无（纯新增功能）

## v0.1.7 (2026-10-16) — 编译追踪与日志包

### Highlights
- 新增 `src/trace/` 包：编译追踪与日志系统
  - 日志级别（LogLevel）：Trace/Debug/Info/Warn/Error/Fatal
  - 追踪事件（TraceEvent）：时间戳/级别/来源/消息
  - 追踪区间（TraceSpan）：开始/结束/事件列表/父区间
  - 追踪收集器（TraceCollector）：事件/区间管理/时间推进
  - 级别过滤/来源过滤/错误统计/警告统计
  - 最慢/最快区间查找/总持续时间计算
  - 格式化输出（text/json）/摘要生成
- 新增 38 个测试（总计 835 个，全部通过）

### Stats
- 新增包: src/trace/
- 新增测试: 38 个（总计 835 个，全部通过）
- Warning: 0
- 总包数: 29

### Breaking Changes
- 无（纯新增功能）

## v0.1.6 (2026-10-16) — 性能基准测试包

### Highlights
- 新增 `src/benchmark/` 包：性能基准测试框架
  - 基准测试配置（BenchmarkConfig）：迭代次数/预热/超时
  - 基准测试结果（BenchmarkResult）：均值/中位数/最小/最大/ops/sec
  - 统计摘要（StatsSummary）：均值/中位数/方差/标准差/P95/P99
  - 性能比较（ComparisonResult）：加速比/改善百分比/显著性判断
  - 基准测试套件（BenchmarkSuite）：多测试管理/最快最慢查找
  - 格式化输出（format_result/format_stats/format_comparison）
- 新增 42 个测试（总计 797 个，全部通过）

### Stats
- 新增包: src/benchmark/
- 新增测试: 42 个（总计 797 个，全部通过）
- Warning: 0
- 总包数: 28

### Breaking Changes
- 无（纯新增功能）

## v0.1.5 (2026-10-16) — 示例项目 + 文档完善

### Highlights
- 新增 3 个示例项目：
  - `examples/toml-cross/`：bobzhang/toml v0.4.3 跨平台导出示例
  - `examples/quickcheck-cross/`：moonbitlang/quickcheck v0.15.0 跨平台导出示例
  - `examples/parser-cross/`：moonbitlang/parser v0.4.4 跨平台导出示例
- 更新 README 包结构文档（含全部 27 个包 + 4 个示例）
- 更新 CLI 版本号至 v0.1.5

### Stats
- 新增示例: 3 个（总计 4 个）
- 测试: 755 个（全部通过）
- Warning: 0
- 总包数: 27

### Breaking Changes
- 无（纯新增功能）

## v0.1.4 (2026-10-16) — mooncakes 发布准备

### Highlights
- 新增 `src/publish/` 包：mooncakes 发布工具
  - 发布配置（PublishConfig）：模块名/版本/许可证/描述/仓库/README/关键词
  - 就绪检查（PublishReadiness）：7 项自动检查（模块名/版本格式/许可证/描述/仓库/README/关键词）
  - mooncakes 元数据生成（MooncakesMetadata）：注册表元数据 + 校验和
  - mooncakes.toml 配置文件生成
  - 发布命令生成（`moon publish` + `moon add`）
  - 版本一致性检查
  - 许可证兼容性检查（MIT/Apache-2.0/BSD-3-Clause/MPL-2.0/ISC）
  - 发布流程模拟（simulate_publish）
  - 发布状态管理（NotPublished/Staging/Published/Failed）
- 新增 52 个测试（总计 755 个，全部通过）

### Stats
- 新增包: src/publish/
- 新增测试: 52 个（总计 755 个，全部通过）
- Warning: 0
- 总包数: 27

### Breaking Changes
- 无（纯新增功能）

## v0.1.3 (2026-10-16) — 集成测试扩展：toml + quickcheck + parser

### Highlights
- 新增 `bobzhang/toml` v0.4.3 端到端集成测试
  - 10 导出函数（parse / to_string / get / get_string / get_int / get_double / get_bool / value_type / table_keys / array_length）
  - 2 导出类型（TomlValue / TomlError）
  - 完整四平台流水线验证
- 新增 `moonbitlang/quickcheck` v0.15.0 端到端集成测试
  - 10 导出函数（check / for_all_int / for_all_bool / for_all_string / arbitrary_int / arbitrary_bool / arbitrary_string / with_seed / minimize / result_passed）
  - 4 导出类型（Property / Arbitrary / QuickCheckResult / QuickCheckError）
  - 完整四平台流水线验证
- 新增 `moonbitlang/parser` v0.4.4 端到端集成测试
  - 10 导出函数（parse / tokenize / to_string / ast_kind / ast_children / token_kind / token_value / token_position / format / comments）
  - 4 导出类型（Token / Ast / Span / ParseError）
  - 完整四平台流水线验证
- 新增 142 个测试（总计 703 个，全部通过）

### Stats
- 新增集成目标: bobzhang/toml + moonbitlang/quickcheck + moonbitlang/parser
- 新增测试: 142 个（总计 703 个，全部通过）
- Warning: 0
- 总包数: 26

### Breaking Changes
- 无（纯新增功能）

## v0.1.2 (2026-10-15) — 自动发现 + 环境诊断 + 交互式 CLI

### Highlights
- 新增 `src/discovery/` 包：自动发现导出函数
  - 源码分析（pub fn / struct / enum / extern / derive 检测）
  - 平台 SDK 检测与智能默认
  - 导出函数/类型统计与 FFI 需求判断
  - 发现结果合并
- 新增 `src/diagnostic/` 包：环境诊断（doctor 命令）
  - MoonBit / NDK / Xcode / OHOS SDK 检查
  - 诊断报告生成（含修复建议）
  - 环境健康度判断
- 新增 `src/interactive/` 包：交互式 CLI
  - Init 向导（4 步配置：项目名/作者/模板/FFI）
  - 进度条（实时显示编译进度）
  - 构建计划树状可视化
- 新增 44 个测试（总计 561 个，全部通过）

### Stats
- 新增包: src/discovery/ + src/diagnostic/ + src/interactive/
- 新增测试: 44 个（总计 561 个，全部通过）
- Warning: 0
- 总包数: 26

### Breaking Changes
- 无（纯新增功能）

## v0.1.1 (2026-10-15) — 生态建设：API 文档 + 插件机制 + 贡献指南

### Highlights
- 新增 `src/docs/` 包：API 文档自动生成
  - 从导出函数生成 API 文档条目
  - Markdown 格式输出（含签名、描述、示例、平台支持）
  - JSON 格式输出
  - 多格式支持（Markdown / JSON / HTML）
- 新增 `src/plugin/` 包：插件机制 + 模板库
  - 插件注册/注销/启用/禁用
  - 6 种钩子（PreCompile, PostCompile, PreCodegen, PostCodegen, PreFfi, PostFfi）
  - 钩子执行与结果收集
  - 4 个内置模板（basic-library, ffi-wrapper, full-application, plugin-template）
  - 模板实例化与文件生成
- 新增 `CONTRIBUTING.md` 贡献指南
- 新增 28 个测试（总计 517 个，全部通过）

### Stats
- 新增包: src/docs/ + src/plugin/
- 新增测试: 28 个（总计 517 个，全部通过）
- Warning: 0
- 总包数: 23

### Breaking Changes
- 无（纯新增功能）

## v0.1.0 (2026-10-15) — 性能提升 + 稳定版发布

### Highlights
- 新增 `src/perf/` 包：四维性能优化
  - 并行编译：四平台并行执行 + 多架构并行 + 任务调度 + 最优并行度计算
  - 缓存机制：编译缓存 + 哈希键生成 + TTL 过期 + 容量管理 + 命中率统计
  - 增量构建：变更检测（新增/修改/删除） + 受影响平台计算 + 预热配置
  - 代码生成优化：模板特化 + 内联决策 + 死代码消除 + 优化级别（O0-O3+Os）+ LTO + 大小估算
- v0.1.0 稳定版里程碑达成
- 新增 47 个测试（总计 489 个，全部通过）

### Stats
- 新增包: src/perf/（4 个源文件 + 1 个测试文件）
- 新增测试: 47 个（总计 489 个，全部通过）
- Warning: 0
- 总包数: 21
- 总 API 数: 200+

### Breaking Changes
- 无（纯新增功能）

## v0.0.9 (2026-10-15) — 安全性增强 + CI/CD

### Highlights
- 新增 `src/security/` 包：四维安全防护
  - ASAN 验证：AddressSanitizer 编译/链接标志生成 + 运行时环境变量 + 输出分析
  - FFI 边界安全：空指针检查 + 缓冲区边界 + 类型安全 + 安全包装代码生成
  - 沙箱隔离：临时工作目录 + 超时控制 + 内存限制 + 编译命令包装
  - 供应链安全：依赖校验和验证 + 许可证兼容性检查 + 依赖锁定文件生成
- CI/CD 集成：GitHub Actions
  - `ci.yml`：push/PR 自动运行 moon check + moon test
  - `cross-compile.yml`：三平台（Ubuntu/macOS/Windows）交叉编译验证
- 新增 52 个测试（总计 442 个，全部通过）

### Stats
- 新增包: src/security/（4 个源文件 + 1 个测试文件）
- 新增测试: 52 个（总计 442 个，全部通过）
- 新增 CI/CD: 2 个 GitHub Actions 工作流
- Warning: 0

### Breaking Changes
- 无（纯新增功能）

## v0.0.8 (2026-10-15) — 鲁棒性增强

### Highlights
- 新增 `src/robust/` 包：四维鲁棒性保障
  - 重试策略：指数退避 + 超时控制 + 可配置重试次数
  - 错误恢复：部分成功恢复 + FFI 绑定回退 + 配置降级 + 失败报告生成
  - 配置校验：非空校验 + 函数名合法性 + 平台兼容性检查 + 校验结果合并
  - 边界处理：保留关键字检测 + 标识符净化 + 空输入/超大输入处理 + Unicode 检测
- 新增 42 个测试（总计 390 个，全部通过）

### Stats
- 新增包: src/robust/（4 个源文件 + 1 个测试文件）
- 新增测试: 42 个（总计 390 个，全部通过）
- Warning: 0

### Breaking Changes
- 无（纯新增功能）

## v0.0.7 (2026-10-15) — Lint + Warning 治理

### Highlights
- `moon check` warning 从 593 降至 0，全量清零
- 修复 5 类警告：
  - `reserved_keyword` (16): `macro` 变量重命名为 `export_macro`（MoonBit 保留关键字）
  - `unused_package` (52): 清理 18 个 moon.pkg 文件中未使用的依赖导入
  - `test_unqualified_package` (472): 18 个测试文件中本包引用添加 `@alias.` 前缀限定
  - `implicit_impl_as_method` (53): 为所有 `derive(Debug, Eq)` 类型添加 `pub extend` 显式声明
  - `core_package_not_imported` (27): 17 个 moon.pkg 添加 `moonbitlang/core/debug` 导入
  - `unused_value` (2): 未使用参数 `name` → `_name`
- 代码质量门禁达标，为后续 CI/CD 集成奠定基础

### Stats
- 修改文件: 18 个测试文件 + 17 个 moon.pkg + 18 个源文件（pub extend 声明）
- 测试: 348 个（全部通过，无回归）
- Warning: 593 → 0

### Breaking Changes
- 无（仅 lint 修复，不影响 API 语义）

## v0.0.6 (2026-10-15) — 中英双文注释改造

### Highlights
- 全部源码文档注释改为中英双文格式（`/// 中文 | English`）
- 21 个源文件文档注释双语化（core / config / typesys / codegen / platform / ffi / integration / scaffold / sync）
- 开源文档国际化治理，方便国际开发者理解 API 语义
- 所有 348 测试保持通过，无功能变更

### Stats
- 修改文件: 21 个源文件 + 4 个文档文件
- 测试: 348 个（全部通过，无回归）

### Breaking Changes
- 无（仅文档注释格式变更，不影响 API）

## v0.0.5 (2026-10-15) — 远期迭代增强

### Highlights
- 远期迭代增强计划制定（docs/roadmap-longterm.md）
  - 易用性：零配置启动 + 交互式 CLI + 错误提示优化 + 文档与示例
  - 鲁棒性：错误恢复 + 重试策略 + 配置校验增强 + 边界条件处理
  - 安全性：ASAN 验证 + FFI 边界安全 + 沙箱隔离 + 供应链安全
  - 性能：并行编译 + 缓存机制 + 增量构建 + 代码生成优化
- moonbitlang/openseek 跨平台集成测试
  - openseek/deepseek 纯数据层 API 跨平台导出（8 函数 + 5 类型）
  - ChatMessage/ToolDefinition/ChatResponse/Model/Role 跨平台配置
  - 四平台编译命令 + FFI 绑定 + 流水线验证
- 里程碑时间线 v0.0.5 → v0.1.0（六版本演进计划）

### Stats
- 新增测试: 47 个（总计 348 个，全部通过）
- 新增文档: 1 个（docs/roadmap-longterm.md）
- 集成测试目标库: moonbitlang/openseek（100 stars, Apache-2.0）

### Breaking Changes
- 无

## v0.0.4 (2026-10-15) — Week 4

### Highlights
- mizchi/zlib 端到端集成测试（src/integration 包）
- zlib 跨平台配置生成（10 个导出函数 + ZlibError 类型）
- zlib C wrapper 头文件 + 导出宏生成
- zlib 四平台编译命令生成（Windows DLL / Android SO / iOS dylib / 鸿蒙 SO）
- zlib 四平台 FFI 绑定类型验证（JNI / NAPI / DllImport / Swift interop）
- 完整流水线验证（config → C code → compile commands → FFI bindings）
- examples/zlib-cross 示例项目（moon-cross.json 配置 + README）
- mooncakes 发布元数据完善（description + repository）

### Stats
- 新增测试: 77 个（总计 301 个，全部通过）
- 新增包: 1 个（src/integration）
- 新增示例: 1 个（examples/zlib-cross）
- 集成测试目标库: mizchi/zlib v0.4.10（200K+ 下载，Apache-2.0）

### Breaking Changes
- 无

## v0.3.0 (2026-10-15) — Week 3

### Highlights
- iOS clang 交叉编译实现（platform/ios 包）
- 鸿蒙 OHOS clang 交叉编译实现（platform/ohos 包）
- Swift C interop 绑定生成（ffi/swift 包）
- NAPI 绑定生成 + ArkTS import + DevEco 模板（ffi/napi 包）
- iOS xcrun clang 编译命令生成（真机 + 模拟器）
- iOS XCFramework 创建命令生成
- 鸿蒙 .so 编译命令生成（aarch64-linux-ohos / x86_64-linux-ohos）
- Swift Package.swift 生成 + modulemap + bridging header
- NAPI napi_register_module_v1 生成 + ArkTS wrapper 文件
- DevEco oh-package.json5 / build-profile.json5 / module.json5 模板

### Stats
- 新增测试: 109 个（总计 224 个，全部通过）
- 新增包: 4 个（platform/ios, platform/ohos, ffi/swift, ffi/napi）
- 新增 API: 30+

### Breaking Changes
- 无

## v0.2.0 (2026-10-15) — Week 2

### Highlights
- Android NDK 交叉编译实现（platform/android 包）
- JNI 绑定代码生成（ffi/jni 包）
- Android 编译命令生成（NDK clang + target triple + sysroot）
- JNI C 函数声明生成（Java_pkg_Class_function 命名）
- Kotlin wrapper 代码生成（external fun + System.loadLibrary）
- Gradle 模块模板生成（android block + dependencies）
- CMakeLists.txt 骨架生成（add_library + target_link_libraries）

### Stats
- 新增测试: 55 个（总计 115 个，全部通过）
- 新增包: 2 个（platform/android, ffi/jni）
- 新增 API: 20+

### Breaking Changes
- 无

## v0.1.0 (2026-10-15) — Week 1

### Highlights
- 项目骨架建立，11 个分层包结构（src/ 下，禁止平铺）
- CLI 入口（build/check/plan/init/sync 五命令骨架）
- 核心类型层（Platform/Arch/TargetTriple/MoonCrossError）
- 配置解析层（CrossConfig + moon-cross.json schema）
- 类型映射层（MoonBit → C → 四平台类型映射表）
- C 适配层代码生成引擎
- 平台抽象 + Windows 平台实现
- FFI 绑定生成（JNI/NAPI/DllImport/Swift interop）
- 脚手架初始化（init 命令，自动初始化跨平台项目）
- 增量同步（sync 命令，更新代码后自动配置各平台）

### Stats
- 公共 API: 30+
- 测试: 60 个（全部通过）
- 包: 11 个（src/ 下分层结构）

### Breaking Changes
- 无（首次发布）
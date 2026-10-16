# Changelog

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
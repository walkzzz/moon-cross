# Roadmap

## Progress

| Phase | Status | Description | Tests |
|-------|--------|-------------|-------|
| Week 1 | ✅ Done | CLI 骨架 + 配置解析 + C 适配层 + Windows + 脚手架 + 同步 | 60 |
| Week 2 | ✅ Done | Android NDK 交叉编译 + JNI 绑定生成 | 55 |
| Week 3 | ✅ Done | iOS clang + Swift interop + 鸿蒙 OHOS + NAPI | 109 |
| Week 4 | ✅ Done | mizchi/zlib 集成测试 + 示例项目 + mooncakes 发布准备 | 77 |
| v0.0.6 | ✅ Done | 中英双文注释改造 | 348 |
| v0.0.7 | ✅ Done | Lint + Warning 治理（593→0） | 348 |
| v0.0.8 | ✅ Done | 鲁棒性增强（重试+恢复+校验+边界） | 390 |
| v0.0.9 | ✅ Done | 安全性增强（ASAN+FFI安全+沙箱+供应链）+ CI/CD | 442 |
| v0.1.0 | ✅ Done | 性能提升（并行+缓存+增量+优化）— 稳定版 | 489 |
| v0.1.1 | ✅ Done | 生态建设（API文档+插件机制+模板库+贡献指南） | 517 |
| v0.1.2 | ✅ Done | 自动发现+环境诊断+交互式CLI | 561 |
| v0.1.3 | ✅ Done | 集成测试扩展（toml+quickcheck+parser） | 703 |
| v0.1.4 | ✅ Done | mooncakes 发布准备（publish 包+元数据生成+就绪检查） | 755 |
| v0.1.5 | ✅ Done | 示例项目+文档完善（toml/quickcheck/parser 示例） | 755 |
| v0.1.6 | ✅ Done | 性能基准测试包（统计+比较+套件） | 797 |
| v0.1.7 | ✅ Done | 编译追踪与日志包（事件+区间+收集器） | 835 |
| v0.1.8 | ✅ Done | 配置 lint 规则包（8 内置规则+过滤+格式化） | 874 |
| v0.1.9 | ✅ Done | 集成测试扩展（base64+json+hash） | 904 |
| v0.2.0 | ✅ Done | 代码格式化包（缩进+换行+规则引擎） | 939 |
| v0.2.1 | ✅ Done | 测试覆盖率分析包（条目+报告+统计） | 977 |
| v0.2.2 | ✅ Done | 文件监视器包（事件+过滤+去重） | 1002 |
| v0.2.3 | ✅ Done | 集成测试扩展（regexp+uuid+bufio） | 1036 |
| v0.2.4 | ✅ Done | 代码差异分析包（行差异+格式化+反转） | 1066 |
| v0.2.5 | ✅ Done | 依赖分析包（图+环检测+拓扑排序） | 1096 |
| v0.2.6 | ✅ Done | 性能分析器包（条目+报告+热点分析） | 1121 |
| v0.2.7 | ✅ Done | 序列化包（JSON序列化+反序列化+转义） | 1150 |
| v0.2.8 | ✅ Done | 图算法包（BFS+DFS+最短路径+连通分量） | 1182 |
| v0.2.9 | ✅ Done | 数据验证包（规则+错误+批量验证） | 1216 |
| v0.2.10 | ✅ Done | 集成测试扩展（crypto+time+sort） | 1248 |
| v0.2.11 | ✅ Done | 缓存管理包（LRU+FIFO+TTL+统计） | 1274 |
| v0.2.12 | ✅ Done | 对象池包（预分配+收缩+过期清理） | 1301 |
| v0.2.13 | ✅ Done | 事件系统包（总线+处理器+优先级+过滤） | 1326 |
| v0.2.14 | ✅ Done | 状态机包（状态+转换+历史+统计） | 1351 |
| v0.2.15 | ✅ Done | 集成测试扩展（net+io+math） | 1388 |
| v0.2.16 | ✅ Done | 信号处理包（注册/分发/优先级/统计） | 1410 |
| v0.2.17 | ✅ Done | 定时器包（一次性/周期/触发判断/统计） | 1433 |
| v0.2.18 | ✅ Done | 日志系统包（分级/过滤/格式化/容量管理） | 1457 |
| v0.2.19 | ✅ Done | 资源管理包（追踪/泄漏检测/释放/统计） | 1481 |

## 远期计划预览（v0.2.16 → v1.0.0）

> 完整计划见 [roadmap-longterm.md](./roadmap-longterm.md)

### 参赛冲刺（v0.2.16 → v0.3.0，截止 2026-10-31）

| 版本 | 内容 | 预估测试 |
|------|------|----------|
| v0.2.16-v0.2.20 | signal/timer/logging/resource + 集成测试(encoding+container+random) | ~1530 |
| v0.2.21-v0.2.25 | argparse/http/uri/template + 集成测试(fs+path+process) | ~1700 |
| v0.2.26-v0.2.30 | regex_enhanced/crypto_util/concurrency/memory + 集成测试(math64+bits+fmt) | ~1900 |
| **v0.3.0** | **参赛发布版（2000+ 测试，60+ 包，mooncakes 发布）** | **2000+** |

### 参赛后演进

| 阶段 | 版本 | 重点 |
|------|------|------|
| 工具链生态 | v0.3.1-v0.4.0 | IDE 集成 + CI/CD + 插件 SDK |
| 跨平台覆盖 | v0.4.1-v0.5.0 | Linux/macOS/WASM + 条件编译 |
| 性能极致 | v0.5.1-v0.6.0 | 并行编译 + 增量 + 缓存 + 代码优化 |
| 生产就绪 | v0.6.1-v1.0.0 | 安全加固 + 可观测性 + SLSA-3 |

## Week 1 Deliverables (2026-10-15)

- [x] 分层包结构（src/core, config, typesys, codegen, platform, ffi, scaffold, sync, cli）
- [x] CLI 命令骨架（build, check, plan, init, sync）
- [x] 核心类型（Platform, Arch, TargetTriple, MoonCrossError）
- [x] 配置解析（CrossConfig, ExportFunction, ExportType）
- [x] 类型映射（MoonBitType, CType, moonbit_to_c）
- [x] C 适配层代码生成（CodegenResult, generate_export_macro）
- [x] 平台规格（PlatformSpec, platform_spec）
- [x] Windows 平台（WindowsCompileConfig, windows_compile_command）
- [x] FFI 绑定（FfiBindingType, ffi_binding_for_platform）
- [x] 脚手架（ScaffoldOptions, scaffold_file_list）
- [x] 增量同步（SyncResult, sync_success, sync_failure）
- [x] 60 个单元测试（全部通过）

## Week 2 Plan

- [x] Android NDK 交叉编译实现
- [x] JNI 绑定代码生成
- [x] Android Gradle 模块模板
- [x] 55 个新增测试

## Week 3 Deliverables (2026-10-15)

- [x] iOS clang 交叉编译（platform/ios 包）
- [x] iOS XCFramework 创建命令
- [x] 鸿蒙 OHOS clang 交叉编译（platform/ohos 包）
- [x] Swift C interop 绑定生成（ffi/swift 包）
- [x] Swift Package.swift + modulemap + bridging header
- [x] NAPI 绑定生成 + ArkTS import（ffi/napi 包）
- [x] DevEco oh-package.json5 / build-profile.json5 / module.json5 模板
- [x] 109 个新增测试（全部通过）
## Week 4 Deliverables (2026-10-15)

- [x] mizchi/zlib 端到端集成测试（src/integration 包）
- [x] zlib 跨平台配置生成（10 个导出函数 + ZlibError 类型）
- [x] C wrapper 头文件 + 导出宏生成验证
- [x] 四平台编译命令生成验证
- [x] 四平台 FFI 绑定类型验证
- [x] 完整流水线验证（validate_pipeline）
- [x] examples/zlib-cross 示例项目
- [x] mooncakes 发布元数据完善
- [x] 77 个新增测试（总计 301 个，全部通过）
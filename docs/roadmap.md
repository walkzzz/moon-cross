# Roadmap

## Progress

| Phase | Status | Description | Tests |
|-------|--------|-------------|-------|
| Week 1 | ✅ Done | CLI 骨架 + 配置解析 + C 适配层 + Windows + 脚手架 + 同步 | 60 |
| Week 2 | ✅ Done | Android NDK 交叉编译 + JNI 绑定生成 | 55 |
| Week 3 | ✅ Done | iOS clang + Swift interop + 鸿蒙 OHOS + NAPI | 109 |
| Week 4 | ✅ Done | mizchi/zlib 集成测试 + 示例项目 + mooncakes 发布准备 | 77 |
| v0.6.0 | ✅ Done | 中英双文注释改造 | 348 |
| v0.7.0 | ✅ Done | Lint + Warning 治理（593→0） | 348 |
| v0.8.0 | ✅ Done | 鲁棒性增强（重试+恢复+校验+边界） | 390 |
| v0.9.0 | ✅ Done | 安全性增强（ASAN+FFI安全+沙箱+供应链）+ CI/CD | 442 |

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
# Roadmap

## Progress

| Phase | Status | Description | Tests |
|-------|--------|-------------|-------|
| Week 1 | ✅ Done | CLI 骨架 + 配置解析 + C 适配层 + Windows + 脚手架 + 同步 | 60 |
| Week 2 | ✅ Done | Android NDK 交叉编译 + JNI 绑定生成 | 55 |
| Week 3 | ✅ Done | iOS clang + Swift interop + 鸿蒙 OHOS + NAPI | 109 |
| Week 4 | ⏳ Pending | 集成测试 + stb-image 示例 + mooncakes 发布 | 200+ |

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
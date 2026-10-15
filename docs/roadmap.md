# Roadmap

## Progress

| Phase | Status | Description | Tests |
|-------|--------|-------------|-------|
| Week 1 | ✅ Done | CLI 骨架 + 配置解析 + C 适配层 + Windows + 脚手架 + 同步 | 60 |
| Week 2 | ✅ Done | Android NDK 交叉编译 + JNI 绑定生成 | 55 |
| Week 3 | ⏳ Pending | iOS clang + Swift interop + 鸿蒙 OHOS | +50 |
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

- [ ] Android NDK 交叉编译实现
- [ ] JNI 绑定代码生成
- [ ] Android Gradle 模块模板
- [ ] 50 个新增测试
# Changelog

## v0.6.0 (2026-10-15) — 中英双文注释改造

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

## v0.5.0 (2026-10-15) — 远期迭代增强

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
- 里程碑时间线 v0.5.0 → v1.0.0（六版本演进计划）

### Stats
- 新增测试: 47 个（总计 348 个，全部通过）
- 新增文档: 1 个（docs/roadmap-longterm.md）
- 集成测试目标库: moonbitlang/openseek（100 stars, Apache-2.0）

### Breaking Changes
- 无

## v0.4.0 (2026-10-15) — Week 4

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
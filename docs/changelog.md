# Changelog

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
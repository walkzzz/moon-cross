# Changelog

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
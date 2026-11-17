# moon-cross 项目申报书

> 2026 MoonBit 季度黑客松 | 方向：开发者工具 — 跨平台框架

## 基本信息

- 项目名称：Moon Cross：MoonBit 跨平台 Native 框架
- 参赛者：walkzzz
- GitHub 仓库：https://github.com/walkzzz/moon-cross
- mooncakes 包名：`walkzzz/moon-cross`（v0.3.36）
- 是否为移植项目：否（原创框架）

## 项目简介

Moon Cross 将任意纯 MoonBit 库**一次编写，五平台交付**——iOS / Android / Windows / 鸿蒙 / Linux。基于 MoonBit native 后端的 `foreign_library` + `#export_name` 机制，MoonBit 代码编译为平台原生静态库；框架自动生成 C 适配层（运行时初始化、marshalling、引用计数管理）、五平台 FFI 绑定（Swift interop / JNI / C# DllImport / NAPI+ArkTS / C header）与构建脚本，外层 C 编译器再封装为 `.so`/`.dll`/`.framework`。mooncakes 生态调研确认无同类"MoonBit 库→多平台原生库导出"项目（moonbindgen 方向相反、proton/ffi 为字符串 helper、native-gui/moobile 为应用框架）。

## 预期使用场景

1. **图像/算法库作者上架移动端**：纯 MoonBit 图像处理库（如 stb-image 类）希望被 iOS App（Swift）与 Android App（Kotlin）直接调用——用 moon-cross `init` + `build` 生成 `.framework` 与 JNI 绑定工程，无需手写任何 FFI 胶水。
2. **鸿蒙生态迁移**：持有既有 MoonBit 数据处理库的团队需在鸿蒙 ArkTS 应用中复用核心逻辑——moon-cross 产出 OHOS SDK 可交叉编译的静态库与 NAPI 绑定，`moon-cross doctor` 自动检测 OHOS SDK 环境。
3. **桌面工具分发**：为 Windows/Linux 用户发布原生 CLI 或插件（C# P/Invoke / C dlopen），同一份 MoonBit 代码通过 `moon-cross build --platform windows,linux` 一次产出两端绑定与 Makefile。

## 拟实现的核心功能（当前完成度）

- CLI 八命令全部真实可用：`init`（脚手架落盘 5 文件）/ `build`（C 适配层+五平台绑定+Makefile 落盘）/ `check`（配置校验）/ `plan` / `sync` / `doctor`（子进程探测工具链）/ `publish` / `wizard`
- 类型映射：标量 / String / Bytes / Array[T] / Struct → 五平台原生类型
- 4 个可运行示例：zlib（mizchi/zlib）、toml（moonbit-community/toml）、quickcheck、parser，18 个示例测试全通过
- 端到端实证（Linux）：`scripts/e2e_linux.sh` 脚手架→静态库→C 宿主 `moonbit_init()`→调用断言 PASS，接入 CI

## 技术路线

`moon build --target native --release`（foreign_library 包）→ 静态库 `src.a`/`src.lib` → moon-cross 生成的 C 适配层 + 绑定 → 各平台 C 编译器 `-shared` 封装。官方文档确认 native 后端生成 moonc C 中间源，`#export_name` 提供稳定符号；String 经 UTF-8 转换层，FFI 以 Int/Double/Bool/Bytes 为主。

## 开源合规

MIT License。参考项目已标注于申报与仓库文档：MoonBit native 后端机制（官方文档）、JNA（JNI 绑定参考）、Swift Package Manager、Node-API（NAPI 规范）。

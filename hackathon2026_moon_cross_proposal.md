# moon-cross 项目申报书

> 2026 MoonBit 十月赛参赛申报 | 方向：开发者工具 | 截止：2026-10-31

---

## 基本信息

- 项目名称：Moon Cross：MoonBit 跨平台 Native 框架
- 参赛者：walkzzz
- 联系方式：（待填写）
- GitHub 仓库链接：https://github.com/walkzzz/moon-cross.git
- mooncakes 包名：`walkzzz/moon-cross`
- 项目方向：开发者工具 — 跨平台框架与开发体验
- 是否为移植项目：否（原创框架，独立实现 iOS/Android/Windows/鸿蒙四平台支持）

---

## 项目简介

Moon Cross 是一个 MoonBit 跨平台 Native 框架，将任意纯 MoonBit 库**一次编写，四平台交付**——iOS / Android / Windows / 鸿蒙（HarmonyOS）。框架提供统一的 API 抽象层、自动 FFI 绑定生成、各平台运行时适配和工程模板，开发者只需声明导出函数签名，框架自动完成：C 代码生成 → 各平台交叉编译 → FFI 绑定代码生成 → 平台工程打包。

项目面向需要在移动端、桌面端和鸿蒙端使用 MoonBit 核心逻辑的库作者和应用开发者。以 stb-image（纯 MoonBit 图像处理库）为例，通过 Moon Cross 可将图像解码/编码/处理函数导出为 iOS Framework、Android JNI .so、Windows DLL 和鸿蒙 NAPI .so，各平台前端（Swift/Java/C#/ArkTS）直接调用。

mooncakes 生态调研确认：截至 2026-10-15，**无任何 MoonBit 跨平台框架**（iOS+Android+Windows+鸿蒙四平台统一支持），本项目填补该空白。框架独立实现鸿蒙 NAPI 适配，不依赖外部鸿蒙工具链。

---

## 技术方案

### 编译流水线

```
MoonBit 源码
    │
    ├─ moon build --target native          # MoonBit native 后端
    │
    ▼
C 代码 (main.c + runtime/*.c + moonbit.h)   # 平台无关中间表示
    │
    ├─ moon-cross codegen                  # 生成 C 适配层 + FFI 绑定
    │
    ▼
各平台交叉编译
    ├── iOS:      xcrun clang -target arm64-apple-ios           → .dylib / .framework
    ├── Android:  $NDK/clang -target aarch64-linux-android24   → .so (JNI)
    ├── Windows:  clang-cl / cl.exe                             → .dll
    └── 鸿蒙:     $OHOS_SDK/clang -target aarch64-linux-ohos   → .so (NAPI)
    │
    ▼
各平台 FFI 绑定代码生成
    ├── iOS:      Swift Package / XCFramework
    ├── Android:  Kotlin JNI 声明 + Gradle 模块
    ├── Windows:  C# DllImport / C++ 头文件
    └── 鸿蒙:     ArkTS import + NAPI 接口
```

### 各平台编译配置

| 平台 | 编译器 | Target Triple | Sysroot/SDK | 输出格式 | FFI 机制 |
|------|--------|--------------|-------------|---------|---------|
| iOS | `xcrun clang` | `arm64-apple-ios` | `iphoneos.sdk` | `.dylib` / `.a` / `.framework` | Swift C interop / `dlopen` |
| Android | `$NDK/clang` | `aarch64-linux-android24` | NDK sysroot | `.so` | `System.loadLibrary` + JNI |
| Windows | `clang-cl` / `cl.exe` | `x86_64-pc-windows-msvc` | MSVC CRT | `.dll` | `[DllImport]` / `LoadLibrary` |
| 鸿蒙 | `$OHOS/clang` | `aarch64-linux-ohos` | OHOS SDK | `.so` | `import native from 'libxxx.so'` |

### C 代码平台无关性（已验证）

MoonBit native 后端生成的 C 代码具有以下特征（2026-10-15 实测验证）：

- **标准 C 头文件**：仅依赖 `stddef.h` / `stdint.h` / `math.h`
- **平台条件极少**：仅 `_WIN32` 的 `__declspec(dllexport)` vs `__attribute__((visibility))` 差异
- **运行时零平台依赖**：`runtime-*.c`（utf/sync_io/env/backtrace/runtime）无平台条件
- **引用计数内存管理**：非 GC，各平台无需特殊运行时支持
- **函数导出统一**：`MOONBIT_EXPORT` 宏跨平台一致

### 类型映射

| MoonBit | C 适配层 | iOS (Swift) | Android (Kotlin) | Windows (C#) | 鸿蒙 (ArkTS) |
|---------|---------|-------------|-----------------|-------------|-------------|
| `Int` | `int32_t` | `Int32` | `Int` | `int` | `number` |
| `Double` | `double` | `Double` | `Double` | `double` | `number` |
| `Bool` | `int32_t` | `Bool` | `Boolean` | `bool` | `boolean` |
| `String` | `moonbit_string_t` | `String` | `String` | `string` | `string` |
| `Bytes` | `moonbit_bytes_t` | `Data` | `ByteArray` | `byte[]` | `Uint8Array` |
| `Array[T]` | 不透明指针 | `UnsafePointer` | `Long` (handle) | `IntPtr` | `Object` |
| Struct | 不透明指针 | `OpaquePointer` | `Long` (handle) | `IntPtr` | `Object` |

### 配置文件格式（moon-cross.json）

```json
{
  "version": 1,
  "module": "./my-lib",
  "package": "walkzzz/my-lib",
  "targets": ["ios", "android", "windows", "ohos"],
  "functions": [
    {
      "name": "decode_png",
      "params": [{"name": "data", "type": "Bytes"}],
      "return": "Bytes"
    },
    {
      "name": "convex_hull",
      "params": [{"name": "points", "type": "Array[Double]"}],
      "return": "Array[Double]"
    }
  ],
  "types": [
    {"name": "Point2D", "fields": [
      {"name": "x", "type": "Double"},
      {"name": "y", "type": "Double"}
    ]}
  ]
}
```

---

## 核心功能范围

### CLI 工具

- `moon-cross build --config moon-cross.json --platform ios,android,windows,ohos` — 一键四平台编译
- `moon-cross build --platform ios --arch arm64,x86_64` — 指定平台和架构
- `moon-cross check --config moon-cross.json` — 验证配置和函数签名
- `moon-cross plan --config moon-cross.json` — 输出构建计划（dry-run）
- `moon-cross init --name my-lib --platform all` — 初始化跨平台项目骨架

### C 适配层代码生成

- 自动生成 C wrapper 函数，处理 MoonBit 运行时初始化、参数转换、引用计数管理
- 自动生成各平台入口：JNI `Java_xxx_native` / NAPI `napi_value` / Swift C interop / DLL `__declspec(dllexport)`
- 内存管理：输入参数复制到 C 缓冲区 → MoonBit 调用 → 结果复制到平台类型 → 释放引用

### 各平台工程模板

- **iOS**：Swift Package + XCFramework + Swift C interop 声明
- **Android**：Gradle 模块 + JNI 声明 + Kotlin wrapper
- **Windows**：MSVC 工程 + C# P/Invoke 声明 / C++ 头文件
- **鸿蒙**：DevEco 工程 + ArkTS NAPI 声明

### 类型系统支持

- 标量类型：`Int` / `Double` / `Bool` / `Unit`
- 字符串/字节：`String` / `Bytes`（UTF-16/UTF-8 自动转换）
- 容器类型：`Array[T]`（不透明指针 + 访问函数）
- 具名 Struct（不透明指针 + 字段访问函数）
- 类型依赖无环检查

### 质量与测试

- 不少于 **200 个 MoonBit 测试**（框架自身）+ 各平台集成测试
- 四平台真机/模拟器验证：iOS Simulator / Android Emulator / Windows 本地 / 鸿蒙模拟器
- 与 MoonBit native 后端对照的回归测试
- 提供 README 示例，覆盖 stb-image 和 moon-geometry 的跨平台导出

---

## 一个月交付计划

| 周次 | 交付内容 | 验收标准 |
|------|---------|---------|
| Week 1 | CLI 骨架 + 配置解析 + C 适配层代码生成 + Windows 平台 | `moon-cross build --platform windows` 可用 + 50 测试 |
| Week 2 | Android NDK 交叉编译 + JNI 绑定生成 | Android .so + JNI 声明 + 50 测试 |
| Week 3 | iOS clang 交叉编译 + Swift interop + 鸿蒙 OHOS 交叉编译 | 四平台 .so/.dylib/.dll + 50 测试 |
| Week 4 | 集成测试 + stb-image 跨平台示例 + mooncakes 发布 | 200+ 测试 + 四平台示例可运行 |

---

## 参考与设计说明

- 参考项目 1：[MoonBit native 后端](https://docs.moonbitlang.com/) — C 代码生成机制
- 参考项目 2：[Java Native Access (JNA)](https://github.com/java-native-access/jna) — JNI 动态绑定参考
- 参考项目 3：[Swift Package Manager](https://github.com/apple/swift-package-manager) — iOS Framework 打包参考
- 参考项目 4：[Node-API](https://nodejs.org/api/n-api.html) — 鸿蒙 NAPI 接口规范参考
- 本项目许可证：MIT License

### 设计原则

- **独立实现**：四平台适配层全部自主实现，不依赖任何外部平台工具链项目
- **统一配置**：单一 `moon-cross.json` 声明，一次构建四平台交付
- **统一类型映射**：一套 MoonBit 类型 → 四平台原生类型映射表
- **自动 C 适配层生成**：自动生成各平台 FFI 入口代码（JNI/NAPI/DllImport/Swift interop）
- **框架级抽象**：不仅提供编译能力，还提供运行时初始化、内存管理适配、错误处理统一接口

### 生态协同

- **stb-image**（图像处理）：跨平台图像解码/编码/处理，iOS/Android/Windows/鸿蒙统一调用
- **moon-geometry**（计算几何）：跨平台几何计算，CAD/GIS/游戏碰撞检测
- **任意纯 MoonBit 库**：只要无 C FFI 依赖，均可通过 Moon Cross 跨平台导出

---

## 验收标准对齐（大赛要求）

| 大赛验收项 | 本项目满足方式 |
|-----------|-------------|
| MoonBit 为主 | 框架自身 100% MoonBit 实现（CLI + 代码生成 + 配置解析 + 运行时适配） |
| 仓库公开 | GitHub 公开仓库，持续提交 |
| 能够运行 | README + 可运行示例（stb-image 跨平台导出）+ 200+ 测试 |
| 工作有效 | 全新原创项目，10 月从零开发 |
| 开源合规 | MIT License，参考来源已标注 |
| AI 可解释 | AI 辅助开发，所有代码生成逻辑经人工审查 |

---

## 技术亮点

1. **一次编译，四平台交付** — MoonBit native → C → iOS/Android/Windows/鸿蒙，开发者零平台知识门槛
2. **填补生态空白** — mooncakes 首个跨平台（四平台）MoonBit 框架
3. **C 代码平台无关** — 已验证 MoonBit native 后端生成的 C 代码仅 `_WIN32` 条件差异，runtime 零平台依赖
4. **自动 FFI 绑定生成** — 自动生成 JNI/NAPI/DllImport/Swift interop，开发者只需声明函数签名
5. **引用计数内存管理** — 非 GC，各平台无需特殊运行时，嵌入成本低
6. **生态协同** — stb-image + moon-geometry + 任意纯 MoonBit 库均可跨平台导出
7. **开发者工具方向** — 直接改善 MoonBit 跨平台开发体验，契合大赛"开发者工具"方向

---

## 技术风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| iOS 需 macOS 构建环境 | 无法在 Windows 直接交叉编译 iOS | 支持 CI/CD（GitHub Actions macOS runner） |
| Android NDK 版本碎片化 | 不同 NDK 版本 ABI 差异 | 锁定 NDK r26+，文档说明 |
| 鸿蒙 SDK 非公开下载 | 需 DevEco Studio | 文档说明安装步骤，`--sdk` 参数指定 |
| MoonBit native 后端 C ABI 不稳定 | 跨版本兼容性 | 锁定 MoonBit 版本，`moon-cross check` 版本校验 |
| Array/Struct 不透明指针 | 各平台需 wrapper | 自动生成访问函数 + 平台 wrapper 代码 |
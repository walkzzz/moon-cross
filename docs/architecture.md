# Architecture

## 包结构（分层，禁止平铺）

```
src/
├── core/           # 核心类型与错误（Platform/Arch/TargetTriple/MoonCrossError）
├── config/         # moon-cross.json 配置解析与校验
├── typesys/        # MoonBit → C → 四平台类型映射
├── codegen/        # 代码生成引擎
│   └── c/          #   C 适配层生成
├── platform/       # 平台抽象与实现
│   └── windows/    #   Windows 平台
├── ffi/            # FFI 绑定生成（JNI/NAPI/DllImport/Swift）
├── scaffold/       # 脚手架（init 初始化跨平台项目）
├── sync/           # 增量同步（更新代码后自动配置各平台）
└── cli/            # CLI 入口（main 包）
```

## 依赖层次

```
core（无依赖）
  ← config, typesys
    ← codegen, codegen/c, platform, ffi, scaffold
      ← sync
        ← cli
```

## 编译流水线

```
MoonBit 源码 → moon build --target native → C 代码
  → moon-cross codegen → C 适配层 + FFI 绑定
  → 各平台交叉编译 → iOS/Android/Windows/鸿蒙
```

## 设计原则

- **分层架构**：core ← config ← typesys ← codegen ← platform ← ffi ← scaffold/sync ← cli
- **禁止平铺**：每个职责独立包，子包层次清晰
- **pub(all) 可见性**：跨包构造的类型用 pub(all) 标记
- **derive(Debug, Eq)**：数据类型自动派生 Debug 和 Eq

## 类型映射

| MoonBit | C 适配层 | iOS (Swift) | Android (Kotlin) | Windows (C#) | 鸿蒙 (ArkTS) |
|---------|---------|-------------|-----------------|-------------|-------------|
| Int | int32_t | Int32 | Int | int | number |
| Double | double | Double | Double | double | number |
| Bool | int32_t | Bool | Boolean | bool | boolean |
| String | moonbit_string_t | String | String | string | string |
| Bytes | moonbit_bytes_t | Data | ByteArray | byte[] | Uint8Array |
| Array[T] | void* | UnsafePointer | Long | IntPtr | Object |
| Struct | void* | OpaquePointer | Long | IntPtr | Object |
# toml-cross：bobzhang/toml 跨平台导出示例

> 使用 Moon Cross 将 [bobzhang/toml](https://mooncakes.io/docs/bobzhang/toml@0.4.3) v0.4.3 导出为四平台 Native 库

## 概述

本示例展示如何使用 Moon Cross 框架，将 mooncakes 上的 TOML 解析库 `bobzhang/toml` 一次导出为 iOS / Android / Windows / 鸿蒙四平台 Native 库。

## 前置条件

```bash
# 安装 MoonBit 工具链
# https://www.moonbitlang.com/download/

# 添加 bobzhang/toml 依赖
moon add bobzhang/toml@0.4.3
```

## 使用方法

```bash
# 1. 初始化跨平台项目
moon-cross init --name toml-cross --platform all

# 2. 一键四平台编译
moon-cross build --config moon-cross.json --platform ios,android,windows,ohos

# 3. 验证配置
moon-cross check --config moon-cross.json

# 4. 查看构建计划
moon-cross plan --config moon-cross.json
```

## 导出的函数

| 函数 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `toml_parse` | `String` | `TomlValue` | 解析 TOML 字符串 |
| `toml_to_string` | `TomlValue` | `String` | 序列化为 TOML 字符串 |
| `toml_get` | `TomlValue, String` | `TomlValue` | 按键获取值 |
| `toml_get_string` | `TomlValue, String` | `String` | 获取字符串值 |
| `toml_get_int` | `TomlValue, String` | `Int` | 获取整数值 |
| `toml_get_double` | `TomlValue, String` | `Double` | 获取浮点值 |
| `toml_get_bool` | `TomlValue, String` | `Bool` | 获取布尔值 |
| `toml_value_type` | `TomlValue` | `String` | 获取值类型 |
| `toml_table_keys` | `TomlValue` | `Array` | 获取表所有键 |
| `toml_array_length` | `TomlValue` | `Int` | 获取数组长度 |

## 四平台输出

| 平台 | 输出格式 | FFI 机制 | 编译器 |
|------|----------|----------|--------|
| iOS | `.dylib` / `.xcframework` | Swift C interop | xcrun clang |
| Android | `.so` | JNI | NDK clang |
| Windows | `.dll` | DllImport | clang-cl |
| 鸿蒙 | `.so` | NAPI + ArkTS | OHOS clang |

## 许可证

bobzhang/toml 使用 Apache-2.0 许可证，Moon Cross 使用 MIT 许可证。
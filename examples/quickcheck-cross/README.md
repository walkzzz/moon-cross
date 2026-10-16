# quickcheck-cross：moonbitlang/quickcheck 跨平台导出示例

> 使用 Moon Cross 将 [moonbitlang/quickcheck](https://mooncakes.io/docs/moonbitlang/quickcheck@0.15.0) v0.15.0 导出为四平台 Native 库

## 概述

本示例展示如何使用 Moon Cross 框架，将 mooncakes 上的属性测试库 `moonbitlang/quickcheck` 一次导出为 iOS / Android / Windows / 鸿蒙四平台 Native 库。

## 前置条件

```bash
# 安装 MoonBit 工具链
# https://www.moonbitlang.com/download/

# 添加 moonbitlang/quickcheck 依赖
moon add moonbitlang/quickcheck@0.15.0
```

## 使用方法

```bash
# 1. 初始化跨平台项目
moon-cross init --name quickcheck-cross --platform all

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
| `quickcheck_check` | `Property, Int` | `QuickCheckResult` | 运行属性检查 |
| `quickcheck_for_all_int` | `Property` | `QuickCheckResult` | 检查所有整数 |
| `quickcheck_for_all_bool` | `Property` | `QuickCheckResult` | 检查所有布尔值 |
| `quickcheck_for_all_string` | `Property` | `QuickCheckResult` | 检查所有字符串 |
| `quickcheck_arbitrary_int` | `UInt` | `Int` | 生成随机整数 |
| `quickcheck_arbitrary_bool` | `UInt` | `Bool` | 生成随机布尔值 |
| `quickcheck_arbitrary_string` | `UInt, Int` | `String` | 生成随机字符串 |
| `quickcheck_with_seed` | `Property, UInt, Int` | `QuickCheckResult` | 指定种子检查 |
| `quickcheck_minimize` | `QuickCheckResult, Property` | `QuickCheckResult` | 最小化反例 |
| `quickcheck_result_passed` | `QuickCheckResult` | `Bool` | 检查是否通过 |

## 四平台输出

| 平台 | 输出格式 | FFI 机制 | 编译器 |
|------|----------|----------|--------|
| iOS | `.dylib` / `.xcframework` | Swift C interop | xcrun clang |
| Android | `.so` | JNI | NDK clang |
| Windows | `.dll` | DllImport | clang-cl |
| 鸿蒙 | `.so` | NAPI + ArkTS | OHOS clang |

## 许可证

moonbitlang/quickcheck 使用 Apache-2.0 许可证，Moon Cross 使用 MIT 许可证。
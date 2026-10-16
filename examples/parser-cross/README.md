# parser-cross：moonbitlang/parser 跨平台导出示例

> 使用 Moon Cross 将 [moonbitlang/parser](https://mooncakes.io/docs/moonbitlang/parser@0.4.4) v0.4.4 导出为四平台 Native 库

## 概述

本示例展示如何使用 Moon Cross 框架，将 mooncakes 上的 AST 解析库 `moonbitlang/parser` 一次导出为 iOS / Android / Windows / 鸿蒙四平台 Native 库。

## 前置条件

```bash
# 安装 MoonBit 工具链
# https://www.moonbitlang.com/download/

# 添加 moonbitlang/parser 依赖
moon add moonbitlang/parser@0.4.4
```

## 使用方法

```bash
# 1. 初始化跨平台项目
moon-cross init --name parser-cross --platform all

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
| `parser_parse` | `String` | `Ast` | 解析源码为 AST |
| `parser_tokenize` | `String` | `Array` | 词法分析 |
| `parser_to_string` | `Ast` | `String` | AST 转源码 |
| `parser_ast_kind` | `Ast` | `String` | 获取 AST 节点类型 |
| `parser_ast_children` | `Ast` | `Array` | 获取 AST 子节点 |
| `parser_token_kind` | `Token` | `String` | 获取 token 类型 |
| `parser_token_value` | `Token` | `String` | 获取 token 值 |
| `parser_token_position` | `Token` | `Span` | 获取 token 位置 |
| `parser_format` | `Ast` | `String` | 格式化 AST |
| `parser_comments` | `Ast` | `Array` | 提取注释 |

## 四平台输出

| 平台 | 输出格式 | FFI 机制 | 编译器 |
|------|----------|----------|--------|
| iOS | `.dylib` / `.xcframework` | Swift C interop | xcrun clang |
| Android | `.so` | JNI | NDK clang |
| Windows | `.dll` | DllImport | clang-cl |
| 鸿蒙 | `.so` | NAPI + ArkTS | OHOS clang |

## 许可证

moonbitlang/parser 使用 Apache-2.0 许可证，Moon Cross 使用 MIT 许可证。
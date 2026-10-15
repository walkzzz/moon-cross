# zlib-cross：mizchi/zlib 跨平台导出示例

> 使用 Moon Cross 将 [mizchi/zlib](https://mooncakes.io/docs/mizchi/zlib@0.4.10) v0.4.10 导出为四平台 Native 库

## 概述

本示例展示如何使用 Moon Cross 框架，将 mooncakes 上的成熟纯 MoonBit 库 `mizchi/zlib`（zlib/deflate 压缩库，200K+ 下载）一次导出为 iOS / Android / Windows / 鸿蒙四平台 Native 库。

## 前置条件

```bash
# 安装 MoonBit 工具链
# https://www.moonbitlang.com/download/

# 添加 mizchi/zlib 依赖
moon add mizchi/zlib@0.4.10
```

## 使用方法

```bash
# 1. 初始化跨平台项目
moon-cross init --name zlib-cross --platform all

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
| `zlib_compress` | `Bytes` | `Bytes` | zlib 压缩 |
| `zlib_decompress` | `Bytes` | `Bytes` | zlib 解压 |
| `deflate_compress` | `Bytes` | `Bytes` | deflate 压缩 |
| `deflate_decompress` | `Bytes` | `Bytes` | deflate 解压 |
| `gzip_compress` | `Bytes` | `Bytes` | gzip 压缩 |
| `gzip_decompress` | `Bytes` | `Bytes` | gzip 解压 |
| `adler32` | `Bytes` | `Int` | Adler-32 校验和 |
| `crc32` | `Bytes` | `UInt` | CRC-32 校验和 |

## 四平台输出

| 平台 | 输出格式 | FFI 机制 | 编译器 |
|------|----------|----------|--------|
| iOS | `.dylib` / `.xcframework` | Swift C interop | xcrun clang |
| Android | `.so` | JNI | NDK clang |
| Windows | `.dll` | DllImport | clang-cl |
| 鸿蒙 | `.so` | NAPI + ArkTS | OHOS clang |

## 许可证

mizchi/zlib 使用 Apache-2.0 许可证，Moon Cross 使用 MIT 许可证。
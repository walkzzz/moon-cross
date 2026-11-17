# zlib-cross

将纯 MoonBit 实现的 [mizchi/zlib](https://mooncakes.io/docs/mizchi/zlib)（压缩/解压/校验和）通过 moon-cross 导出为跨平台原生静态库的完整示例。

> 注：mizchi/zlib 已归档（API 冻结于 0.4.12），新项目建议使用 moonbitlang/core 的 flate/zlib/gzip。本示例演示"把 mooncakes 上的第三方库导出为原生库"的完整流程。

## 导出函数（C 符号前缀 `mz_`）

| MoonBit 函数 | C 符号 | 说明 |
|---|---|---|
| `zlib_compress_data` | `mz_zlib_compress` | zlib 压缩（fixed Huffman） |
| `zlib_decompress_data` | `mz_zlib_decompress` | zlib 解压（失败返回空 Bytes） |
| `deflate_compress_data` | `mz_deflate_compress` | raw deflate 压缩 |
| `deflate_decompress_data` | `mz_deflate_decompress` | raw deflate 解压 |
| `gzip_compress_data` | `mz_gzip_compress` | gzip 压缩（stored blocks） |
| `gzip_decompress_data` | `mz_gzip_decompress` | gzip 解压 |
| `adler32_sum` | `mz_adler32` | Adler-32 校验和 |
| `crc32_sum` | `mz_crc32` | CRC-32 校验和 |
| `zlib_can_decompress` | `mz_zlib_can_decompress` | 是否为可解压 zlib 流 |

## 三步复现

```bash
# 1. 构建为 native 静态库
cd examples/zlib-cross
moon build --target native --release
# 产物：_build/native/release/build/src/src.a（Linux/macOS）或 src.lib（Windows）

# 2. 生成五平台 FFI 绑定
moon-cross build --config moon-cross.json --platform all --output moon-cross-output

# 3. Linux 上端到端验证（生成→编译→C 调用→断言）
../../scripts/e2e_linux.sh
```

## C 宿主调用示例

```c
#include "moonbit.h"
#include <stdio.h>
extern int32_t mz_adler32(uint8_t *data);
extern int32_t mz_crc32(uint8_t *data);

int main(void) {
  moonbit_init();
  uint8_t payload[] = "hello";
  printf("adler32=%d crc32=%d\n", mz_adler32(payload), mz_crc32(payload));
  return 0;
}
```

## 运行测试

```bash
moon test --target native
```

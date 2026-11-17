# parser-cross

将 [moonbitlang/parser](https://mooncakes.io/docs/moonbitlang/parser)（MoonBit 语言解析器，AST/词法/语法）通过 moon-cross 导出的示例。

> 注：moonbitlang/parser 官方声明 "highly experimental and unstable"，本示例锁定 0.4.9 版本。

## 导出函数（C 符号前缀 `pr_`）

| MoonBit 函数 | C 符号 | 说明 |
|---|---|---|
| `parse_impl_count` | `pr_parse_impl_count` | 顶层声明数量 |
| `parse_report_count` | `pr_parse_report_count` | 解析诊断数量 |
| `parse_ok` | `pr_parse_ok` | 是否零诊断（干净解析） |
| `parse_first_top_kind` | `pr_parse_first_top_kind` | 第一个顶层声明的 AST kind |
| `parse_total_count` | `pr_parse_total_count` | 多源片段声明总数 |

## 三步复现

```bash
# 1. 构建为 native 静态库
cd examples/parser-cross
moon build --target native --release

# 2. 生成五平台 FFI 绑定
moon-cross build --config moon-cross.json --platform all --output moon-cross-output

# 3. 运行测试
moon test --target native
```

## C 宿主调用示例

```c
#include "moonbit.h"
#include <stdio.h>
extern int32_t pr_parse_impl_count(const char *source);
extern int32_t pr_parse_ok(const char *source);

int main(void) {
  moonbit_init();
  const char *src = "fn add(a: Int, b: Int) -> Int { a + b }";
  printf("decls=%d ok=%d\n", pr_parse_impl_count(src), pr_parse_ok(src));
  return 0;
}
```

> String 参数跨 FFI 传递需经 UTF-8 转换层，上例为示意。

## 运行测试

```bash
moon test --target native
```

# quickcheck-cross

将 [moonbitlang/quickcheck](https://mooncakes.io/docs/moonbitlang/quickcheck)（属性测试框架）通过 moon-cross 导出的示例。

## 为什么是"固定性质"包装

QuickCheck 的核心 API（`quick_check_fn`/`Arbitrary`/`Testable`）面向泛型与 trait 抽象，无法直接跨 FFI 导出。本示例展示另一种集成模式：**把若干"固定性质 + 固定种子"的属性检查包装为 C 可调用入口**，调用方拿到 QuickCheck 驱动器的报告字符串（如 `+++ [100/0/100] Ok, passed!`）。

## 导出函数（C 符号前缀 `qc_`）

| MoonBit 函数 | C 符号 | 说明 |
|---|---|---|
| `run_add_commutative` | `qc_run_add_commutative` | 加法交换律检查报告 |
| `run_reverse_twice` | `qc_run_reverse_twice` | 列表反转两次恢复原状检查报告 |
| `run_distributive` | `qc_run_distributive` | 乘法分配律检查报告 |

## 三步复现

```bash
# 1. 构建为 native 静态库
cd examples/quickcheck-cross
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
extern void qc_run_add_commutative(uint8_t *out);

int main(void) {
  moonbit_init();
  /* 报告字符串经 FFI Bytes 返回，此处示意调用 */
  return 0;
}
```

## 运行测试

```bash
moon test --target native
```

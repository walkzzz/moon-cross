# toml-cross

将 [moonbit-community/toml](https://mooncakes.io/docs/moonbit-community/toml)（TOML 1.1 解析器，toml-test 合规 98.8%）通过 moon-cross 导出为跨平台原生静态库的完整示例。

## 导出函数（C 符号前缀 `mt_`）

| MoonBit 函数 | C 符号 | 说明 |
|---|---|---|
| `toml_format` | `mt_toml_format` | 解析并重排 TOML 文档（失败返回空串） |
| `toml_validate` | `mt_toml_validate` | 判断输入是否为合法 TOML 文档 |
| `toml_root_type` | `mt_toml_root_type` | 根节点类型名（如 `TomlTable`） |
| `toml_top_keys` | `mt_toml_top_keys` | 顶层键数量（失败返回 -1） |

## 三步复现

```bash
# 1. 构建为 native 静态库
cd examples/toml-cross
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
extern int32_t mt_toml_validate(const char *input);
extern int32_t mt_toml_top_keys(const char *input);

int main(void) {
  moonbit_init();
  printf("valid=%d keys=%d\n",
         mt_toml_validate("a = 1\n"),
         mt_toml_top_keys("a = 1\nb = 2\n"));
  return 0;
}
```

> String 参数跨 FFI 传递需经 UTF-8 转换层（见 moon-cross 文档的类型映射章节），上例为示意。

## 运行测试

```bash
moon test --target native
```

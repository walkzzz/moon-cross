# 阶段 0 Spike 结论（2026-11-17，工具链 moon 0.1.20261104 / moonc v0.10.20）

## Spike 1：命令行参数（argv）✅

- `import "moonbitlang/core/env"` → `@env.args()` 返回 `[程序路径, 用户参数...]`，取 `[1:]` 为真实参数
- `core/argparse` 提供完整 CLI 解析（Command/FlagArg/OptionArg/subcommands/Matches），CLI 重构优先用它

## Spike 2：文件系统与 JSON ✅

- `import "moonbitlang/core/async/fs"`（async 包标记 experimental，需在 moon.pkg 声明 `options("allow-experimental-packages": [...])`）
- 高层一行式 API：`@fs.write_text(path, content)` / `@fs.read_text(path)` / `@fs.read_binary` / `@fs.readdir(path, sort~)` / `@fs.create` / `@fs.open(mode~)`
- async 入口：`async fn main`，需 `import "moonbitlang/core/async"`；native 与 wasm 后端完整支持
- 同步 fs API 不存在；子进程用 `core/async/process`（doctor 命令不需要 C stub）

## Spike 3：库产物与 FFI 导出 ✅（技术路线修订）

- `pkgtype(kind: "foreign_library")` + 函数前 `#export_name("sym")`（pub 非泛型、无可选参数）
- `moon build --target native --release` → **静态库** `_build/native/release/build/<pkg>/src.lib`（Windows）/ `.a`（Unix）
- 已实测：src.lib 内含 `my_add`/`my_lib_init`/`moonbit_init` 符号（grep -a 验证）
- 宿主 C 调用规范（官方）：

```c
#include "moonbit.h"
extern int32_t my_add(int32_t a, int32_t b);
int main(void) {
  moonbit_init();          // 必须先初始化运行时
  int r = my_add(40, 2);
}
```

- 链接：Linux `cc -I $MOON_HOME/include host.c lib.a -lm -o host`（release 归档）；Windows `cl /Fe:host.exe -I %MOON_HOME%\include host.c src.lib /link /LIBPATH:%MOON_HOME%\lib`（需 MSVC/vcvars 环境；本机 git-bash 缺 vcvars，宿主链接验证放 CI/Linux）
- 共享库 .so/.dll/.framework 由外层 C 编译器封装（`-shared -fPIC` + 静态库 + 适配层）

## 技术路线修订（相对申报书）

- native 后端仍生成 C 中间源（文档确认 "moonc-generated C source files"），但由 moon 内部消费，不对外暴露提取接口；手动 `moonc link-core` 会触发 ICE
- moon-cross 的交付形态修订为：**静态库（.a/.lib）+ 自动生成的 C 适配层 + 平台封装构建脚本（gcc -shared → .so 等）+ 各平台 FFI 绑定代码**
- String 无稳定 C ABI（文档），FFI 导出以 Int/Double/Bool/Bytes 为主，String 走 Bytes+UTF-8 转换层

## moon.pkg 新语法要点（MoonBit DSL，moon.pkg.json 已不被接受）

```moonbit
import {
  "moonbitlang/core/env",
  "walkzzz/moon-cross/core/core" @core,   // @alias
} for "test"                               // 条件导入块

options(
  "allow-experimental-packages": ["moonbitlang/core/async"],
  targets: { "ffi.mbt": ["native"] },      // 文件级后端条件
)

pkgtype(kind: "executable")   // 或 "foreign_library" / "library"(默认)

#cfg(target = "native")
import { "example/native_impl" @platform }   // 后端条件导入
```

- `supported_targets = "native"`（包级支持声明）；moon.mod 用 `preferred_target = "native"`
- derive 废弃警告 = #27 deprecated_syntax：`} derive(Debug, Eq)` → `#derive(Debug, Eq)` 置于类型声明前

# moon-cross 评审意见

> 评审对象：`walkzzz/moon-cross` v0.3.30（80 包 / 2289 测试 / 85 commits / 单人开发）
> 评审视角：架构合理性、代码实质深度、与 moon-geo 的协同可能性
> 评审日期：2026-10-26

---

## 一、它是什么

moon-cross 定位为 **MoonBit 跨平台原生框架**：将 MoonBit 代码编译到 iOS / Android / Windows / HarmonyOS / Linux 五个平台的原生库，并自动生成对应的 FFI 绑定（JNI / Swift interop / NAPI）。

架构分层清晰：

```
core（Platform/Arch/TargetTriple）
  ← config（moon-cross.json 配置）+ typesys（MoonBit→C 类型映射）
    ← codegen/c（C 适配层）+ platform/*（五平台交叉编译）+ ffi/*（三绑定生成）
      ← scaffold（脚手架）+ sync（增量同步）
        ← cli
```

外加横切层：`testing/`（proof/mock/e2e/ai_test/mutate/crap/refactoring）、`analysis/`（benchmark/coverage/dependency/graph/perf/profiler/trace/watcher/diff/discovery/diagnostic）、`runtime/`（13 个通用运行时包）、`security/`（11 个安全/工具包）、`patterns/`（10 个设计模式）。

---

## 二、做得好的地方

### 1. 分层架构与依赖方向

`docs/architecture.md` 明确定义了包结构和依赖层次，禁止平铺。10 个一级分类（core/testing/platform/codegen/integration/tools/runtime/analysis/patterns/security）划分合理，依赖方向单一向上。这在 MoonBit 生态中是少见的工程规范。

### 2. 平台覆盖面

五平台（含鸿蒙 OHOS）是亮点。大多数跨平台工具止步于 iOS+Android，moon-cross 把鸿蒙 NAPI 和 Linux 都纳入了。target triple 生成（`arm64-apple-ios`、`aarch64-linux-android24`、`aarch64-linux-ohos`）是正确的工程决策。

### 3. 质量基础设施投入

CRAP 指标、变异测试、trait 覆盖率、0 warning 治理——作者对代码质量有自觉追求。roadmap 中每个版本的测试数、包数、warning 数都有记录，可追溯。

### 4. 中英双文注释

每个 `pub fn` 都有 `///` 注释且中英双语，符合 R3 规范。这在早期项目中对社区友好。

---

## 三、核心问题

### P0 — codegen 实质深度不足，是骨架生成器而非代码生成器

这是最关键的问题。moon-cross 的核心卖点是"代码生成引擎"，但实际生成能力停留在**字符串拼接产出骨架**的阶段：

```moonbit
// codegen/codegen/c/wrapper.mbt — 全部 24 行
pub fn generate_header(module_name : String) -> String {
  "#ifndef " + module_name + "_H\n#define " + module_name +
  "_H\n\n#include <stdint.h>\n#include \"moonbit.h\"\n\n#endif\n"
}
```

这个函数生成一个 6 行的空头文件——没有函数声明、没有类型映射、没有导出列表。对比一个真正的 FFI 代码生成器需要做的事：

- 读取 MoonBit 导出函数签名（参数类型、返回类型）
- 按类型映射规则生成 C 函数原型
- 生成 marshalling 代码（MoonBit string ↔ C char*、MoonBit array ↔ C pointer+length）
- 生成生命周期管理代码（谁负责释放、GC barrier）
- 生成平台特定的绑定（JNI 的 `GetByteArrayElements` / Swift 的 `withUnsafeBytes` / NAPI 的 `napi_create_function`）

目前 `ffi/jni/generate.mbt`（107 行）生成的是 `Java_pkg_Class_function` 命名和 `System.loadLibrary("xxx")` 这类**模板字符串**，不涉及任何实际的 MoonBit 类型 → JNI 类型转换。

**结论**：当前 codegen 能产出项目脚手架（CMakeLists.txt 骨架、Gradle 配置块、Kotlin class 骨架），但不能为一个真实的 MoonBit 库自动生成可编译的 FFI 绑定代码。这是"脚手架工具"而非"代码生成器"的差距。

### P1 — CLI 只有 help 文本，没有命令分发

```moonbit
// tools/cli/main.mbt — 全部 47 行
fn main {
  println("Moon Cross v0.2.22 - MoonBit Cross-Platform Native Framework")
  println("Usage: moon-cross <command> [options]")
  println("  build    - Build for target platforms")
  println("  check    - Validate configuration")
  // ... 只打印 help，不解析参数、不分发命令
}
```

`build / check / plan / init / sync / doctor / publish / wizard` 八个命令全部只存在于 help 文本中。没有参数解析、没有命令分发、没有文件系统操作。作为一个 CLI 工具，目前不可执行任何实际功能。

### P2 — 平台模块生成命令字符串，但不执行

```moonbit
// platform/platform/ohos/compile.mbt
pub fn ohos_compile_command(config : OhosCompileConfig) -> String {
  config.sdk_path + "/clang --target=" + target + " -o " + ...
}
```

每个平台模块生成交叉编译命令字符串，但没有调用 `@fs` / `@process` 执行它，没有错误处理，没有输出捕获。这是"命令模板"而非"编译器驱动"。

### P3 — 2289 测试的含金量需要打折

大量测试的形式是：

```moonbit
test "generate_header_contains_ifndef" {
  let h = @c.generate_header("mylib")
  assert_true(h.contains("#ifndef mylib_H"))
}
```

这是在测试**硬编码字符串是否包含子串**——测试通过等于"字符串拼接没写错"，不等于"生成的代码能编译"或"FFI 绑定能工作"。真正的集成测试应该是：生成代码 → 调用真实工具链编译 → 加载产物 → 调用函数 → 验证结果。目前 `integration/` 只有 pinyin 一个集成，且也是纯 MoonBit 层面的调用测试，不涉及跨平台编译产物。

### P4 — 严重的作用域蔓延（scope creep）

从 v0.2.0 起，roadmap 几乎全部在添加**与跨平台编译无关的通用工具包**：

| 版本区间 | 新增内容 | 与跨平台编译的关系 |
|---------|---------|-------------------|
| v0.2.0–v0.2.1 | formatter + coverage | 间接（项目自身工具） |
| v0.2.11–v0.2.14 | LRU 缓存 + 对象池 + 事件系统 + 状态机 | **无关** |
| v0.2.16–v0.2.19 | 信号处理 + 定时器 + 日志 + 资源管理 | **无关** |
| v0.2.21–v0.2.23 | 命令行解析 + HTTP 协议 + URI 解析 | **无关** |
| v0.2.25–v0.2.29 | 模板引擎 + 正则增强 + 加密工具 + 并发原语 + 内存管理 | **无关** |
| v0.3.0 | compress + algorithm + stream + 12 设计模式 | **无关** |

`runtime/`（13 包）和 `security/`（11 包）本质上是在**用 MoonBit 重写一个标准库**。这不是跨平台框架的职责。如果 MoonBit 标准库缺少这些功能，正确的做法是贡献到 `moonbitlang/core` 或单独发布 `moon-stdlib`，而不是塞进 `moon-cross`。

**后果**：80 个包中，与"跨平台原生编译"直接相关的约 15 个（core + config + typesys + codegen + platform×5 + ffi×3 + scaffold + sync + cli），其余 65 个（81%）是通用工具。用户来看"MoonBit 跨平台框架"，看到的是一半标准库 + 一半设计模式教学 + 一小部分跨平台骨架。

### P5 — 形式化证明框架是运行时断言，非真形式化验证

```moonbit
// testing/proof/proof.mbt
pub fn contract_verify(contract : Contract, pre_holds : Bool, post_holds : Bool) -> ProofResult {
  if pre_holds && post_holds { ... holds: true ... }
}
```

这是运行时布尔检查，等价于 `assert(pre && post)`。MoonBit 的 `moon prove` 是基于 Lean 的真形式化验证。将这个框架称为"形式化证明"会误导使用者。它是一个契约测试框架（类似 PyContract / JML 的运行时检查子集），有价值但名不副实。

---

## 四、与 moon-geo 的协同评估

moon-geo 的 FFI 绑定架构（`core/` + `ffi/` + `api/`）需要一个跨平台构建层来：生成 C wrapper、生成各平台 FFI 绑定、管理交叉编译工具链。**理论上 moon-cross 正好填补这个位置**。

但以 moon-cross 当前的实质深度：

| 需求 | moon-cross 现状 | 差距 |
|------|----------------|------|
| 读取 MoonBit 导出函数列表 | `discovery/` 包存在但未读其实现 | 需验证能否解析真实 `.mbt` 导出 |
| MoonBit 类型 → C 类型映射 | `typesys/` 支持 6 种基本类型 | 缺少结构体字段映射、嵌套类型、回调函数类型 |
| 生成 C wrapper 函数体 | 只生成头文件 `#ifndef` 骨架 | **完全缺失** marshalling 代码生成 |
| 生成 JNI 绑定函数体 | 生成函数名和声明骨架 | **完全缺失** `GetByteArrayElements` 等调用序列 |
| 驱动交叉编译 | 生成命令字符串 | 不执行、不捕获错误、不管理工具链版本 |
| 打包产物（.so / .xcframework / .aar） | iOS 有 XCFramework 命名生成 | 未验证是否真正调用 `xcodebuild` |

**结论**：moon-cross 目前不能直接作为 moon-geo FFI 架构的构建层。它的架构方向正确，但实现深度差一个数量级。如果要用，需要先补齐 codegen 的实质生成能力（P0），这本身可能比 moon-geo 的 FFI 绑定工作量还大。

**建议**：短期内 moon-geo 的 FFI 构建用 CMake / Makefile 手写 + CI 脚本更实际。等 moon-cross 的 codegen 达到能生成真实 marshalling 代码的程度，再考虑集成。

---

## 五、改进建议（按优先级）

### 1. 停止添加通用工具包，回到核心使命

`runtime/`、`security/`（大部分）、`patterns/` 应该拆分成独立仓库（如 `moon-stdlib`、`moon-patterns`）或贡献到 MoonBit 标准库。moon-cross 的包数应该收缩到 ~20 个，全部围绕跨平台编译。

### 2. 让 codegen 生成真实可编译的代码

最小可行验证：写一个包含 `pub fn add(a: Int, b: Int) -> Int` 的 MoonBit 库，用 moon-cross 生成 C wrapper + JNI 绑定，在 Android 上编译加载调用，得到正确结果。如果能做到这一步，codegen 就从"骨架生成器"升级为"代码生成器"。目前 `integration/pinyin_integration` 是最接近的，但它是 MoonBit 层面的调用，不涉及跨平台产物验证。

### 3. 实现 CLI 命令分发

至少实现 `moon-cross init`（生成脚手架）和 `moon-cross build --platform android`（调用 codegen + 平台编译命令）。不需要全部八个命令，但至少一个能端到端跑通。

### 4. 集成测试要验证编译产物

将测试从"字符串包含子串"升级为"生成代码 → 编译 → 加载 → 调用 → 验证"。哪怕只覆盖一个平台（如 Linux）一个函数（如 `add`），也比 2289 个字符串断言有说服力。

### 5. 诚实命名

`testing/proof` 改为 `testing/contract`（契约测试）；roadmap 中"形式化证明"改为"契约检查"。保留 `moon prove` 这个名字给真正的 Lean 验证用。

---

## 六、总体评价

moon-cross 有**正确的架构方向**和**出色的工程规范**（分层、注释、CI、质量指标），但存在**严重的深度-广度失衡**：80 个包中 81% 是通用工具，核心跨平台编译能力停留在骨架生成阶段。开发节奏是"每周加两个包"而非"让核心功能真正可用"。

如果作者的目标是参加比赛（roadmap 中多次提到"参赛"），当前形态作为"展示 MoonBit 工程能力"的作品是合格的——80 包 / 2289 测试 / 20 trait / 0 warning 确实体现了工程素养。但如果目标是做一个**被其他项目（如 moon-geo）依赖的跨平台构建工具**，需要把精力从"扩包"转向"加深 codegen"，从"生成字符串"转向"生成可编译的代码"。

**一句话**：架构是 80 分的，核心实现是 20 分的，包数是 200 分的。把多出来的 120 分精力挪到核心上，这个项目才有未来。

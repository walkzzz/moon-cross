# Contributing to Moon Cross

感谢你对 Moon Cross 的关注！本文档描述了如何为项目贡献代码。

## 开发环境

- MoonBit 工具链：moon 0.1.20260920+
- Git
- 操作系统：Windows / macOS / Linux

## 快速开始

```bash
# 克隆仓库
git clone git@github.com:walkzzz/moon-cross.git
cd moon-cross

# 验证构建
moon check
moon test
```

## 项目结构

```
src/
├── core/          # 核心类型（Platform, Arch, TargetTriple, Error）
├── config/        # 配置解析
├── typesys/       # 类型映射
├── codegen/       # C 代码生成
├── platform/      # 四平台编译配置
├── ffi/           # FFI 绑定生成
├── robust/        # 鲁棒性（重试+恢复+校验+边界）
├── security/      # 安全性（ASAN+FFI安全+沙箱+供应链）
├── perf/          # 性能（并行+缓存+增量+优化）
├── docs/          # API 文档生成
├── plugin/        # 插件机制 + 模板库
├── integration/   # 集成测试
├── scaffold/      # 项目脚手架
├── sync/          # 增量同步
└── cli/           # CLI 入口
```

## 编码规范

- **注释格式**：中英双文 `/// 中文 | English`
- **Warning 清零**：所有代码必须通过 `moon check` 且 0 warning
- **测试覆盖**：每个公开函数必须有对应测试
- **命名约定**：snake_case for functions, PascalCase for types

## 提交规范

```bash
git commit -m "vX.Y.Z: 简要描述

- 变更点 1
- 变更点 2

N tests passed, 0 warnings"
```

## 添加新平台

1. 在 `src/platform/` 下创建新平台目录
2. 实现 `CompileConfig` 和 `compile_command`
3. 在 `src/core/types.mbt` 的 `Platform` enum 中添加新平台
4. 更新 `all_platforms()` 函数
5. 编写测试

## 添加新 FFI 绑定

1. 在 `src/ffi/` 下创建新绑定目录
2. 实现绑定生成函数
3. 更新 `ffi_binding_for_platform()`
4. 编写测试

## 添加插件

1. 使用 `src/plugin/` 包的 `PluginInfo` 和 `PluginEntry`
2. 注册支持的钩子（PreCompile, PostCompile 等）
3. 实现钩子回调逻辑

## 发布流程

1. 更新 `moon.mod` 版本号
2. 更新 `docs/changelog.md`
3. 更新 `README.md` 和 `README.en.md`
4. 运行 `moon check && moon test`
5. `git commit && git push`
6. 创建 Git tag：`git tag vX.Y.Z && git push --tags`

## License

MIT License — 贡献的代码将同样以 MIT 许可证发布。
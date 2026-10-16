///|
/// moonbitlang/quickcheck 模块名 | moonbitlang/quickcheck module name
pub fn quickcheck_module_name() -> String {
  "moonbitlang_quickcheck"
}

///|
/// moonbitlang/quickcheck 版本 | moonbitlang/quickcheck version
pub fn quickcheck_version() -> String {
  "0.15.0"
}

///|
/// quickcheck 导出函数列表（基于 moonbitlang/quickcheck v0.15.0 公开 API） | quickcheck export function list (based on moonbitlang/quickcheck v0.15.0 public API)
pub fn quickcheck_export_functions() -> Array[@config.ExportFunction] {
  [
    {
      name: "quickcheck_check",
      params: [
        { name: "property", typ: "Property" },
        { name: "iterations", typ: "Int" },
      ],
      return_type: "QuickCheckResult",
    },
    {
      name: "quickcheck_for_all_int",
      params: [{ name: "property", typ: "Property" }],
      return_type: "QuickCheckResult",
    },
    {
      name: "quickcheck_for_all_bool",
      params: [{ name: "property", typ: "Property" }],
      return_type: "QuickCheckResult",
    },
    {
      name: "quickcheck_for_all_string",
      params: [{ name: "property", typ: "Property" }],
      return_type: "QuickCheckResult",
    },
    {
      name: "quickcheck_arbitrary_int",
      params: [{ name: "seed", typ: "UInt" }],
      return_type: "Int",
    },
    {
      name: "quickcheck_arbitrary_bool",
      params: [{ name: "seed", typ: "UInt" }],
      return_type: "Bool",
    },
    {
      name: "quickcheck_arbitrary_string",
      params: [
        { name: "seed", typ: "UInt" },
        { name: "max_len", typ: "Int" },
      ],
      return_type: "String",
    },
    {
      name: "quickcheck_with_seed",
      params: [
        { name: "property", typ: "Property" },
        { name: "seed", typ: "UInt" },
        { name: "iterations", typ: "Int" },
      ],
      return_type: "QuickCheckResult",
    },
    {
      name: "quickcheck_minimize",
      params: [
        { name: "result", typ: "QuickCheckResult" },
        { name: "property", typ: "Property" },
      ],
      return_type: "QuickCheckResult",
    },
    {
      name: "quickcheck_result_passed",
      params: [{ name: "result", typ: "QuickCheckResult" }],
      return_type: "Bool",
    },
  ]
}

///|
/// quickcheck 导出类型 | quickcheck export types
pub fn quickcheck_export_types() -> Array[@config.ExportType] {
  [
    {
      name: "Property",
      fields: [
        { name: "name", typ: "String" },
        { name: "iterations", typ: "Int" },
      ],
    },
    {
      name: "Arbitrary",
      fields: [
        { name: "seed", typ: "UInt" },
        { name: "size", typ: "Int" },
      ],
    },
    {
      name: "QuickCheckResult",
      fields: [
        { name: "passed", typ: "Bool" },
        { name: "iterations", typ: "Int" },
        { name: "counterexample", typ: "String" },
      ],
    },
    {
      name: "QuickCheckError",
      fields: [
        { name: "NoCounterexample", typ: "String" },
        { name: "PropertyFailed", typ: "String" },
        { name: "GenerationError", typ: "String" },
      ],
    },
  ]
}

///|
/// 为 moonbitlang/quickcheck 生成完整的跨平台配置 | Generate complete cross-platform config for moonbitlang/quickcheck
pub fn quickcheck_cross_config() -> @config.CrossConfig {
  {
    version: 1,
    module_path: "moonbitlang/quickcheck",
    package_name: "moonbitlang/quickcheck",
    targets: @core.all_platforms(),
    functions: quickcheck_export_functions(),
    types: quickcheck_export_types(),
  }
}

///|
/// quickcheck 导出函数数量 | quickcheck export function count
pub fn quickcheck_function_count() -> Int {
  quickcheck_export_functions().length()
}

///|
/// quickcheck 导出类型数量 | quickcheck export type count
pub fn quickcheck_type_count() -> Int {
  quickcheck_export_types().length()
}

///|
/// quickcheck 目标平台数量 | quickcheck target platform count
pub fn quickcheck_target_count() -> Int {
  quickcheck_cross_config().targets.length()
}
///|
/// bobzhang/toml 模块名 | bobzhang/toml module name
pub fn toml_module_name() -> String {
  "bobzhang_toml"
}

///|
/// bobzhang/toml 版本 | bobzhang/toml version
pub fn toml_version() -> String {
  "0.4.3"
}

///|
/// toml 导出函数列表（基于 bobzhang/toml v0.4.3 公开 API） | toml export function list (based on bobzhang/toml v0.4.3 public API)
pub fn toml_export_functions() -> Array[@config.ExportFunction] {
  [
    {
      name: "toml_parse",
      params: [{ name: "input", typ: "String" }],
      return_type: "TomlValue",
    },
    {
      name: "toml_to_string",
      params: [{ name: "value", typ: "TomlValue" }],
      return_type: "String",
    },
    {
      name: "toml_get",
      params: [
        { name: "table", typ: "TomlValue" },
        { name: "key", typ: "String" },
      ],
      return_type: "TomlValue",
    },
    {
      name: "toml_get_string",
      params: [
        { name: "table", typ: "TomlValue" },
        { name: "key", typ: "String" },
      ],
      return_type: "String",
    },
    {
      name: "toml_get_int",
      params: [
        { name: "table", typ: "TomlValue" },
        { name: "key", typ: "String" },
      ],
      return_type: "Int",
    },
    {
      name: "toml_get_double",
      params: [
        { name: "table", typ: "TomlValue" },
        { name: "key", typ: "String" },
      ],
      return_type: "Double",
    },
    {
      name: "toml_get_bool",
      params: [
        { name: "table", typ: "TomlValue" },
        { name: "key", typ: "String" },
      ],
      return_type: "Bool",
    },
    {
      name: "toml_value_type",
      params: [{ name: "value", typ: "TomlValue" }],
      return_type: "String",
    },
    {
      name: "toml_table_keys",
      params: [{ name: "table", typ: "TomlValue" }],
      return_type: "Array",
    },
    {
      name: "toml_array_length",
      params: [{ name: "array", typ: "TomlValue" }],
      return_type: "Int",
    },
  ]
}

///|
/// toml 导出类型 | toml export types
pub fn toml_export_types() -> Array[@config.ExportType] {
  [
    {
      name: "TomlValue",
      fields: [
        { name: "Table", typ: "Unit" },
        { name: "Array", typ: "Unit" },
        { name: "String", typ: "Unit" },
        { name: "Int", typ: "Unit" },
        { name: "Double", typ: "Unit" },
        { name: "Bool", typ: "Unit" },
        { name: "Datetime", typ: "Unit" },
        { name: "Null", typ: "Unit" },
      ],
    },
    {
      name: "TomlError",
      fields: [
        { name: "ParseError", typ: "String" },
        { name: "TypeError", typ: "String" },
        { name: "KeyError", typ: "String" },
      ],
    },
  ]
}

///|
/// 为 bobzhang/toml 生成完整的跨平台配置 | Generate complete cross-platform config for bobzhang/toml
pub fn toml_cross_config() -> @config.CrossConfig {
  {
    version: 1,
    module_path: "bobzhang/toml",
    package_name: "bobzhang/toml",
    targets: @core.all_platforms(),
    functions: toml_export_functions(),
    types: toml_export_types(),
  }
}

///|
/// toml 导出函数数量 | toml export function count
pub fn toml_function_count() -> Int {
  toml_export_functions().length()
}

///|
/// toml 导出类型数量 | toml export type count
pub fn toml_type_count() -> Int {
  toml_export_types().length()
}

///|
/// toml 目标平台数量 | toml target platform count
pub fn toml_target_count() -> Int {
  toml_cross_config().targets.length()
}
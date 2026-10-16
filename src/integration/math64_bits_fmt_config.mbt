///|
/// math64 模块名 | math64 module name
pub fn math64_module_name() -> String {
  "moonbitlang_math64"
}

///|
/// math64 版本 | math64 version
pub fn math64_version() -> String {
  "0.1.0"
}

///|
/// math64 导出函数列表 | math64 export function list
pub fn math64_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "math64_add", params: [{ name: "a", typ: "Int64" }, { name: "b", typ: "Int64" }], return_type: "Int64" },
    { name: "math64_sub", params: [{ name: "a", typ: "Int64" }, { name: "b", typ: "Int64" }], return_type: "Int64" },
    { name: "math64_mul", params: [{ name: "a", typ: "Int64" }, { name: "b", typ: "Int64" }], return_type: "Int64" },
    { name: "math64_div", params: [{ name: "a", typ: "Int64" }, { name: "b", typ: "Int64" }], return_type: "Int64" },
    { name: "math64_mod", params: [{ name: "a", typ: "Int64" }, { name: "b", typ: "Int64" }], return_type: "Int64" },
    { name: "math64_compare", params: [{ name: "a", typ: "Int64" }, { name: "b", typ: "Int64" }], return_type: "Int" },
  ]
}

///|
/// math64 导出类型 | math64 export types
pub fn math64_export_types() -> Array[@config.ExportType] {
  [
    { name: "Int64", fields: [{ name: "hi", typ: "Int" }, { name: "lo", typ: "Int" }] },
  ]
}

///|
/// math64 跨平台配置 | math64 cross-platform config
pub fn math64_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/math64", package_name: "moonbitlang/math64", targets: @core.all_platforms(), functions: math64_export_functions(), types: math64_export_types() }
}

///|
/// bits 模块名 | bits module name
pub fn bits_module_name() -> String {
  "moonbitlang_bits"
}

///|
/// bits 版本 | bits version
pub fn bits_version() -> String {
  "0.1.0"
}

///|
/// bits 导出函数列表 | bits export function list
pub fn bits_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "bits_and", params: [{ name: "a", typ: "Int" }, { name: "b", typ: "Int" }], return_type: "Int" },
    { name: "bits_or", params: [{ name: "a", typ: "Int" }, { name: "b", typ: "Int" }], return_type: "Int" },
    { name: "bits_xor", params: [{ name: "a", typ: "Int" }, { name: "b", typ: "Int" }], return_type: "Int" },
    { name: "bits_not", params: [{ name: "a", typ: "Int" }], return_type: "Int" },
    { name: "bits_shift_left", params: [{ name: "a", typ: "Int" }, { name: "n", typ: "Int" }], return_type: "Int" },
    { name: "bits_shift_right", params: [{ name: "a", typ: "Int" }, { name: "n", typ: "Int" }], return_type: "Int" },
  ]
}

///|
/// bits 导出类型 | bits export types
pub fn bits_export_types() -> Array[@config.ExportType] {
  [
    { name: "BitField", fields: [{ name: "value", typ: "Int" }, { name: "width", typ: "Int" }] },
  ]
}

///|
/// bits 跨平台配置 | bits cross-platform config
pub fn bits_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/bits", package_name: "moonbitlang/bits", targets: @core.all_platforms(), functions: bits_export_functions(), types: bits_export_types() }
}

///|
/// fmt 模块名 | fmt module name
pub fn fmt_module_name() -> String {
  "moonbitlang_fmt"
}

///|
/// fmt 版本 | fmt version
pub fn fmt_version() -> String {
  "0.1.0"
}

///|
/// fmt 导出函数列表 | fmt export function list
pub fn fmt_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "fmt_int", params: [{ name: "value", typ: "Int" }, { name: "spec", typ: "FormatSpec" }], return_type: "String" },
    { name: "fmt_float", params: [{ name: "value", typ: "Float" }, { name: "spec", typ: "FormatSpec" }], return_type: "String" },
    { name: "fmt_string", params: [{ name: "value", typ: "String" }, { name: "spec", typ: "FormatSpec" }], return_type: "String" },
    { name: "fmt_bool", params: [{ name: "value", typ: "Bool" }], return_type: "String" },
    { name: "fmt_array", params: [{ name: "arr", typ: "Array" }, { name: "sep", typ: "String" }], return_type: "String" },
  ]
}

///|
/// fmt 导出类型 | fmt export types
pub fn fmt_export_types() -> Array[@config.ExportType] {
  [
    { name: "FormatSpec", fields: [{ name: "width", typ: "Int" }, { name: "precision", typ: "Int" }, { name: "align", typ: "String" }] },
  ]
}

///|
/// fmt 跨平台配置 | fmt cross-platform config
pub fn fmt_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/fmt", package_name: "moonbitlang/fmt", targets: @core.all_platforms(), functions: fmt_export_functions(), types: fmt_export_types() }
}
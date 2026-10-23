///|
/// regexp 模块名 | regexp module name
pub fn regexp_module_name() -> String {
  "moonbitlang_regexp"
}

///|
/// regexp 版本 | regexp version
pub fn regexp_version() -> String {
  "0.1.0"
}

///|
/// regexp 导出函数列表 | regexp export function list
pub fn regexp_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "regexp_compile", params: [{ name: "pattern", typ: "String" }], return_type: "Regexp" },
    { name: "regexp_match", params: [{ name: "re", typ: "Regexp" }, { name: "input", typ: "String" }], return_type: "Bool" },
    { name: "regexp_replace", params: [{ name: "re", typ: "Regexp" }, { name: "input", typ: "String" }, { name: "replacement", typ: "String" }], return_type: "String" },
    { name: "regexp_split", params: [{ name: "re", typ: "Regexp" }, { name: "input", typ: "String" }], return_type: "Array" },
    { name: "regexp_find", params: [{ name: "re", typ: "Regexp" }, { name: "input", typ: "String" }], return_type: "String" },
  ]
}

///|
/// regexp 导出类型 | regexp export types
pub fn regexp_export_types() -> Array[@config.ExportType] {
  [
    { name: "Regexp", fields: [{ name: "pattern", typ: "String" }, { name: "flags", typ: "Int" }] },
    { name: "MatchResult", fields: [{ name: "matched", typ: "Bool" }, { name: "start", typ: "Int" }, { name: "end", typ: "Int" }] },
  ]
}

///|
/// regexp 跨平台配置 | regexp cross-platform config
pub fn regexp_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/regexp", package_name: "moonbitlang/regexp", targets: @core.all_platforms(), functions: regexp_export_functions(), types: regexp_export_types() }
}

///|
/// uuid 模块名 | uuid module name
pub fn uuid_module_name() -> String {
  "moonbitlang_uuid"
}

///|
/// uuid 版本 | uuid version
pub fn uuid_version() -> String {
  "0.1.0"
}

///|
/// uuid 导出函数列表 | uuid export function list
pub fn uuid_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "uuid_v4", params: [], return_type: "String" },
    { name: "uuid_v7", params: [{ name: "timestamp", typ: "Int" }], return_type: "String" },
    { name: "uuid_parse", params: [{ name: "input", typ: "String" }], return_type: "Uuid" },
    { name: "uuid_to_string", params: [{ name: "uuid", typ: "Uuid" }], return_type: "String" },
    { name: "uuid_validate", params: [{ name: "input", typ: "String" }], return_type: "Bool" },
  ]
}

///|
/// uuid 导出类型 | uuid export types
pub fn uuid_export_types() -> Array[@config.ExportType] {
  [
    { name: "Uuid", fields: [{ name: "version", typ: "Int" }, { name: "bytes", typ: "Bytes" }] },
  ]
}

///|
/// uuid 跨平台配置 | uuid cross-platform config
pub fn uuid_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/uuid", package_name: "moonbitlang/uuid", targets: @core.all_platforms(), functions: uuid_export_functions(), types: uuid_export_types() }
}

///|
/// bufio 模块名 | bufio module name
pub fn bufio_module_name() -> String {
  "moonbitlang_bufio"
}

///|
/// bufio 版本 | bufio version
pub fn bufio_version() -> String {
  "0.1.0"
}

///|
/// bufio 导出函数列表 | bufio export function list
pub fn bufio_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "bufio_new_buffer", params: [{ name: "capacity", typ: "Int" }], return_type: "Buffer" },
    { name: "bufio_write_string", params: [{ name: "buf", typ: "Buffer" }, { name: "data", typ: "String" }], return_type: "Unit" },
    { name: "bufio_read_line", params: [{ name: "buf", typ: "Buffer" }], return_type: "String" },
    { name: "bufio_flush", params: [{ name: "buf", typ: "Buffer" }], return_type: "Unit" },
    { name: "bufio_capacity", params: [{ name: "buf", typ: "Buffer" }], return_type: "Int" },
  ]
}

///|
/// bufio 导出类型 | bufio export types
pub fn bufio_export_types() -> Array[@config.ExportType] {
  [
    { name: "Buffer", fields: [{ name: "data", typ: "Bytes" }, { name: "len", typ: "Int" }, { name: "cap", typ: "Int" }] },
  ]
}

///|
/// bufio 跨平台配置 | bufio cross-platform config
pub fn bufio_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/bufio", package_name: "moonbitlang/bufio", targets: @core.all_platforms(), functions: bufio_export_functions(), types: bufio_export_types() }
}
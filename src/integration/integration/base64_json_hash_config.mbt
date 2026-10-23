///|
/// base64 模块名 | base64 module name
pub fn base64_module_name() -> String {
  "moonbitlang_base64"
}

///|
/// base64 版本 | base64 version
pub fn base64_version() -> String {
  "0.1.0"
}

///|
/// base64 导出函数列表 | base64 export function list
pub fn base64_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "base64_encode", params: [{ name: "data", typ: "Bytes" }], return_type: "String" },
    { name: "base64_decode", params: [{ name: "input", typ: "String" }], return_type: "Bytes" },
    { name: "base64_encode_urlsafe", params: [{ name: "data", typ: "Bytes" }], return_type: "String" },
    { name: "base64_decode_urlsafe", params: [{ name: "input", typ: "String" }], return_type: "Bytes" },
    { name: "base64_validate", params: [{ name: "input", typ: "String" }], return_type: "Bool" },
  ]
}

///|
/// base64 导出类型 | base64 export types
pub fn base64_export_types() -> Array[@config.ExportType] {
  []
}

///|
/// base64 跨平台配置 | base64 cross-platform config
pub fn base64_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/base64", package_name: "moonbitlang/base64", targets: @core.all_platforms(), functions: base64_export_functions(), types: base64_export_types() }
}

///|
/// json 模块名 | json module name
pub fn json_module_name() -> String {
  "moonbitlang_json"
}

///|
/// json 版本 | json version
pub fn json_version() -> String {
  "0.1.0"
}

///|
/// json 导出函数列表 | json export function list
pub fn json_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "json_parse", params: [{ name: "input", typ: "String" }], return_type: "JsonValue" },
    { name: "json_to_string", params: [{ name: "value", typ: "JsonValue" }], return_type: "String" },
    { name: "json_get", params: [{ name: "obj", typ: "JsonValue" }, { name: "key", typ: "String" }], return_type: "JsonValue" },
    { name: "json_get_array", params: [{ name: "obj", typ: "JsonValue" }, { name: "key", typ: "String" }], return_type: "Array" },
    { name: "json_value_type", params: [{ name: "value", typ: "JsonValue" }], return_type: "String" },
  ]
}

///|
/// json 导出类型 | json export types
pub fn json_export_types() -> Array[@config.ExportType] {
  [
    { name: "JsonValue", fields: [{ name: "Null", typ: "Unit" }, { name: "Bool", typ: "Unit" }, { name: "Int", typ: "Unit" }, { name: "Double", typ: "Unit" }, { name: "String", typ: "Unit" }, { name: "Array", typ: "Unit" }, { name: "Object", typ: "Unit" }] },
    { name: "JsonError", fields: [{ name: "ParseError", typ: "String" }, { name: "TypeError", typ: "String" }] },
  ]
}

///|
/// json 跨平台配置 | json cross-platform config
pub fn json_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/json", package_name: "moonbitlang/json", targets: @core.all_platforms(), functions: json_export_functions(), types: json_export_types() }
}

///|
/// hash 模块名 | hash module name
pub fn hash_module_name() -> String {
  "moonbitlang_hash"
}

///|
/// hash 版本 | hash version
pub fn hash_version() -> String {
  "0.1.0"
}

///|
/// hash 导出函数列表 | hash export function list
pub fn hash_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "hash_md5", params: [{ name: "data", typ: "Bytes" }], return_type: "Bytes" },
    { name: "hash_sha1", params: [{ name: "data", typ: "Bytes" }], return_type: "Bytes" },
    { name: "hash_sha256", params: [{ name: "data", typ: "Bytes" }], return_type: "Bytes" },
    { name: "hash_sha512", params: [{ name: "data", typ: "Bytes" }], return_type: "Bytes" },
    { name: "hash_hmac_sha256", params: [{ name: "key", typ: "Bytes" }, { name: "data", typ: "Bytes" }], return_type: "Bytes" },
  ]
}

///|
/// hash 导出类型 | hash export types
pub fn hash_export_types() -> Array[@config.ExportType] {
  []
}

///|
/// hash 跨平台配置 | hash cross-platform config
pub fn hash_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/hash", package_name: "moonbitlang/hash", targets: @core.all_platforms(), functions: hash_export_functions(), types: hash_export_types() }
}
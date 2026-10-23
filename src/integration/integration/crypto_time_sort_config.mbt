///|
/// crypto 模块名 | crypto module name
pub fn crypto_module_name() -> String {
  "moonbitlang_crypto"
}

///|
/// crypto 版本 | crypto version
pub fn crypto_version() -> String {
  "0.1.0"
}

///|
/// crypto 导出函数列表 | crypto export function list
pub fn crypto_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "crypto_aes_encrypt", params: [{ name: "key", typ: "Bytes" }, { name: "data", typ: "Bytes" }], return_type: "Bytes" },
    { name: "crypto_aes_decrypt", params: [{ name: "key", typ: "Bytes" }, { name: "data", typ: "Bytes" }], return_type: "Bytes" },
    { name: "crypto_hmac", params: [{ name: "key", typ: "Bytes" }, { name: "data", typ: "Bytes" }], return_type: "Bytes" },
    { name: "crypto_random_bytes", params: [{ name: "len", typ: "Int" }], return_type: "Bytes" },
    { name: "crypto_rsa_sign", params: [{ name: "key", typ: "Bytes" }, { name: "data", typ: "Bytes" }], return_type: "Bytes" },
  ]
}

///|
/// crypto 导出类型 | crypto export types
pub fn crypto_export_types() -> Array[@config.ExportType] {
  [
    { name: "CipherKey", fields: [{ name: "algorithm", typ: "String" }, { name: "key", typ: "Bytes" }] },
  ]
}

///|
/// crypto 跨平台配置 | crypto cross-platform config
pub fn crypto_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/crypto", package_name: "moonbitlang/crypto", targets: @core.all_platforms(), functions: crypto_export_functions(), types: crypto_export_types() }
}

///|
/// time 模块名 | time module name
pub fn time_module_name() -> String {
  "moonbitlang_time"
}

///|
/// time 版本 | time version
pub fn time_version() -> String {
  "0.1.0"
}

///|
/// time 导出函数列表 | time export function list
pub fn time_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "time_now", params: [], return_type: "Int" },
    { name: "time_format", params: [{ name: "timestamp", typ: "Int" }, { name: "format", typ: "String" }], return_type: "String" },
    { name: "time_parse", params: [{ name: "input", typ: "String" }, { name: "format", typ: "String" }], return_type: "Int" },
    { name: "time_duration", params: [{ name: "start", typ: "Int" }, { name: "end", typ: "Int" }], return_type: "Int" },
    { name: "time_sleep", params: [{ name: "ms", typ: "Int" }], return_type: "Unit" },
  ]
}

///|
/// time 导出类型 | time export types
pub fn time_export_types() -> Array[@config.ExportType] {
  [
    { name: "Duration", fields: [{ name: "nanos", typ: "Int" }, { name: "secs", typ: "Int" }] },
  ]
}

///|
/// time 跨平台配置 | time cross-platform config
pub fn time_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/time", package_name: "moonbitlang/time", targets: @core.all_platforms(), functions: time_export_functions(), types: time_export_types() }
}

///|
/// sort 模块名 | sort module name
pub fn sort_module_name() -> String {
  "moonbitlang_sort"
}

///|
/// sort 版本 | sort version
pub fn sort_version() -> String {
  "0.1.0"
}

///|
/// sort 导出函数列表 | sort export function list
pub fn sort_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "sort_quick_sort", params: [{ name: "arr", typ: "Array" }], return_type: "Array" },
    { name: "sort_merge_sort", params: [{ name: "arr", typ: "Array" }], return_type: "Array" },
    { name: "sort_bubble_sort", params: [{ name: "arr", typ: "Array" }], return_type: "Array" },
    { name: "sort_binary_search", params: [{ name: "arr", typ: "Array" }, { name: "target", typ: "Int" }], return_type: "Int" },
    { name: "sort_is_sorted", params: [{ name: "arr", typ: "Array" }], return_type: "Bool" },
  ]
}

///|
/// sort 导出类型 | sort export types
pub fn sort_export_types() -> Array[@config.ExportType] {
  []
}

///|
/// sort 跨平台配置 | sort cross-platform config
pub fn sort_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/sort", package_name: "moonbitlang/sort", targets: @core.all_platforms(), functions: sort_export_functions(), types: sort_export_types() }
}
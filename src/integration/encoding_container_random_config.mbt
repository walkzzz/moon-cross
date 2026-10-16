///|
/// encoding 模块名 | encoding module name
pub fn encoding_module_name() -> String {
  "moonbitlang_encoding"
}

///|
/// encoding 版本 | encoding version
pub fn encoding_version() -> String {
  "0.1.0"
}

///|
/// encoding 导出函数列表 | encoding export function list
pub fn encoding_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "encoding_encode", params: [{ name: "data", typ: "Bytes" }, { name: "scheme", typ: "String" }], return_type: "Bytes" },
    { name: "encoding_decode", params: [{ name: "data", typ: "Bytes" }, { name: "scheme", typ: "String" }], return_type: "Bytes" },
    { name: "encoding_convert", params: [{ name: "data", typ: "Bytes" }, { name: "from", typ: "String" }, { name: "to", typ: "String" }], return_type: "Bytes" },
    { name: "encoding_detect", params: [{ name: "data", typ: "Bytes" }], return_type: "String" },
    { name: "encoding_validate", params: [{ name: "data", typ: "Bytes" }, { name: "scheme", typ: "String" }], return_type: "Bool" },
  ]
}

///|
/// encoding 导出类型 | encoding export types
pub fn encoding_export_types() -> Array[@config.ExportType] {
  [
    { name: "EncodingScheme", fields: [{ name: "name", typ: "String" }, { name: "aliases", typ: "Array" }] },
  ]
}

///|
/// encoding 跨平台配置 | encoding cross-platform config
pub fn encoding_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/encoding", package_name: "moonbitlang/encoding", targets: @core.all_platforms(), functions: encoding_export_functions(), types: encoding_export_types() }
}

///|
/// container 模块名 | container module name
pub fn container_module_name() -> String {
  "moonbitlang_container"
}

///|
/// container 版本 | container version
pub fn container_version() -> String {
  "0.1.0"
}

///|
/// container 导出函数列表 | container export function list
pub fn container_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "container_push", params: [{ name: "container", typ: "Container" }, { name: "item", typ: "Any" }], return_type: "Container" },
    { name: "container_pop", params: [{ name: "container", typ: "Container" }], return_type: "Any" },
    { name: "container_peek", params: [{ name: "container", typ: "Container" }], return_type: "Any" },
    { name: "container_size", params: [{ name: "container", typ: "Container" }], return_type: "Int" },
    { name: "container_clear", params: [{ name: "container", typ: "Container" }], return_type: "Container" },
  ]
}

///|
/// container 导出类型 | container export types
pub fn container_export_types() -> Array[@config.ExportType] {
  [
    { name: "Container", fields: [{ name: "items", typ: "Array" }, { name: "typ", typ: "String" }] },
    { name: "ContainerType", fields: [{ name: "name", typ: "String" }] },
  ]
}

///|
/// container 跨平台配置 | container cross-platform config
pub fn container_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/container", package_name: "moonbitlang/container", targets: @core.all_platforms(), functions: container_export_functions(), types: container_export_types() }
}

///|
/// random 模块名 | random module name
pub fn random_module_name() -> String {
  "moonbitlang_random"
}

///|
/// random 版本 | random version
pub fn random_version() -> String {
  "0.1.0"
}

///|
/// random 导出函数列表 | random export function list
pub fn random_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "random_next", params: [{ name: "state", typ: "RngState" }], return_type: "Int" },
    { name: "random_range", params: [{ name: "state", typ: "RngState" }, { name: "min", typ: "Int" }, { name: "max", typ: "Int" }], return_type: "Int" },
    { name: "random_seed", params: [{ name: "seed", typ: "Int" }], return_type: "RngState" },
    { name: "random_shuffle", params: [{ name: "arr", typ: "Array" }], return_type: "Array" },
    { name: "random_sample", params: [{ name: "arr", typ: "Array" }, { name: "count", typ: "Int" }], return_type: "Array" },
  ]
}

///|
/// random 导出类型 | random export types
pub fn random_export_types() -> Array[@config.ExportType] {
  [
    { name: "RngState", fields: [{ name: "seed", typ: "Int" }, { name: "next", typ: "Int" }] },
  ]
}

///|
/// random 跨平台配置 | random cross-platform config
pub fn random_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/random", package_name: "moonbitlang/random", targets: @core.all_platforms(), functions: random_export_functions(), types: random_export_types() }
}
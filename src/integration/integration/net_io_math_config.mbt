///|
/// net 模块名 | net module name
pub fn net_module_name() -> String {
  "moonbitlang_net"
}

///|
/// net 版本 | net version
pub fn net_version() -> String {
  "0.1.0"
}

///|
/// net 导出函数列表 | net export function list
pub fn net_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "net_connect", params: [{ name: "addr", typ: "String" }, { name: "port", typ: "Int" }], return_type: "Socket" },
    { name: "net_listen", params: [{ name: "port", typ: "Int" }], return_type: "Socket" },
    { name: "net_send", params: [{ name: "socket", typ: "Socket" }, { name: "data", typ: "Bytes" }], return_type: "Int" },
    { name: "net_recv", params: [{ name: "socket", typ: "Socket" }, { name: "len", typ: "Int" }], return_type: "Bytes" },
    { name: "net_close", params: [{ name: "socket", typ: "Socket" }], return_type: "Unit" },
  ]
}

///|
/// net 导出类型 | net export types
pub fn net_export_types() -> Array[@config.ExportType] {
  [
    { name: "Socket", fields: [{ name: "fd", typ: "Int" }, { name: "addr", typ: "String" }] },
    { name: "Address", fields: [{ name: "host", typ: "String" }, { name: "port", typ: "Int" }] },
  ]
}

///|
/// net 跨平台配置 | net cross-platform config
pub fn net_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/net", package_name: "moonbitlang/net", targets: @core.all_platforms(), functions: net_export_functions(), types: net_export_types() }
}

///|
/// io 模块名 | io module name
pub fn io_module_name() -> String {
  "moonbitlang_io"
}

///|
/// io 版本 | io version
pub fn io_version() -> String {
  "0.1.0"
}

///|
/// io 导出函数列表 | io export function list
pub fn io_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "io_open", params: [{ name: "path", typ: "String" }, { name: "mode", typ: "String" }], return_type: "FileHandle" },
    { name: "io_read", params: [{ name: "handle", typ: "FileHandle" }, { name: "len", typ: "Int" }], return_type: "Bytes" },
    { name: "io_write", params: [{ name: "handle", typ: "FileHandle" }, { name: "data", typ: "Bytes" }], return_type: "Int" },
    { name: "io_seek", params: [{ name: "handle", typ: "FileHandle" }, { name: "offset", typ: "Int" }], return_type: "Int" },
    { name: "io_close", params: [{ name: "handle", typ: "FileHandle" }], return_type: "Unit" },
  ]
}

///|
/// io 导出类型 | io export types
pub fn io_export_types() -> Array[@config.ExportType] {
  [
    { name: "FileHandle", fields: [{ name: "fd", typ: "Int" }, { name: "path", typ: "String" }] },
    { name: "Buffer", fields: [{ name: "data", typ: "Bytes" }, { name: "size", typ: "Int" }] },
  ]
}

///|
/// io 跨平台配置 | io cross-platform config
pub fn io_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/io", package_name: "moonbitlang/io", targets: @core.all_platforms(), functions: io_export_functions(), types: io_export_types() }
}

///|
/// math 模块名 | math module name
pub fn math_module_name() -> String {
  "moonbitlang_math"
}

///|
/// math 版本 | math version
pub fn math_version() -> String {
  "0.1.0"
}

///|
/// math 导出函数列表 | math export function list
pub fn math_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "math_sin", params: [{ name: "x", typ: "Double" }], return_type: "Double" },
    { name: "math_cos", params: [{ name: "x", typ: "Double" }], return_type: "Double" },
    { name: "math_sqrt", params: [{ name: "x", typ: "Double" }], return_type: "Double" },
    { name: "math_pow", params: [{ name: "base", typ: "Double" }, { name: "exp", typ: "Double" }], return_type: "Double" },
    { name: "math_abs", params: [{ name: "x", typ: "Double" }], return_type: "Double" },
    { name: "math_floor", params: [{ name: "x", typ: "Double" }], return_type: "Double" },
    { name: "math_ceil", params: [{ name: "x", typ: "Double" }], return_type: "Double" },
    { name: "math_log", params: [{ name: "x", typ: "Double" }], return_type: "Double" },
  ]
}

///|
/// math 导出类型 | math export types
pub fn math_export_types() -> Array[@config.ExportType] {
  [
    { name: "Vector2", fields: [{ name: "x", typ: "Double" }, { name: "y", typ: "Double" }] },
    { name: "Vector3", fields: [{ name: "x", typ: "Double" }, { name: "y", typ: "Double" }, { name: "z", typ: "Double" }] },
  ]
}

///|
/// math 跨平台配置 | math cross-platform config
pub fn math_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/math", package_name: "moonbitlang/math", targets: @core.all_platforms(), functions: math_export_functions(), types: math_export_types() }
}
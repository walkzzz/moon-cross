///|
/// fs 模块名 | fs module name
pub fn fs_module_name() -> String {
  "moonbitlang_fs"
}

///|
/// fs 版本 | fs version
pub fn fs_version() -> String {
  "0.1.0"
}

///|
/// fs 导出函数列表 | fs export function list
pub fn fs_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "fs_read", params: [{ name: "path", typ: "String" }], return_type: "Bytes" },
    { name: "fs_write", params: [{ name: "path", typ: "String" }, { name: "data", typ: "Bytes" }], return_type: "Bool" },
    { name: "fs_exists", params: [{ name: "path", typ: "String" }], return_type: "Bool" },
    { name: "fs_mkdir", params: [{ name: "path", typ: "String" }], return_type: "Bool" },
    { name: "fs_remove", params: [{ name: "path", typ: "String" }], return_type: "Bool" },
    { name: "fs_stat", params: [{ name: "path", typ: "String" }], return_type: "FileInfo" },
  ]
}

///|
/// fs 导出类型 | fs export types
pub fn fs_export_types() -> Array[@config.ExportType] {
  [
    { name: "FileInfo", fields: [{ name: "name", typ: "String" }, { name: "size", typ: "Int" }, { name: "is_dir", typ: "Bool" }] },
  ]
}

///|
/// fs 跨平台配置 | fs cross-platform config
pub fn fs_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/fs", package_name: "moonbitlang/fs", targets: @core.all_platforms(), functions: fs_export_functions(), types: fs_export_types() }
}

///|
/// path 模块名 | path module name
pub fn path_module_name() -> String {
  "moonbitlang_path"
}

///|
/// path 版本 | path version
pub fn path_version() -> String {
  "0.1.0"
}

///|
/// path 导出函数列表 | path export function list
pub fn path_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "path_join", params: [{ name: "base", typ: "String" }, { name: "sub", typ: "String" }], return_type: "String" },
    { name: "path_normalize", params: [{ name: "path", typ: "String" }], return_type: "String" },
    { name: "path_dirname", params: [{ name: "path", typ: "String" }], return_type: "String" },
    { name: "path_basename", params: [{ name: "path", typ: "String" }], return_type: "String" },
    { name: "path_extname", params: [{ name: "path", typ: "String" }], return_type: "String" },
    { name: "path_is_absolute", params: [{ name: "path", typ: "String" }], return_type: "Bool" },
  ]
}

///|
/// path 导出类型 | path export types
pub fn path_export_types() -> Array[@config.ExportType] {
  [
    { name: "Path", fields: [{ name: "components", typ: "Array" }, { name: "separator", typ: "String" }, { name: "is_absolute", typ: "Bool" }] },
  ]
}

///|
/// path 跨平台配置 | path cross-platform config
pub fn path_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/path", package_name: "moonbitlang/path", targets: @core.all_platforms(), functions: path_export_functions(), types: path_export_types() }
}

///|
/// process 模块名 | process module name
pub fn process_module_name() -> String {
  "moonbitlang_process"
}

///|
/// process 版本 | process version
pub fn process_version() -> String {
  "0.1.0"
}

///|
/// process 导出函数列表 | process export function list
pub fn process_export_functions() -> Array[@config.ExportFunction] {
  [
    { name: "process_spawn", params: [{ name: "cmd", typ: "String" }, { name: "args", typ: "Array" }], return_type: "Process" },
    { name: "process_wait", params: [{ name: "proc", typ: "Process" }], return_type: "Int" },
    { name: "process_kill", params: [{ name: "proc", typ: "Process" }], return_type: "Bool" },
    { name: "process_exit", params: [{ name: "code", typ: "Int" }], return_type: "Unit" },
    { name: "process_env", params: [{ name: "key", typ: "String" }], return_type: "String" },
  ]
}

///|
/// process 导出类型 | process export types
pub fn process_export_types() -> Array[@config.ExportType] {
  [
    { name: "Process", fields: [{ name: "pid", typ: "Int" }, { name: "command", typ: "String" }, { name: "args", typ: "Array" }] },
  ]
}

///|
/// process 跨平台配置 | process cross-platform config
pub fn process_cross_config() -> @config.CrossConfig {
  { version: 1, module_path: "moonbitlang/process", package_name: "moonbitlang/process", targets: @core.all_platforms(), functions: process_export_functions(), types: process_export_types() }
}
///|
/// mizchi/zlib 模块名 | mizchi/zlib module name
pub fn zlib_module_name() -> String {
  "mizchi_zlib"
}

///|
/// mizchi/zlib 版本 | mizchi/zlib version
pub fn zlib_version() -> String {
  "0.4.10"
}

///|
/// zlib 导出函数列表（基于 mizchi/zlib v0.4.10 公开 API） | zlib export function list (based on mizchi/zlib v0.4.10 public API)
pub fn zlib_export_functions() -> Array[@config.ExportFunction] {
  [
    {
      name: "zlib_compress",
      params: [{ name: "data", typ: "Bytes" }],
      return_type: "Bytes",
    },
    {
      name: "zlib_decompress",
      params: [{ name: "data", typ: "Bytes" }],
      return_type: "Bytes",
    },
    {
      name: "zlib_compress_stored",
      params: [{ name: "data", typ: "Bytes" }],
      return_type: "Bytes",
    },
    {
      name: "zlib_decompress_stored",
      params: [{ name: "data", typ: "Bytes" }],
      return_type: "Bytes",
    },
    {
      name: "deflate_compress",
      params: [{ name: "data", typ: "Bytes" }],
      return_type: "Bytes",
    },
    {
      name: "deflate_decompress",
      params: [{ name: "data", typ: "Bytes" }],
      return_type: "Bytes",
    },
    {
      name: "gzip_compress",
      params: [{ name: "data", typ: "Bytes" }],
      return_type: "Bytes",
    },
    {
      name: "gzip_decompress",
      params: [{ name: "data", typ: "Bytes" }],
      return_type: "Bytes",
    },
    {
      name: "adler32",
      params: [{ name: "data", typ: "Bytes" }],
      return_type: "Int",
    },
    {
      name: "crc32",
      params: [{ name: "data", typ: "Bytes" }],
      return_type: "UInt",
    },
  ]
}

///|
/// zlib 导出类型（ZlibError） | zlib export types (ZlibError)
pub fn zlib_export_types() -> Array[@config.ExportType] {
  [
    {
      name: "ZlibError",
      fields: [
        { name: "InvalidData", typ: "String" },
        { name: "OutputTooLarge", typ: "String" },
      ],
    },
  ]
}

///|
/// 为 mizchi/zlib 生成完整的跨平台配置 | Generate complete cross-platform config for mizchi/zlib
pub fn zlib_cross_config() -> @config.CrossConfig {
  {
    version: 1,
    module_path: "mizchi/zlib",
    package_name: "mizchi/zlib",
    targets: @core.all_platforms(),
    functions: zlib_export_functions(),
    types: zlib_export_types(),
  }
}

///|
/// zlib 导出函数数量 | zlib export function count
pub fn zlib_function_count() -> Int {
  zlib_export_functions().length()
}

///|
/// zlib 导出类型数量 | zlib export type count
pub fn zlib_type_count() -> Int {
  zlib_export_types().length()
}

///|
/// zlib 目标平台数量 | zlib target platform count
pub fn zlib_target_count() -> Int {
  zlib_cross_config().targets.length()
}
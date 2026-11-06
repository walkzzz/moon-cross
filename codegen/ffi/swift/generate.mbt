///|
/// Swift 绑定生成配置 | Swift binding generation config
pub(all) struct SwiftBindingConfig {
  module_name : String
  function_name : String
} derive(Debug, Eq)

///|
pub extend SwiftBindingConfig with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend SwiftBindingConfig with Eq::{not_equal, equal}

///|
/// Swift interop 版本 | Swift interop version
pub fn swift_version() -> String {
  "moon-cross Swift interop v0.3.33"
}

///|
/// 生成 Swift C interop 声明 | Generate Swift C interop declaration
pub fn swift_c_interop_declaration(config : SwiftBindingConfig) -> String {
  "import " +
  config.module_name +
  "\n\nfunc " +
  config.function_name +
  "() -> Data"
}

///|
/// 生成 Package.swift | Generate Package.swift
pub fn generate_package_swift(name : String) -> String {
  "// swift-tools-version:5.9\nimport PackageDescription\n\nlet package = Package(\n  name: \"" +
  name +
  "\",\n  products: [.library(name: \"" +
  name +
  "\", targets: [\"" +
  name +
  "\"])],\n  targets: [.target(name: \"" +
  name +
  "\")]\n)\n"
}

///|
/// 生成 XCFramework info.plist 骨架 | Generate XCFramework info.plist skeleton
pub fn generate_xcframework_info() -> String {
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<plist version=\"1.0\">\n<dict>\n  <key>AvailableLibraries</key>\n  <array/>\n</dict>\n</plist>\n"
}

///|
/// 生成 Swift import 声明 | Generate Swift import declaration
pub fn swift_import_declaration(module_name : String) -> String {
  "import " + module_name
}

///|
/// 生成 Swift wrapper 函数 | Generate Swift wrapper function
pub fn swift_wrapper_function(config : SwiftBindingConfig) -> String {
  "public func " +
  config.function_name +
  "() -> Data {\n  return " +
  config.module_name +
  "." +
  config.function_name +
  "()\n}"
}

///|
/// 生成 Swift modulemap | Generate Swift modulemap
pub fn generate_modulemap(module_name : String) -> String {
  "module " +
  module_name +
  " {\n  header \"" +
  module_name +
  ".h\"\n  export *\n}\n"
}

///|
/// 生成 XCFramework 创建命令 | Generate XCFramework creation command
pub fn xcframework_create_command(
  framework_path : String,
  output_path : String,
) -> String {
  "xcodebuild -create-xcframework -framework " +
  framework_path +
  " -output " +
  output_path
}

///|
/// 生成 Swift bridging header | Generate Swift bridging header
pub fn swift_bridging_header(module_name : String) -> String {
  "#import \"" + module_name + ".h\"\n"
}

///|
/// Swift 完整绑定配置（含参数和返回类型） | Swift full binding config
pub(all) struct SwiftFullBinding {
  module_name : String
  function_name : String
  params : Array[(String, String)]
  return_type : String
} derive(Debug, Eq)

///|
pub extend SwiftFullBinding with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend SwiftFullBinding with Eq::{not_equal, equal}

///|
/// Swift 类型映射（复用 typesys） | Swift type mapping (reuses typesys)
pub fn swift_type_map(mbt_type : String) -> String {
  match @typesys.parse_moonbit_type(mbt_type) {
    Some(t) => @typesys.moonbit_to_swift_string(t)
    None => "UnsafePointer<OpaquePointer>"
  }
}

///|
/// 生成 Swift interop 函数体（含类型转换 + C 调用） | Generate Swift interop function body
pub fn swift_function_body(config : SwiftFullBinding) -> String {
  let param_parts = []
  for p in config.params {
    param_parts.push(p.0 + ": " + swift_type_map(p.1))
  }
  let mut body = "public func " +
    config.function_name +
    "(" +
    join_str(param_parts, ", ")
  body = body + ") -> " + swift_type_map(config.return_type) + " {\n"
  body = body +
    "    // Call C function " +
    config.module_name +
    "_" +
    config.function_name +
    "\n"
  let call_parts = []
  for p in config.params {
    call_parts.push(p.0)
  }
  body = body +
    "    return " +
    config.module_name +
    "_" +
    config.function_name +
    "(" +
    join_str(call_parts, ", ") +
    ")\n"
  body = body + "}\n"
  body
}

///|
/// 生成完整 Swift 绑定文件 | Generate complete Swift binding file
pub fn swift_full_binding(config : SwiftFullBinding) -> String {
  "import Foundation\nimport " +
  config.module_name +
  "\n\n" +
  swift_function_body(config) +
  "\n"
}

///|
/// 连接字符串数组 | Join string array
fn join_str(parts : Array[String], sep : String) -> String {
  let mut result = ""
  let mut first = true
  for p in parts {
    if !first {
      result = result + sep
    }
    result = result + p
    first = false
  }
  result
}

///|
/// SwiftBindingConfig 实现 Named trait | SwiftBindingConfig implements Named
pub impl @trait.Named for SwiftBindingConfig with fn name(self) {
  self.module_name
}

///|
pub extend SwiftBindingConfig with @trait.Named::{name}

///|
/// SwiftBindingConfig 实现 Hashable trait | SwiftBindingConfig implements Hashable
pub impl @trait.Hashable for SwiftBindingConfig with fn hash(self) {
  @trait.Named::name(self).length()
}

///|
pub extend SwiftBindingConfig with @trait.Hashable::{hash}

///|
/// SwiftFullBinding 实现 Named trait | SwiftFullBinding implements Named
pub impl @trait.Named for SwiftFullBinding with fn name(self) {
  self.function_name
}

///|
pub extend SwiftFullBinding with @trait.Named::{name}

///|
/// SwiftFullBinding 实现 Hashable trait | SwiftFullBinding implements Hashable
pub impl @trait.Hashable for SwiftFullBinding with fn hash(self) {
  @trait.Named::name(self).length()
}

///|
pub extend SwiftFullBinding with @trait.Hashable::{hash}

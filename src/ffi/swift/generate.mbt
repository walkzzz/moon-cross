/// Swift 绑定生成配置
pub(all) struct SwiftBindingConfig {
  module_name : String
  function_name : String
} derive(Debug, Eq)

/// Swift interop 版本
pub fn swift_version() -> String {
  "moon-cross Swift interop v0.1.0"
}

/// 生成 Swift C interop 声明
pub fn swift_c_interop_declaration(config : SwiftBindingConfig) -> String {
  "import " + config.module_name + "\n\nfunc " + config.function_name + "() -> Data"
}

/// 生成 Package.swift
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

/// 生成 XCFramework info.plist 骨架
pub fn generate_xcframework_info() -> String {
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<plist version=\"1.0\">\n<dict>\n  <key>AvailableLibraries</key>\n  <array/>\n</dict>\n</plist>\n"
}

/// 生成 Swift import 声明
pub fn swift_import_declaration(module_name : String) -> String {
  "import " + module_name
}

/// 生成 Swift wrapper 函数
pub fn swift_wrapper_function(config : SwiftBindingConfig) -> String {
  "public func " +
  config.function_name +
  "() -> Data {\n  return " +
  config.module_name +
  "." +
  config.function_name +
  "()\n}"
}

/// 生成 Swift modulemap
pub fn generate_modulemap(module_name : String) -> String {
  "module " +
  module_name +
  " {\n  header \"" +
  module_name +
  ".h\"\n  export *\n}\n"
}

/// 生成 XCFramework 创建命令
pub fn xcframework_create_command(
  framework_path : String,
  output_path : String,
) -> String {
  "xcodebuild -create-xcframework -framework " +
  framework_path +
  " -output " +
  output_path
}

/// 生成 Swift bridging header
pub fn swift_bridging_header(module_name : String) -> String {
  "#import \"" + module_name + ".h\"\n"
}
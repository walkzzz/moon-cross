/// iOS 编译配置 | iOS compile configuration
pub(all) struct IosCompileConfig {
  arch : @core.Arch
  sdk_path : String
  output_dir : String
  output_name : String
  is_simulator : Bool
} derive(Debug, Eq)
pub extend IosCompileConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend IosCompileConfig with Eq::{not_equal, equal}

/// iOS 编译命令生成（xcrun clang 交叉编译） | iOS compile command generation (xcrun clang cross-compilation)
pub fn ios_compile_command(config : IosCompileConfig) -> String {
  let target = match (config.arch, config.is_simulator) {
    (@core.Arch::Arm64, false) => "arm64-apple-ios"
    (@core.Arch::Arm64, true) => "arm64-apple-ios-simulator"
    (@core.Arch::X86_64, true) => "x86_64-apple-ios-simulator"
    (@core.Arch::X86_64, false) => "x86_64-apple-ios"
  }
  "xcrun clang -target " +
  target +
  " -isysroot " +
  config.sdk_path +
  " -o " +
  config.output_dir +
  "/" +
  ios_dylib_name(config.output_name)
}

/// iOS 平台标识 | iOS platform identifier
pub fn ios_platform_id() -> String {
  "ios"
}

/// 默认 iOS 编译配置（arm64, 真机） | Default iOS compile config (arm64, device)
pub fn default_ios_config(
  sdk_path : String,
  output_dir : String,
  output_name : String,
) -> IosCompileConfig {
  { arch: @core.Arch::Arm64, sdk_path, output_dir, output_name, is_simulator: false }
}

/// 默认 iOS 模拟器配置（x86_64, 模拟器） | Default iOS simulator config (x86_64, simulator)
pub fn default_ios_simulator_config(
  sdk_path : String,
  output_dir : String,
  output_name : String,
) -> IosCompileConfig {
  { arch: @core.Arch::X86_64, sdk_path, output_dir, output_name, is_simulator: true }
}

/// iOS .dylib 输出文件名 | iOS .dylib output filename
pub fn ios_dylib_name(output_name : String) -> String {
  "lib" + output_name + ".dylib"
}

/// iOS Framework 名称 | iOS Framework name
pub fn ios_framework_name(output_name : String) -> String {
  output_name + ".framework"
}

/// iOS XCFramework 创建命令 | iOS XCFramework creation command
pub fn ios_xcframework_command(
  framework_name : String,
  output_dir : String,
) -> String {
  "xcodebuild -create-xcframework -framework " +
  output_dir +
  "/" +
  framework_name +
  " -output " +
  output_dir +
  "/" +
  framework_name +
  ".xcframework"
}

/// iOS SDK 路径获取命令 | iOS SDK path retrieval command
pub fn ios_sdk_path_command(sdk_name : String) -> String {
  "xcrun --sdk " + sdk_name + " --show-sdk-path"
}

/// iOS 最低版本 | iOS minimum version
pub fn ios_min_version() -> String {
  "13.0"
}

/// iOS 支持的架构 | iOS supported architectures
pub fn ios_supported_archs(is_simulator : Bool) -> Array[@core.Arch] {
  if is_simulator {
    [@core.Arch::Arm64, @core.Arch::X86_64]
  } else {
    [@core.Arch::Arm64]
  }
}
/// iOS bitcode 编译标志 | iOS bitcode compile flag
pub fn ios_bitcode_flag(enable : Bool) -> String {
  if enable { "-fembed-bitcode" } else { "-fembed-bitcode-marker" }
}

/// iOS Framework 版本 | iOS Framework version
pub fn ios_framework_version() -> String {
  "A"
}

/// iOS Swift Package 名称 | iOS Swift Package name
pub fn ios_swift_package_name(name : String) -> String {
  name + ".swift"
}

/// iOS Info.plist 内容生成 | iOS Info.plist content generation
pub fn ios_framework_info_plist(name : String, version : String) -> String {
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
  "<plist version=\"1.0\">\n" +
  "<dict>\n" +
  "  <key>CFBundleName</key>\n" +
  "  <string>" + name + "</string>\n" +
  "  <key>CFBundleIdentifier</key>\n" +
  "  <string>com.mooncross." + name + "</string>\n" +
  "  <key>CFBundleVersion</key>\n" +
  "  <string>" + version + "</string>\n" +
  "  <key>CFBundleExecutable</key>\n" +
  "  <string>" + name + "</string>\n" +
  "  <key>CFBundlePackageType</key>\n" +
  "  <string>FMWK</string>\n" +
  "</dict>\n" +
  "</plist>"
}

/// iOS 优化级别 | iOS optimization level
pub fn ios_optimization_level(level : String) -> String {
  "-O" + level
}

/// iOS clang 可用性检查标志 | iOS clang availability check flag
pub fn ios_availability_flag(version : String) -> String {
  "-miphoneos-version-min=" + version
}

/// Swift bridging header 名称 | Swift bridging header name
pub fn ios_bridging_header_name(name : String) -> String {
  name + "-Bridging-Header.h"
}

/// modulemap 名称 | modulemap name
pub fn ios_modulemap_name(name : String) -> String {
  name + ".modulemap"
}

/// iOS Swift Package.swift 内容 | iOS Swift Package.swift content
pub fn ios_swift_package_content(name : String) -> String {
  "// swift-tools-version:5.5\n" +
  "import PackageDescription\n" +
  "let package = Package(\n" +
  "    name: \"" + name + "\",\n" +
  "    products: [.library(name: \"" + name + "\", targets: [\"" + name + "\"])],\n" +
  "    targets: [.target(name: \"" + name + "\", path: \"src\")]\n" +
  ")"
}
/// Android NDK 编译配置 | Android NDK compilation configuration
pub(all) struct AndroidCompileConfig {
  arch : @core.Arch
  api_level : Int
  ndk_path : String
  output_dir : String
  output_name : String
} derive(Debug, Eq)
pub extend AndroidCompileConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend AndroidCompileConfig with Eq::{not_equal, equal}

/// Android 编译命令生成（NDK clang 交叉编译） | Android compile command generation (NDK clang cross-compilation)
pub fn android_compile_command(config : AndroidCompileConfig) -> String {
  let target = match config.arch {
    @core.Arch::Arm64 => "aarch64-linux-android" + config.api_level.to_string()
    @core.Arch::X86_64 => "x86_64-linux-android" + config.api_level.to_string()
  }
  ndk_clang_path(config.ndk_path) + " --target=" + target + " -o " + config.output_dir + "/" + android_so_name(config.output_name)
}

/// Android 平台标识 | Android platform identifier
pub fn android_platform_id() -> String {
  "android"
}

/// 默认 Android 编译配置（arm64, API 24） | Default Android compilation configuration (arm64, API 24)
pub fn default_android_config(ndk_path : String, output_dir : String, output_name : String) -> AndroidCompileConfig {
  { arch: @core.Arch::Arm64, api_level: 24, ndk_path, output_dir, output_name }
}

/// Android API Level 默认值 | Android API Level default value
pub fn default_api_level() -> Int {
  24
}

/// Android 支持的架构列表 | Android supported architectures list
pub fn android_supported_archs() -> Array[@core.Arch] {
  [@core.Arch::Arm64, @core.Arch::X86_64]
}

/// Android .so 输出文件名（lib<name>.so） | Android .so output filename (lib<name>.so)
pub fn android_so_name(output_name : String) -> String {
  "lib" + output_name + ".so"
}

/// Android NDK clang 路径 | Android NDK clang path
pub fn ndk_clang_path(ndk_path : String) -> String {
  ndk_path + "/toolchains/llvm/prebuilt/clang"
}

/// Android sysroot 路径 | Android sysroot path
pub fn android_sysroot(ndk_path : String) -> String {
  ndk_path + "/sysroot"
}

/// Android NDK 最低版本要求 | Android NDK minimum version requirement
pub fn min_ndk_version() -> String {
  "r26"
}

/// Android ABI 名称 | Android ABI name
pub fn android_abi(arch : @core.Arch) -> String {
  match arch {
    @core.Arch::Arm64 => "arm64-v8a"
    @core.Arch::X86_64 => "x86_64"
  }
}
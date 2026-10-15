/// 鸿蒙 OHOS 编译配置 | HarmonyOS OHOS compile configuration
pub(all) struct OhosCompileConfig {
  arch : @core.Arch
  sdk_path : String
  output_dir : String
  output_name : String
} derive(Debug, Eq)

/// 鸿蒙编译命令生成（OHOS clang 交叉编译） | HarmonyOS compile command generation (OHOS clang cross-compilation)
pub fn ohos_compile_command(config : OhosCompileConfig) -> String {
  let target = match config.arch {
    @core.Arch::Arm64 => "aarch64-linux-ohos"
    @core.Arch::X86_64 => "x86_64-linux-ohos"
  }
  config.sdk_path +
  "/clang --target=" +
  target +
  " -o " +
  config.output_dir +
  "/" +
  ohos_so_name(config.output_name)
}

/// 鸿蒙平台标识 | HarmonyOS platform identifier
pub fn ohos_platform_id() -> String {
  "ohos"
}

/// 默认鸿蒙编译配置（arm64） | Default HarmonyOS compile config (arm64)
pub fn default_ohos_config(
  sdk_path : String,
  output_dir : String,
  output_name : String,
) -> OhosCompileConfig {
  { arch: @core.Arch::Arm64, sdk_path, output_dir, output_name }
}

/// 鸿蒙 .so 输出文件名 | HarmonyOS .so output filename
pub fn ohos_so_name(output_name : String) -> String {
  "lib" + output_name + ".so"
}

/// 鸿蒙 NAPI 模块名 | HarmonyOS NAPI module name
pub fn ohos_napi_module_name(module_name : String) -> String {
  "lib" + module_name + ".so"
}

/// 鸿蒙 SDK 路径 | HarmonyOS SDK path
pub fn ohos_sdk_path() -> String {
  "$OHOS_SDK/native"
}

/// 鸿蒙 DevEco 工程名 | HarmonyOS DevEco project name
pub fn ohos_deveco_project_name(name : String) -> String {
  name + "_ohos"
}

/// 鸿蒙支持的架构 | HarmonyOS supported architectures
pub fn ohos_supported_archs() -> Array[@core.Arch] {
  [@core.Arch::Arm64, @core.Arch::X86_64]
}

/// 鸿蒙最低 API 版本 | HarmonyOS minimum API version
pub fn ohos_min_api_version() -> Int {
  10
}
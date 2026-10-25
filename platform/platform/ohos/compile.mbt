/// 鸿蒙 OHOS 编译配置 | HarmonyOS OHOS compile configuration
pub(all) struct OhosCompileConfig {
  arch : @core.Arch
  sdk_path : String
  output_dir : String
  output_name : String
} derive(Debug, Eq)
pub extend OhosCompileConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend OhosCompileConfig with Eq::{not_equal, equal}

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
/// 鸿蒙 HAP 包名 | HarmonyOS HAP package name
pub fn ohos_hap_name(name : String) -> String {
  name + ".hap"
}

/// 鸿蒙 HSP 模块名 | HarmonyOS HSP module name
pub fn ohos_hsp_name(name : String) -> String {
  name + ".hsp"
}

/// 鸿蒙 Stage 模型标识 | HarmonyOS Stage model identifier
pub fn ohos_stage_model() -> String {
  "stage"
}

/// 鸿蒙 bundle 名称 | HarmonyOS bundle name
pub fn ohos_bundle_name(name : String) -> String {
  "com.example." + name
}

/// 鸿蒙模块类型 | HarmonyOS module type
pub fn ohos_module_type(is_entry : Bool) -> String {
  if is_entry { "entry" } else { "feature" }
}

/// 鸿蒙构建命令 | HarmonyOS build command
pub fn ohos_build_command(mode : String) -> String {
  "hvigorw assembleHap --mode " + mode
}

/// 鸿蒙最低 Harmony API 版本 | HarmonyOS minimum Harmony API version
pub fn ohos_min_harmony_api() -> Int {
  12
}

/// 鸿蒙签名配置命令 | HarmonyOS signing configuration command
pub fn ohos_signing_config(profile : String) -> String {
  "hvigorw signHap --profile " + profile
}

/// 鸿蒙 oh-package.json5 内容 | HarmonyOS oh-package.json5 content
pub fn ohos_oh_package_json5(name : String, version : String) -> String {
  "{\n" +
  "  \"name\": \"" + name + "\",\n" +
  "  \"version\": \"" + version + "\"\n" +
  "}"
}

/// 鸿蒙 build-profile.json5 内容 | HarmonyOS build-profile.json5 content
pub fn ohos_build_profile_json5(name : String) -> String {
  "{\n" +
  "  \"app\": {\n" +
  "    \"signingConfigs\": [],\n" +
  "    \"products\": [{\n" +
  "      \"name\": \"" + name + "\",\n" +
  "      \"signingConfig\": \"default\"\n" +
  "    }]\n" +
  "  }\n" +
  "}"
}


///|
/// OhosCompileConfig 实现 Named trait | OhosCompileConfig implements Named
pub impl @trait.Named for OhosCompileConfig with name(self) {
  self.output_name
}
pub extend OhosCompileConfig with @trait.Named::{name}

///|
/// OhosCompileConfig 实现 Hashable trait | OhosCompileConfig implements Hashable
pub impl @trait.Hashable for OhosCompileConfig with hash(self) {
  @trait.Named::name(self).length()
}
pub extend OhosCompileConfig with @trait.Hashable::{hash}
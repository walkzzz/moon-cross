///|
/// toml 端到端流水线结果 | toml end-to-end pipeline result
pub(all) struct TomlPipelineResult {
  config : @config.CrossConfig
  c_header : String
  c_export_macro : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
  windows_command : String
  android_command : String
  ios_command : String
  ohos_command : String
} derive(Debug, Eq)
pub extend TomlPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TomlPipelineResult with Eq::{not_equal, equal}

///|
/// 生成 toml C wrapper 头文件 | Generate toml C wrapper header
pub fn toml_c_header() -> String {
  @codegen_c.generate_header(toml_module_name())
}

///|
/// 生成 toml C 导出宏 | Generate toml C export macro
pub fn toml_c_export_macro() -> String {
  @codegen.generate_export_macro()
}

///|
/// 生成 toml 四平台规格 | Generate toml four-platform specs
pub fn toml_platform_specs() -> Array[@platform.PlatformSpec] {
  let result = []
  for platform in @core.all_platforms() {
    result.push(@platform.platform_spec(platform))
  }
  result
}

///|
/// 生成 toml 四平台 FFI 绑定类型 | Generate toml four-platform FFI binding types
pub fn toml_ffi_bindings() -> Array[@ffi.FfiBindingType] {
  let result = []
  for platform in @core.all_platforms() {
    result.push(@ffi.ffi_binding_for_platform(platform))
  }
  result
}

///|
/// 生成 toml Windows 编译命令 | Generate toml Windows compile command
pub fn toml_windows_compile_command() -> String {
  let cfg = @platform_windows.default_windows_config(
    "output",
    toml_module_name(),
  )
  @platform_windows.windows_compile_command(cfg)
}

///|
/// 生成 toml Android 编译命令 | Generate toml Android compile command
pub fn toml_android_compile_command() -> String {
  let cfg = @platform_android.default_android_config(
    "/opt/android-ndk",
    "output",
    toml_module_name(),
  )
  @platform_android.android_compile_command(cfg)
}

///|
/// 生成 toml iOS 编译命令 | Generate toml iOS compile command
pub fn toml_ios_compile_command() -> String {
  let cfg = @platform_ios.default_ios_config(
    "/sdk/iphoneos",
    "output",
    toml_module_name(),
  )
  @platform_ios.ios_compile_command(cfg)
}

///|
/// 生成 toml 鸿蒙编译命令 | Generate toml HarmonyOS compile command
pub fn toml_ohos_compile_command() -> String {
  let cfg = @platform_ohos.default_ohos_config(
    "$OHOS_SDK/native",
    "output",
    toml_module_name(),
  )
  @platform_ohos.ohos_compile_command(cfg)
}

///|
/// 运行完整 toml 跨平台流水线 | Run complete toml cross-platform pipeline
pub fn run_toml_pipeline() -> TomlPipelineResult {
  {
    config: toml_cross_config(),
    c_header: toml_c_header(),
    c_export_macro: toml_c_export_macro(),
    platform_specs: toml_platform_specs(),
    ffi_bindings: toml_ffi_bindings(),
    windows_command: toml_windows_compile_command(),
    android_command: toml_android_compile_command(),
    ios_command: toml_ios_compile_command(),
    ohos_command: toml_ohos_compile_command(),
  }
}

///|
/// 验证 toml 流水线结果完整性 | Validate toml pipeline result integrity
pub fn validate_toml_pipeline(result : TomlPipelineResult) -> Bool {
  result.config.functions.length() > 0 &&
  result.config.types.length() > 0 &&
  result.c_header.length() > 0 &&
  result.c_export_macro.length() > 0 &&
  result.platform_specs.length() == 5 &&
  result.ffi_bindings.length() == 5 &&
  result.windows_command.length() > 0 &&
  result.android_command.length() > 0 &&
  result.ios_command.length() > 0 &&
  result.ohos_command.length() > 0
}
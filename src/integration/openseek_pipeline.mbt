///|
/// openseek 端到端流水线结果 | openseek end-to-end pipeline result
pub(all) struct OpenseekPipelineResult {
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
pub extend OpenseekPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend OpenseekPipelineResult with Eq::{not_equal, equal}

///|
/// 生成 openseek C wrapper 头文件 | Generate openseek C wrapper header
pub fn openseek_c_header() -> String {
  @codegen_c.generate_header(openseek_module_name())
}

///|
/// 生成 openseek C 导出宏 | Generate openseek C export macro
pub fn openseek_c_export_macro() -> String {
  @codegen.generate_export_macro()
}

///|
/// 生成 openseek 四平台规格 | Generate openseek four-platform specs
pub fn openseek_platform_specs() -> Array[@platform.PlatformSpec] {
  let result = []
  for platform in @core.all_platforms() {
    result.push(@platform.platform_spec(platform))
  }
  result
}

///|
/// 生成 openseek 四平台 FFI 绑定类型 | Generate openseek four-platform FFI binding types
pub fn openseek_ffi_bindings() -> Array[@ffi.FfiBindingType] {
  let result = []
  for platform in @core.all_platforms() {
    result.push(@ffi.ffi_binding_for_platform(platform))
  }
  result
}

///|
/// 生成 openseek Windows 编译命令 | Generate openseek Windows compile command
pub fn openseek_windows_compile_command() -> String {
  let cfg = @platform_windows.default_windows_config(
    "output",
    openseek_module_name(),
  )
  @platform_windows.windows_compile_command(cfg)
}

///|
/// 生成 openseek Android 编译命令 | Generate openseek Android compile command
pub fn openseek_android_compile_command() -> String {
  let cfg = @platform_android.default_android_config(
    "/opt/android-ndk",
    "output",
    openseek_module_name(),
  )
  @platform_android.android_compile_command(cfg)
}

///|
/// 生成 openseek iOS 编译命令 | Generate openseek iOS compile command
pub fn openseek_ios_compile_command() -> String {
  let cfg = @platform_ios.default_ios_config(
    "/sdk/iphoneos",
    "output",
    openseek_module_name(),
  )
  @platform_ios.ios_compile_command(cfg)
}

///|
/// 生成 openseek 鸿蒙编译命令 | Generate openseek HarmonyOS compile command
pub fn openseek_ohos_compile_command() -> String {
  let cfg = @platform_ohos.default_ohos_config(
    "$OHOS_SDK/native",
    "output",
    openseek_module_name(),
  )
  @platform_ohos.ohos_compile_command(cfg)
}

///|
/// 运行完整 openseek 跨平台流水线 | Run complete openseek cross-platform pipeline
pub fn run_openseek_pipeline() -> OpenseekPipelineResult {
  {
    config: openseek_cross_config(),
    c_header: openseek_c_header(),
    c_export_macro: openseek_c_export_macro(),
    platform_specs: openseek_platform_specs(),
    ffi_bindings: openseek_ffi_bindings(),
    windows_command: openseek_windows_compile_command(),
    android_command: openseek_android_compile_command(),
    ios_command: openseek_ios_compile_command(),
    ohos_command: openseek_ohos_compile_command(),
  }
}

///|
/// 验证 openseek 流水线结果完整性 | Validate openseek pipeline result integrity
pub fn validate_openseek_pipeline(result : OpenseekPipelineResult) -> Bool {
  result.config.functions.length() > 0 &&
  result.config.types.length() > 0 &&
  result.c_header.length() > 0 &&
  result.c_export_macro.length() > 0 &&
  result.platform_specs.length() == 4 &&
  result.ffi_bindings.length() == 4 &&
  result.windows_command.length() > 0 &&
  result.android_command.length() > 0 &&
  result.ios_command.length() > 0 &&
  result.ohos_command.length() > 0
}
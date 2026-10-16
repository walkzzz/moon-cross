///|
/// parser 端到端流水线结果 | parser end-to-end pipeline result
pub(all) struct ParserPipelineResult {
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
pub extend ParserPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ParserPipelineResult with Eq::{not_equal, equal}

///|
/// 生成 parser C wrapper 头文件 | Generate parser C wrapper header
pub fn parser_c_header() -> String {
  @codegen_c.generate_header(parser_module_name())
}

///|
/// 生成 parser C 导出宏 | Generate parser C export macro
pub fn parser_c_export_macro() -> String {
  @codegen.generate_export_macro()
}

///|
/// 生成 parser 四平台规格 | Generate parser four-platform specs
pub fn parser_platform_specs() -> Array[@platform.PlatformSpec] {
  let result = []
  for platform in @core.all_platforms() {
    result.push(@platform.platform_spec(platform))
  }
  result
}

///|
/// 生成 parser 四平台 FFI 绑定类型 | Generate parser four-platform FFI binding types
pub fn parser_ffi_bindings() -> Array[@ffi.FfiBindingType] {
  let result = []
  for platform in @core.all_platforms() {
    result.push(@ffi.ffi_binding_for_platform(platform))
  }
  result
}

///|
/// 生成 parser Windows 编译命令 | Generate parser Windows compile command
pub fn parser_windows_compile_command() -> String {
  let cfg = @platform_windows.default_windows_config(
    "output",
    parser_module_name(),
  )
  @platform_windows.windows_compile_command(cfg)
}

///|
/// 生成 parser Android 编译命令 | Generate parser Android compile command
pub fn parser_android_compile_command() -> String {
  let cfg = @platform_android.default_android_config(
    "/opt/android-ndk",
    "output",
    parser_module_name(),
  )
  @platform_android.android_compile_command(cfg)
}

///|
/// 生成 parser iOS 编译命令 | Generate parser iOS compile command
pub fn parser_ios_compile_command() -> String {
  let cfg = @platform_ios.default_ios_config(
    "/sdk/iphoneos",
    "output",
    parser_module_name(),
  )
  @platform_ios.ios_compile_command(cfg)
}

///|
/// 生成 parser 鸿蒙编译命令 | Generate parser HarmonyOS compile command
pub fn parser_ohos_compile_command() -> String {
  let cfg = @platform_ohos.default_ohos_config(
    "$OHOS_SDK/native",
    "output",
    parser_module_name(),
  )
  @platform_ohos.ohos_compile_command(cfg)
}

///|
/// 运行完整 parser 跨平台流水线 | Run complete parser cross-platform pipeline
pub fn run_parser_pipeline() -> ParserPipelineResult {
  {
    config: parser_cross_config(),
    c_header: parser_c_header(),
    c_export_macro: parser_c_export_macro(),
    platform_specs: parser_platform_specs(),
    ffi_bindings: parser_ffi_bindings(),
    windows_command: parser_windows_compile_command(),
    android_command: parser_android_compile_command(),
    ios_command: parser_ios_compile_command(),
    ohos_command: parser_ohos_compile_command(),
  }
}

///|
/// 验证 parser 流水线结果完整性 | Validate parser pipeline result integrity
pub fn validate_parser_pipeline(result : ParserPipelineResult) -> Bool {
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
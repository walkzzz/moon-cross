///|
/// 端到端流水线结果 | End-to-end pipeline result
pub(all) struct ZlibPipelineResult {
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
pub extend ZlibPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ZlibPipelineResult with Eq::{not_equal, equal}

///|
/// 生成 zlib C wrapper 头文件 | Generate zlib C wrapper header
pub fn zlib_c_header() -> String {
  @codegen_c.generate_header(zlib_module_name())
}

///|
/// 生成 zlib C 导出宏 | Generate zlib C export macro
pub fn zlib_c_export_macro() -> String {
  @codegen.generate_export_macro()
}

///|
/// 生成 zlib 四平台规格 | Generate zlib four-platform specs
pub fn zlib_platform_specs() -> Array[@platform.PlatformSpec] {
  let result = []
  for platform in @core.all_platforms() {
    result.push(@platform.platform_spec(platform))
  }
  result
}

///|
/// 生成 zlib 四平台 FFI 绑定类型 | Generate zlib four-platform FFI binding types
pub fn zlib_ffi_bindings() -> Array[@ffi.FfiBindingType] {
  let result = []
  for platform in @core.all_platforms() {
    result.push(@ffi.ffi_binding_for_platform(platform))
  }
  result
}

///|
/// 生成 zlib Windows 编译命令 | Generate zlib Windows compile command
pub fn zlib_windows_compile_command() -> String {
  let cfg = @platform_windows.default_windows_config(

    "output",
    zlib_module_name(),
  )
  @platform_windows.windows_compile_command(cfg)
}

///|
/// 生成 zlib Android 编译命令 | Generate zlib Android compile command
pub fn zlib_android_compile_command() -> String {
  let cfg = @platform_android.default_android_config(
    "/opt/android-ndk",
    "output",
    zlib_module_name(),
  )
  @platform_android.android_compile_command(cfg)
}

///|
/// 生成 zlib iOS 编译命令 | Generate zlib iOS compile command
pub fn zlib_ios_compile_command() -> String {
  let cfg = @platform_ios.default_ios_config(
    "/sdk/iphoneos",
    "output",
    zlib_module_name(),
  )
  @platform_ios.ios_compile_command(cfg)
}

///|
/// 生成 zlib 鸿蒙编译命令 | Generate zlib HarmonyOS compile command
pub fn zlib_ohos_compile_command() -> String {
  let cfg = @platform_ohos.default_ohos_config(
    "$OHOS_SDK/native",
    "output",
    zlib_module_name(),
  )
  @platform_ohos.ohos_compile_command(cfg)
}

///|
/// 运行完整 zlib 跨平台流水线 | Run complete zlib cross-platform pipeline
pub fn run_zlib_pipeline() -> ZlibPipelineResult {
  {
    config: zlib_cross_config(),
    c_header: zlib_c_header(),
    c_export_macro: zlib_c_export_macro(),
    platform_specs: zlib_platform_specs(),
    ffi_bindings: zlib_ffi_bindings(),
    windows_command: zlib_windows_compile_command(),
    android_command: zlib_android_compile_command(),
    ios_command: zlib_ios_compile_command(),
    ohos_command: zlib_ohos_compile_command(),
  }
}

///|
/// 流水线版本 | Pipeline version
pub fn pipeline_version() -> String {
  "moon-cross integration v0.4.0"
}

///|
/// 验证流水线结果完整性 | Validate pipeline result integrity
pub fn validate_pipeline(result : ZlibPipelineResult) -> Bool {
  result.config.functions.length() > 0 &&
  result.c_header.length() > 0 &&
  result.c_export_macro.length() > 0 &&
  result.platform_specs.length() == 5 &&
  result.ffi_bindings.length() == 5 &&
  result.windows_command.length() > 0 &&
  result.android_command.length() > 0 &&
  result.ios_command.length() > 0 &&
  result.ohos_command.length() > 0
}
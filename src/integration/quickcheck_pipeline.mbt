///|
/// quickcheck 端到端流水线结果 | quickcheck end-to-end pipeline result
pub(all) struct QuickcheckPipelineResult {
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
pub extend QuickcheckPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend QuickcheckPipelineResult with Eq::{not_equal, equal}

///|
/// 生成 quickcheck C wrapper 头文件 | Generate quickcheck C wrapper header
pub fn quickcheck_c_header() -> String {
  @codegen_c.generate_header(quickcheck_module_name())
}

///|
/// 生成 quickcheck C 导出宏 | Generate quickcheck C export macro
pub fn quickcheck_c_export_macro() -> String {
  @codegen.generate_export_macro()
}

///|
/// 生成 quickcheck 四平台规格 | Generate quickcheck four-platform specs
pub fn quickcheck_platform_specs() -> Array[@platform.PlatformSpec] {
  let result = []
  for platform in @core.all_platforms() {
    result.push(@platform.platform_spec(platform))
  }
  result
}

///|
/// 生成 quickcheck 四平台 FFI 绑定类型 | Generate quickcheck four-platform FFI binding types
pub fn quickcheck_ffi_bindings() -> Array[@ffi.FfiBindingType] {
  let result = []
  for platform in @core.all_platforms() {
    result.push(@ffi.ffi_binding_for_platform(platform))
  }
  result
}

///|
/// 生成 quickcheck Windows 编译命令 | Generate quickcheck Windows compile command
pub fn quickcheck_windows_compile_command() -> String {
  let cfg = @platform_windows.default_windows_config(
    "output",
    quickcheck_module_name(),
  )
  @platform_windows.windows_compile_command(cfg)
}

///|
/// 生成 quickcheck Android 编译命令 | Generate quickcheck Android compile command
pub fn quickcheck_android_compile_command() -> String {
  let cfg = @platform_android.default_android_config(
    "/opt/android-ndk",
    "output",
    quickcheck_module_name(),
  )
  @platform_android.android_compile_command(cfg)
}

///|
/// 生成 quickcheck iOS 编译命令 | Generate quickcheck iOS compile command
pub fn quickcheck_ios_compile_command() -> String {
  let cfg = @platform_ios.default_ios_config(
    "/sdk/iphoneos",
    "output",
    quickcheck_module_name(),
  )
  @platform_ios.ios_compile_command(cfg)
}

///|
/// 生成 quickcheck 鸿蒙编译命令 | Generate quickcheck HarmonyOS compile command
pub fn quickcheck_ohos_compile_command() -> String {
  let cfg = @platform_ohos.default_ohos_config(
    "$OHOS_SDK/native",
    "output",
    quickcheck_module_name(),
  )
  @platform_ohos.ohos_compile_command(cfg)
}

///|
/// 运行完整 quickcheck 跨平台流水线 | Run complete quickcheck cross-platform pipeline
pub fn run_quickcheck_pipeline() -> QuickcheckPipelineResult {
  {
    config: quickcheck_cross_config(),
    c_header: quickcheck_c_header(),
    c_export_macro: quickcheck_c_export_macro(),
    platform_specs: quickcheck_platform_specs(),
    ffi_bindings: quickcheck_ffi_bindings(),
    windows_command: quickcheck_windows_compile_command(),
    android_command: quickcheck_android_compile_command(),
    ios_command: quickcheck_ios_compile_command(),
    ohos_command: quickcheck_ohos_compile_command(),
  }
}

///|
/// 验证 quickcheck 流水线结果完整性 | Validate quickcheck pipeline result integrity
pub fn validate_quickcheck_pipeline(result : QuickcheckPipelineResult) -> Bool {
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
///|
/// crypto 流水线结果 | crypto pipeline result
pub(all) struct CryptoPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend CryptoPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CryptoPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 crypto 流水线 | Run crypto pipeline
pub fn run_crypto_pipeline() -> CryptoPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: crypto_cross_config(), c_header: @codegen_c.generate_header(crypto_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// time 流水线结果 | time pipeline result
pub(all) struct TimePipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend TimePipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TimePipelineResult with Eq::{not_equal, equal}

///|
/// 运行 time 流水线 | Run time pipeline
pub fn run_time_pipeline() -> TimePipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: time_cross_config(), c_header: @codegen_c.generate_header(time_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// sort 流水线结果 | sort pipeline result
pub(all) struct SortPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend SortPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SortPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 sort 流水线 | Run sort pipeline
pub fn run_sort_pipeline() -> SortPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: sort_cross_config(), c_header: @codegen_c.generate_header(sort_module_name()), platform_specs: specs, ffi_bindings: bindings }
}
///|
/// math64 流水线结果 | math64 pipeline result
pub(all) struct Math64PipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend Math64PipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Math64PipelineResult with Eq::{not_equal, equal}

///|
/// 运行 math64 流水线 | Run math64 pipeline
pub fn run_math64_pipeline() -> Math64PipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: math64_cross_config(), c_header: @codegen_c.generate_header(math64_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// bits 流水线结果 | bits pipeline result
pub(all) struct BitsPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend BitsPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend BitsPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 bits 流水线 | Run bits pipeline
pub fn run_bits_pipeline() -> BitsPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: bits_cross_config(), c_header: @codegen_c.generate_header(bits_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// fmt 流水线结果 | fmt pipeline result
pub(all) struct FmtPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend FmtPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FmtPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 fmt 流水线 | Run fmt pipeline
pub fn run_fmt_pipeline() -> FmtPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: fmt_cross_config(), c_header: @codegen_c.generate_header(fmt_module_name()), platform_specs: specs, ffi_bindings: bindings }
}
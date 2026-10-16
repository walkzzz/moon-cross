///|
/// net 流水线结果 | net pipeline result
pub(all) struct NetPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend NetPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend NetPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 net 流水线 | Run net pipeline
pub fn run_net_pipeline() -> NetPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: net_cross_config(), c_header: @codegen_c.generate_header(net_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// io 流水线结果 | io pipeline result
pub(all) struct IoPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend IoPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend IoPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 io 流水线 | Run io pipeline
pub fn run_io_pipeline() -> IoPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: io_cross_config(), c_header: @codegen_c.generate_header(io_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// math 流水线结果 | math pipeline result
pub(all) struct MathPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend MathPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend MathPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 math 流水线 | Run math pipeline
pub fn run_math_pipeline() -> MathPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: math_cross_config(), c_header: @codegen_c.generate_header(math_module_name()), platform_specs: specs, ffi_bindings: bindings }
}
///|
/// encoding 流水线结果 | encoding pipeline result
pub(all) struct EncodingPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend EncodingPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend EncodingPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 encoding 流水线 | Run encoding pipeline
pub fn run_encoding_pipeline() -> EncodingPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: encoding_cross_config(), c_header: @codegen_c.generate_header(encoding_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// container 流水线结果 | container pipeline result
pub(all) struct ContainerPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend ContainerPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ContainerPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 container 流水线 | Run container pipeline
pub fn run_container_pipeline() -> ContainerPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: container_cross_config(), c_header: @codegen_c.generate_header(container_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// random 流水线结果 | random pipeline result
pub(all) struct RandomPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend RandomPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RandomPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 random 流水线 | Run random pipeline
pub fn run_random_pipeline() -> RandomPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: random_cross_config(), c_header: @codegen_c.generate_header(random_module_name()), platform_specs: specs, ffi_bindings: bindings }
}
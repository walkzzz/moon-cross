///|
/// regexp 流水线结果 | regexp pipeline result
pub(all) struct RegexpPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend RegexpPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RegexpPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 regexp 流水线 | Run regexp pipeline
pub fn run_regexp_pipeline() -> RegexpPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: regexp_cross_config(), c_header: @codegen_c.generate_header(regexp_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// uuid 流水线结果 | uuid pipeline result
pub(all) struct UuidPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend UuidPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend UuidPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 uuid 流水线 | Run uuid pipeline
pub fn run_uuid_pipeline() -> UuidPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: uuid_cross_config(), c_header: @codegen_c.generate_header(uuid_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// bufio 流水线结果 | bufio pipeline result
pub(all) struct BufioPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend BufioPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend BufioPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 bufio 流水线 | Run bufio pipeline
pub fn run_bufio_pipeline() -> BufioPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: bufio_cross_config(), c_header: @codegen_c.generate_header(bufio_module_name()), platform_specs: specs, ffi_bindings: bindings }
}
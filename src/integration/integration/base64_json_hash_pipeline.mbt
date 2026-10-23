///|
/// base64 流水线结果 | base64 pipeline result
pub(all) struct Base64PipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend Base64PipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Base64PipelineResult with Eq::{not_equal, equal}

///|
/// 运行 base64 流水线 | Run base64 pipeline
pub fn run_base64_pipeline() -> Base64PipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: base64_cross_config(), c_header: @codegen_c.generate_header(base64_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// json 流水线结果 | json pipeline result
pub(all) struct JsonPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend JsonPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend JsonPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 json 流水线 | Run json pipeline
pub fn run_json_pipeline() -> JsonPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: json_cross_config(), c_header: @codegen_c.generate_header(json_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// hash 流水线结果 | hash pipeline result
pub(all) struct HashPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend HashPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend HashPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 hash 流水线 | Run hash pipeline
pub fn run_hash_pipeline() -> HashPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: hash_cross_config(), c_header: @codegen_c.generate_header(hash_module_name()), platform_specs: specs, ffi_bindings: bindings }
}
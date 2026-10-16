///|
/// fs 流水线结果 | fs pipeline result
pub(all) struct FsPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend FsPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FsPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 fs 流水线 | Run fs pipeline
pub fn run_fs_pipeline() -> FsPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: fs_cross_config(), c_header: @codegen_c.generate_header(fs_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// path 流水线结果 | path pipeline result
pub(all) struct PathPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend PathPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PathPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 path 流水线 | Run path pipeline
pub fn run_path_pipeline() -> PathPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: path_cross_config(), c_header: @codegen_c.generate_header(path_module_name()), platform_specs: specs, ffi_bindings: bindings }
}

///|
/// process 流水线结果 | process pipeline result
pub(all) struct ProcessPipelineResult {
  config : @config.CrossConfig
  c_header : String
  platform_specs : Array[@platform.PlatformSpec]
  ffi_bindings : Array[@ffi.FfiBindingType]
} derive(Debug, Eq)
pub extend ProcessPipelineResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ProcessPipelineResult with Eq::{not_equal, equal}

///|
/// 运行 process 流水线 | Run process pipeline
pub fn run_process_pipeline() -> ProcessPipelineResult {
  let specs = []
  for p in @core.all_platforms() {
    specs.push(@platform.platform_spec(p))
  }
  let bindings = []
  for p in @core.all_platforms() {
    bindings.push(@ffi.ffi_binding_for_platform(p))
  }
  { config: process_cross_config(), c_header: @codegen_c.generate_header(process_module_name()), platform_specs: specs, ffi_bindings: bindings }
}
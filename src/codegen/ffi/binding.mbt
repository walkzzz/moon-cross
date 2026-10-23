///|
/// FFI 绑定类型 | FFI binding type
pub(all) enum FfiBindingType {
  JniBinding
  NapiBinding
  DllImportBinding
  SwiftInteropBinding
  CffiBinding
} derive(Debug, Eq)
pub extend FfiBindingType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FfiBindingType with Eq::{not_equal, equal}

///|
/// FFI 绑定生成结果 | FFI binding generation result
pub(all) struct FfiBindingResult {
  binding_type : FfiBindingType
  filename : String
  content : String
} derive(Debug, Eq)
pub extend FfiBindingResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FfiBindingResult with Eq::{not_equal, equal}

///|
/// FFI 绑定版本 | FFI binding version
pub fn ffi_version() -> String {
  "moon-cross FFI v0.1.0"
}

///|
/// FFI 绑定类型转标识 | FFI binding type to identifier
pub fn FfiBindingType::to_id(self : FfiBindingType) -> String {
  match self {
    JniBinding => "jni"
    NapiBinding => "napi"
    DllImportBinding => "dllimport"
    SwiftInteropBinding => "swift-interop"
    CffiBinding => "cffi"
  }
}

///|
/// 根据平台获取 FFI 绑定类型 | Get FFI binding type for platform
pub fn ffi_binding_for_platform(platform : @core.Platform) -> FfiBindingType {
  match platform {
    @core.Ios => SwiftInteropBinding
    @core.Android => JniBinding
    @core.Windows => DllImportBinding
    @core.Ohos => NapiBinding
    @core.Linux => CffiBinding
  }
}



///|
/// FfiBindingResult 实现 Named trait | FfiBindingResult implements Named
pub impl @trait.Named for FfiBindingResult with name(self) {
  self.filename
}
pub extend FfiBindingResult with @trait.Named::{name}
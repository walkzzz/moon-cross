///|
/// FFI 绑定类型
pub(all) enum FfiBindingType {
  JniBinding
  NapiBinding
  DllImportBinding
  SwiftInteropBinding
} derive(Debug, Eq)

///|
/// FFI 绑定生成结果
pub(all) struct FfiBindingResult {
  binding_type : FfiBindingType
  filename : String
  content : String
} derive(Debug, Eq)

///|
/// FFI 绑定版本
pub fn ffi_version() -> String {
  "moon-cross FFI v0.1.0"
}

///|
/// FFI 绑定类型转标识
pub fn FfiBindingType::to_id(self : FfiBindingType) -> String {
  match self {
    JniBinding => "jni"
    NapiBinding => "napi"
    DllImportBinding => "dllimport"
    SwiftInteropBinding => "swift-interop"
  }
}

///|
/// 根据平台获取 FFI 绑定类型
pub fn ffi_binding_for_platform(platform : @core.Platform) -> FfiBindingType {
  match platform {
    @core.Ios => SwiftInteropBinding
    @core.Android => JniBinding
    @core.Windows => DllImportBinding
    @core.Ohos => NapiBinding
  }
}

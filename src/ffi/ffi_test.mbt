test "ffi_version" {
  assert_eq(@ffi.ffi_version(), "moon-cross FFI v0.1.0")
}

test "ffi_binding_type_to_id" {
  assert_eq(@ffi.FfiBindingType::JniBinding.to_id(), "jni")
  assert_eq(@ffi.FfiBindingType::NapiBinding.to_id(), "napi")
  assert_eq(@ffi.FfiBindingType::DllImportBinding.to_id(), "dllimport")
  assert_eq(@ffi.FfiBindingType::SwiftInteropBinding.to_id(), "swift-interop")
  assert_eq(@ffi.FfiBindingType::CffiBinding.to_id(), "cffi")
}

test "ffi_binding_for_ios" {
  assert_eq(@ffi.ffi_binding_for_platform(@core.Platform::Ios), @ffi.FfiBindingType::SwiftInteropBinding)
}

test "ffi_binding_for_android" {
  assert_eq(@ffi.ffi_binding_for_platform(@core.Platform::Android), @ffi.FfiBindingType::JniBinding)
}

test "ffi_binding_for_windows_ohos" {
  assert_eq(@ffi.ffi_binding_for_platform(@core.Platform::Windows), @ffi.FfiBindingType::DllImportBinding)
  assert_eq(@ffi.ffi_binding_for_platform(@core.Platform::Ohos), @ffi.FfiBindingType::NapiBinding)
}
test "ffi_binding_for_linux" {
  assert_eq(@ffi.ffi_binding_for_platform(@core.Platform::Linux), @ffi.FfiBindingType::CffiBinding)
}
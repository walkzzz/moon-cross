test "ffi_version" {
  assert_eq(ffi_version(), "moon-cross FFI v0.1.0")
}

test "ffi_binding_type_to_id" {
  assert_eq(FfiBindingType::JniBinding.to_id(), "jni")
  assert_eq(FfiBindingType::NapiBinding.to_id(), "napi")
  assert_eq(FfiBindingType::DllImportBinding.to_id(), "dllimport")
  assert_eq(FfiBindingType::SwiftInteropBinding.to_id(), "swift-interop")
}

test "ffi_binding_for_ios" {
  assert_eq(ffi_binding_for_platform(@core.Platform::Ios), FfiBindingType::SwiftInteropBinding)
}

test "ffi_binding_for_android" {
  assert_eq(ffi_binding_for_platform(@core.Platform::Android), FfiBindingType::JniBinding)
}

test "ffi_binding_for_windows_ohos" {
  assert_eq(ffi_binding_for_platform(@core.Platform::Windows), FfiBindingType::DllImportBinding)
  assert_eq(ffi_binding_for_platform(@core.Platform::Ohos), FfiBindingType::NapiBinding)
}
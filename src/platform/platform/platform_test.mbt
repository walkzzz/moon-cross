test "platform_spec_version" {
  assert_eq(@platform.platform_spec_version(), "moon-cross platform v0.1.0")
}

test "platform_spec_windows" {
  let spec = @platform.platform_spec(@core.Platform::Windows)
  assert_eq(spec.compiler, "clang-cl")
  assert_eq(spec.output_format, ".dll")
  assert_eq(spec.ffi_mechanism, "dllimport")
}

test "platform_spec_ios" {
  let spec = @platform.platform_spec(@core.Platform::Ios)
  assert_eq(spec.compiler, "xcrun clang")
  assert_eq(spec.output_format, ".dylib")
}

test "platform_spec_android" {
  let spec = @platform.platform_spec(@core.Platform::Android)
  assert_eq(spec.output_format, ".so")
  assert_eq(spec.ffi_mechanism, "jni")
}

test "platform_spec_ohos" {
  let spec = @platform.platform_spec(@core.Platform::Ohos)
  assert_eq(spec.ffi_mechanism, "napi")
}
test "platform_spec_linux" {
  let spec = @platform.platform_spec(@core.Platform::Linux)
  assert_eq(spec.compiler, "gcc")
  assert_eq(spec.output_format, ".so")
  assert_eq(spec.ffi_mechanism, "cffi")
}
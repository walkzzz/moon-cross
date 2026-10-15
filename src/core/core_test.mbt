test "platform_to_id" {
  assert_eq(Platform::Ios.to_id(), "ios")
  assert_eq(Platform::Android.to_id(), "android")
  assert_eq(Platform::Windows.to_id(), "windows")
  assert_eq(Platform::Ohos.to_id(), "ohos")
}

test "platform_display_name" {
  assert_eq(Platform::Ios.display_name(), "iOS")
  assert_eq(Platform::Android.display_name(), "Android")
  assert_eq(Platform::Windows.display_name(), "Windows")
  assert_eq(Platform::Ohos.display_name(), "HarmonyOS")
}

test "platform_from_id_valid" {
  assert_eq(Platform::from_id("ios"), Some(Platform::Ios))
  assert_eq(Platform::from_id("android"), Some(Platform::Android))
  assert_eq(Platform::from_id("windows"), Some(Platform::Windows))
  assert_eq(Platform::from_id("ohos"), Some(Platform::Ohos))
}

test "platform_from_id_invalid" {
  assert_eq(Platform::from_id("unknown"), None)
}

test "all_platforms_count" {
  assert_eq(all_platforms().length(), 4)
}

test "arch_to_id" {
  assert_eq(Arch::Arm64.to_id(), "arm64")
  assert_eq(Arch::X86_64.to_id(), "x86_64")
}

test "arch_from_id" {
  assert_eq(Arch::from_id("arm64"), Some(Arch::Arm64))
  assert_eq(Arch::from_id("x86_64"), Some(Arch::X86_64))
  assert_eq(Arch::from_id("unknown"), None)
}

test "platform_default_arch" {
  assert_eq(Platform::Ios.default_arch(), Arch::Arm64)
  assert_eq(Platform::Android.default_arch(), Arch::Arm64)
  assert_eq(Platform::Windows.default_arch(), Arch::X86_64)
  assert_eq(Platform::Ohos.default_arch(), Arch::Arm64)
}

test "target_triple_ios_arm64" {
  let tt = make_target_triple(Platform::Ios, Arch::Arm64)
  assert_eq(tt.triple, "arm64-apple-ios")
}

test "target_triple_ios_simulator" {
  let tt = make_target_triple(Platform::Ios, Arch::X86_64)
  assert_eq(tt.triple, "x86_64-apple-ios-simulator")
}

test "target_triple_android" {
  let tt = make_target_triple(Platform::Android, Arch::Arm64)
  assert_eq(tt.triple, "aarch64-linux-android24")
}

test "target_triple_windows" {
  let tt = make_target_triple(Platform::Windows, Arch::X86_64)
  assert_eq(tt.triple, "x86_64-pc-windows-msvc")
}

test "target_triple_ohos" {
  let tt = make_target_triple(Platform::Ohos, Arch::Arm64)
  assert_eq(tt.triple, "aarch64-linux-ohos")
}

test "target_triple_fields" {
  let tt = make_target_triple(Platform::Windows, Arch::X86_64)
  assert_eq(tt.platform, Platform::Windows)
  assert_eq(tt.arch, Arch::X86_64)
}

test "error_messages" {
  assert_eq(MoonCrossError::ConfigError("bad").to_message(), "Config error: bad")
  assert_eq(MoonCrossError::ParseError("fail").to_message(), "Parse error: fail")
  assert_eq(MoonCrossError::CompileError("err").to_message(), "Compile error: err")
}
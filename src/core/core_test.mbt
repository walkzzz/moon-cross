test "platform_to_id" {
  assert_eq(@core.Platform::Ios.to_id(), "ios")
  assert_eq(@core.Platform::Android.to_id(), "android")
  assert_eq(@core.Platform::Windows.to_id(), "windows")
  assert_eq(@core.Platform::Ohos.to_id(), "ohos")
}

test "platform_display_name" {
  assert_eq(@core.Platform::Ios.display_name(), "iOS")
  assert_eq(@core.Platform::Android.display_name(), "Android")
  assert_eq(@core.Platform::Windows.display_name(), "Windows")
  assert_eq(@core.Platform::Ohos.display_name(), "HarmonyOS")
}

test "platform_from_id_valid" {
  assert_eq(@core.Platform::from_id("ios"), Some(@core.Platform::Ios))
  assert_eq(@core.Platform::from_id("android"), Some(@core.Platform::Android))
  assert_eq(@core.Platform::from_id("windows"), Some(@core.Platform::Windows))
  assert_eq(@core.Platform::from_id("ohos"), Some(@core.Platform::Ohos))
}

test "platform_from_id_invalid" {
  assert_eq(@core.Platform::from_id("unknown"), None)
}

test "all_platforms_count" {
  assert_eq(@core.all_platforms().length(), 4)
}

test "arch_to_id" {
  assert_eq(@core.Arch::Arm64.to_id(), "arm64")
  assert_eq(@core.Arch::X86_64.to_id(), "x86_64")
}

test "arch_from_id" {
  assert_eq(@core.Arch::from_id("arm64"), Some(@core.Arch::Arm64))
  assert_eq(@core.Arch::from_id("x86_64"), Some(@core.Arch::X86_64))
  assert_eq(@core.Arch::from_id("unknown"), None)
}

test "platform_default_arch" {
  assert_eq(@core.Platform::Ios.default_arch(), @core.Arch::Arm64)
  assert_eq(@core.Platform::Android.default_arch(), @core.Arch::Arm64)
  assert_eq(@core.Platform::Windows.default_arch(), @core.Arch::X86_64)
  assert_eq(@core.Platform::Ohos.default_arch(), @core.Arch::Arm64)
}

test "target_triple_ios_arm64" {
  let tt = @core.make_target_triple(@core.Platform::Ios, @core.Arch::Arm64)
  assert_eq(tt.triple, "arm64-apple-ios")
}

test "target_triple_ios_simulator" {
  let tt = @core.make_target_triple(@core.Platform::Ios, @core.Arch::X86_64)
  assert_eq(tt.triple, "x86_64-apple-ios-simulator")
}

test "target_triple_android" {
  let tt = @core.make_target_triple(@core.Platform::Android, @core.Arch::Arm64)
  assert_eq(tt.triple, "aarch64-linux-android24")
}

test "target_triple_windows" {
  let tt = @core.make_target_triple(@core.Platform::Windows, @core.Arch::X86_64)
  assert_eq(tt.triple, "x86_64-pc-windows-msvc")
}

test "target_triple_ohos" {
  let tt = @core.make_target_triple(@core.Platform::Ohos, @core.Arch::Arm64)
  assert_eq(tt.triple, "aarch64-linux-ohos")
}

test "target_triple_fields" {
  let tt = @core.make_target_triple(@core.Platform::Windows, @core.Arch::X86_64)
  assert_eq(tt.platform, @core.Platform::Windows)
  assert_eq(tt.arch, @core.Arch::X86_64)
}

test "error_messages" {
  assert_eq(@core.MoonCrossError::ConfigError("bad").to_message(), "Config error: bad")
  assert_eq(@core.MoonCrossError::ParseError("fail").to_message(), "Parse error: fail")
  assert_eq(@core.MoonCrossError::CompileError("err").to_message(), "Compile error: err")
}
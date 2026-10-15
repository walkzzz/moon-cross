test "ios_platform_id" {
  assert_eq(ios_platform_id(), "ios")
}

test "ios_dylib_name" {
  assert_eq(ios_dylib_name("mylib"), "libmylib.dylib")
}

test "ios_dylib_name_empty" {
  assert_eq(ios_dylib_name(""), "lib.dylib")
}

test "ios_framework_name" {
  assert_eq(ios_framework_name("mylib"), "mylib.framework")
}

test "ios_framework_name_empty" {
  assert_eq(ios_framework_name(""), ".framework")
}

test "ios_min_version" {
  assert_eq(ios_min_version(), "13.0")
}

test "ios_sdk_path_command" {
  assert_eq(
    ios_sdk_path_command("iphoneos"),
    "xcrun --sdk iphoneos --show-sdk-path",
  )
}

test "ios_sdk_path_command_simulator" {
  assert_eq(
    ios_sdk_path_command("iphonesimulator"),
    "xcrun --sdk iphonesimulator --show-sdk-path",
  )
}

test "ios_supported_archs_device" {
  let archs = ios_supported_archs(false)
  assert_eq(archs.length(), 1)
  assert_eq(archs[0], @core.Arch::Arm64)
}

test "ios_supported_archs_simulator" {
  let archs = ios_supported_archs(true)
  assert_eq(archs.length(), 2)
}

test "default_ios_config_arch" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  assert_eq(cfg.arch, @core.Arch::Arm64)
}

test "default_ios_config_is_simulator" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  assert_eq(cfg.is_simulator, false)
}

test "default_ios_config_sdk_path" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  assert_eq(cfg.sdk_path, "/sdk")
}

test "default_ios_config_output_dir" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  assert_eq(cfg.output_dir, "output")
}

test "default_ios_config_output_name" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  assert_eq(cfg.output_name, "mylib")
}

test "default_ios_simulator_config_arch" {
  let cfg = default_ios_simulator_config("/sdk", "output", "mylib")
  assert_eq(cfg.arch, @core.Arch::X86_64)
}

test "default_ios_simulator_config_is_simulator" {
  let cfg = default_ios_simulator_config("/sdk", "output", "mylib")
  assert_eq(cfg.is_simulator, true)
}

test "ios_compile_command_arm64_device" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  let cmd = ios_compile_command(cfg)
  assert_true(cmd.contains("arm64-apple-ios"))
}

test "ios_compile_command_arm64_simulator" {
  let cfg : IosCompileConfig = {
    arch: @core.Arch::Arm64,
    sdk_path: "/sdk",
    output_dir: "output",
    output_name: "mylib",
    is_simulator: true,
  }
  let cmd = ios_compile_command(cfg)
  assert_true(cmd.contains("arm64-apple-ios-simulator"))
}

test "ios_compile_command_x86_64_simulator" {
  let cfg = default_ios_simulator_config("/sdk", "output", "mylib")
  let cmd = ios_compile_command(cfg)
  assert_true(cmd.contains("x86_64-apple-ios-simulator"))
}

test "ios_compile_command_x86_64_device" {
  let cfg : IosCompileConfig = {
    arch: @core.Arch::X86_64,
    sdk_path: "/sdk",
    output_dir: "output",
    output_name: "mylib",
    is_simulator: false,
  }
  let cmd = ios_compile_command(cfg)
  assert_true(cmd.contains("x86_64-apple-ios"))
}

test "ios_compile_command_contains_xcrun" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  let cmd = ios_compile_command(cfg)
  assert_true(cmd.contains("xcrun"))
}

test "ios_compile_command_contains_clang" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  let cmd = ios_compile_command(cfg)
  assert_true(cmd.contains("clang"))
}

test "ios_compile_command_contains_target" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  let cmd = ios_compile_command(cfg)
  assert_true(cmd.contains("-target"))
}

test "ios_compile_command_contains_isysroot" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  let cmd = ios_compile_command(cfg)
  assert_true(cmd.contains("-isysroot"))
}

test "ios_compile_command_contains_dylib" {
  let cfg = default_ios_config("/sdk", "output", "mylib")
  let cmd = ios_compile_command(cfg)
  assert_true(cmd.contains("libmylib.dylib"))
}

test "ios_xcframework_command" {
  let cmd = ios_xcframework_command("mylib.framework", "output")
  assert_true(cmd.contains("xcodebuild"))
  assert_true(cmd.contains("-create-xcframework"))
}

test "ios_xcframework_command_contains_output" {
  let cmd = ios_xcframework_command("mylib.framework", "output")
  assert_true(cmd.contains(".xcframework"))
}

test "ios_compile_config_construction" {
  let cfg : IosCompileConfig = {
    arch: @core.Arch::Arm64,
    sdk_path: "/sdk",
    output_dir: "out",
    output_name: "lib",
    is_simulator: true,
  }
  assert_eq(cfg.is_simulator, true)
  assert_eq(cfg.output_name, "lib")
}
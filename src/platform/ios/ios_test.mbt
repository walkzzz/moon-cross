test "ios_platform_id" {
  assert_eq(@ios.ios_platform_id(), "ios")
}

test "ios_dylib_name" {
  assert_eq(@ios.ios_dylib_name("mylib"), "libmylib.dylib")
}

test "ios_dylib_name_empty" {
  assert_eq(@ios.ios_dylib_name(""), "lib.dylib")
}

test "ios_framework_name" {
  assert_eq(@ios.ios_framework_name("mylib"), "mylib.framework")
}

test "ios_framework_name_empty" {
  assert_eq(@ios.ios_framework_name(""), ".framework")
}

test "ios_min_version" {
  assert_eq(@ios.ios_min_version(), "13.0")
}

test "ios_sdk_path_command" {
  assert_eq(
    @ios.ios_sdk_path_command("iphoneos"),
    "xcrun --sdk iphoneos --show-sdk-path",
  )
}

test "ios_sdk_path_command_simulator" {
  assert_eq(
    @ios.ios_sdk_path_command("iphonesimulator"),
    "xcrun --sdk iphonesimulator --show-sdk-path",
  )
}

test "ios_supported_archs_device" {
  let archs = @ios.ios_supported_archs(false)
  assert_eq(archs.length(), 1)
  assert_eq(archs[0], @core.Arch::Arm64)
}

test "ios_supported_archs_simulator" {
  let archs = @ios.ios_supported_archs(true)
  assert_eq(archs.length(), 2)
}

test "default_ios_config_arch" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  assert_eq(cfg.arch, @core.Arch::Arm64)
}

test "default_ios_config_is_simulator" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  assert_eq(cfg.is_simulator, false)
}

test "default_ios_config_sdk_path" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  assert_eq(cfg.sdk_path, "/sdk")
}

test "default_ios_config_output_dir" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  assert_eq(cfg.output_dir, "output")
}

test "default_ios_config_output_name" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  assert_eq(cfg.output_name, "mylib")
}

test "default_ios_simulator_config_arch" {
  let cfg = @ios.default_ios_simulator_config("/sdk", "output", "mylib")
  assert_eq(cfg.arch, @core.Arch::X86_64)
}

test "default_ios_simulator_config_is_simulator" {
  let cfg = @ios.default_ios_simulator_config("/sdk", "output", "mylib")
  assert_eq(cfg.is_simulator, true)
}

test "ios_compile_command_arm64_device" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  let cmd = @ios.ios_compile_command(cfg)
  assert_true(cmd.contains("arm64-apple-ios"))
}

test "ios_compile_command_arm64_simulator" {
  let cfg : @ios.IosCompileConfig = {
    arch: @core.Arch::Arm64,
    sdk_path: "/sdk",
    output_dir: "output",
    output_name: "mylib",
    is_simulator: true,
  }
  let cmd = @ios.ios_compile_command(cfg)
  assert_true(cmd.contains("arm64-apple-ios-simulator"))
}

test "ios_compile_command_x86_64_simulator" {
  let cfg = @ios.default_ios_simulator_config("/sdk", "output", "mylib")
  let cmd = @ios.ios_compile_command(cfg)
  assert_true(cmd.contains("x86_64-apple-ios-simulator"))
}

test "ios_compile_command_x86_64_device" {
  let cfg : @ios.IosCompileConfig = {
    arch: @core.Arch::X86_64,
    sdk_path: "/sdk",
    output_dir: "output",
    output_name: "mylib",
    is_simulator: false,
  }
  let cmd = @ios.ios_compile_command(cfg)
  assert_true(cmd.contains("x86_64-apple-ios"))
}

test "ios_compile_command_contains_xcrun" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  let cmd = @ios.ios_compile_command(cfg)
  assert_true(cmd.contains("xcrun"))
}

test "ios_compile_command_contains_clang" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  let cmd = @ios.ios_compile_command(cfg)
  assert_true(cmd.contains("clang"))
}

test "ios_compile_command_contains_target" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  let cmd = @ios.ios_compile_command(cfg)
  assert_true(cmd.contains("-target"))
}

test "ios_compile_command_contains_isysroot" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  let cmd = @ios.ios_compile_command(cfg)
  assert_true(cmd.contains("-isysroot"))
}

test "ios_compile_command_contains_dylib" {
  let cfg = @ios.default_ios_config("/sdk", "output", "mylib")
  let cmd = @ios.ios_compile_command(cfg)
  assert_true(cmd.contains("libmylib.dylib"))
}

test "ios_xcframework_command" {
  let cmd = @ios.ios_xcframework_command("mylib.framework", "output")
  assert_true(cmd.contains("xcodebuild"))
  assert_true(cmd.contains("-create-xcframework"))
}

test "ios_xcframework_command_contains_output" {
  let cmd = @ios.ios_xcframework_command("mylib.framework", "output")
  assert_true(cmd.contains(".xcframework"))
}

test "ios_compile_config_construction" {
  let cfg : @ios.IosCompileConfig = {
    arch: @core.Arch::Arm64,
    sdk_path: "/sdk",
    output_dir: "out",
    output_name: "lib",
    is_simulator: true,
  }
  assert_eq(cfg.is_simulator, true)
  assert_eq(cfg.output_name, "lib")
}
test "ios_bitcode_flag_enable" {
  assert_eq(@ios.ios_bitcode_flag(true), "-fembed-bitcode")
}

test "ios_bitcode_flag_disable" {
  assert_eq(@ios.ios_bitcode_flag(false), "-fembed-bitcode-marker")
}

test "ios_framework_version" {
  assert_eq(@ios.ios_framework_version(), "A")
}

test "ios_swift_package_name" {
  assert_eq(@ios.ios_swift_package_name("mylib"), "mylib.swift")
}

test "ios_framework_info_plist" {
  let plist = @ios.ios_framework_info_plist("mylib", "1.0")
  assert_true(plist.contains("CFBundleName"))
  assert_true(plist.contains("mylib"))
  assert_true(plist.contains("1.0"))
  assert_true(plist.contains("FMWK"))
}

test "ios_optimization_level" {
  assert_eq(@ios.ios_optimization_level("2"), "-O2")
  assert_eq(@ios.ios_optimization_level("s"), "-Os")
}

test "ios_availability_flag" {
  let flag = @ios.ios_availability_flag("13.0")
  assert_true(flag.contains("13.0"))
  assert_true(flag.contains("-miphoneos-version-min"))
}

test "ios_bridging_header_name" {
  assert_eq(@ios.ios_bridging_header_name("mylib"), "mylib-Bridging-Header.h")
}

test "ios_modulemap_name" {
  assert_eq(@ios.ios_modulemap_name("mylib"), "mylib.modulemap")
}

test "ios_swift_package_content" {
  let content = @ios.ios_swift_package_content("mylib")
  assert_true(content.contains("Package"))
  assert_true(content.contains("mylib"))
  assert_true(content.contains("swift-tools-version"))
}
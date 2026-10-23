test "android_platform_id" {
  assert_eq(@android.android_platform_id(), "android")
}

test "default_api_level" {
  assert_eq(@android.default_api_level(), 24)
}

test "android_so_name" {
  assert_eq(@android.android_so_name("mylib"), "libmylib.so")
}

test "android_so_name_empty" {
  assert_eq(@android.android_so_name(""), "lib.so")
}

test "ndk_clang_path" {
  assert_eq(
    @android.ndk_clang_path("/opt/android-ndk"),
    "/opt/android-ndk/toolchains/llvm/prebuilt/clang",
  )
}

test "ndk_clang_path_empty" {
  assert_eq(@android.ndk_clang_path(""), "/toolchains/llvm/prebuilt/clang")
}

test "android_sysroot" {
  assert_eq(@android.android_sysroot("/opt/android-ndk"), "/opt/android-ndk/sysroot")
}

test "android_sysroot_empty" {
  assert_eq(@android.android_sysroot(""), "/sysroot")
}

test "min_ndk_version" {
  assert_eq(@android.min_ndk_version(), "r26")
}

test "android_abi_arm64" {
  assert_eq(@android.android_abi(@core.Arch::Arm64), "arm64-v8a")
}

test "android_abi_x86_64" {
  assert_eq(@android.android_abi(@core.Arch::X86_64), "x86_64")
}

test "android_supported_archs_count" {
  assert_eq(@android.android_supported_archs().length(), 2)
}

test "default_android_config_arch" {
  let cfg = @android.default_android_config("/opt/ndk", "output", "mylib")
  assert_eq(cfg.arch, @core.Arch::Arm64)
}

test "default_android_config_api_level" {
  let cfg = @android.default_android_config("/opt/ndk", "output", "mylib")
  assert_eq(cfg.api_level, 24)
}

test "default_android_config_ndk_path" {
  let cfg = @android.default_android_config("/opt/ndk", "output", "mylib")
  assert_eq(cfg.ndk_path, "/opt/ndk")
}

test "default_android_config_output_dir" {
  let cfg = @android.default_android_config("/opt/ndk", "output", "mylib")
  assert_eq(cfg.output_dir, "output")
}

test "default_android_config_output_name" {
  let cfg = @android.default_android_config("/opt/ndk", "output", "mylib")
  assert_eq(cfg.output_name, "mylib")
}

test "android_compile_command_arm64" {
  let cfg = @android.default_android_config("/opt/ndk", "output", "mylib")
  let cmd = @android.android_compile_command(cfg)
  assert_true(cmd.contains("aarch64-linux-android24"))
}

test "android_compile_command_x86_64" {
  let cfg : @android.AndroidCompileConfig = {
    arch: @core.Arch::X86_64,
    api_level: 24,
    ndk_path: "/opt/ndk",
    output_dir: "output",
    output_name: "mylib",
  }
  let cmd = @android.android_compile_command(cfg)
  assert_true(cmd.contains("x86_64-linux-android24"))
}

test "android_compile_command_contains_so" {
  let cfg = @android.default_android_config("/opt/ndk", "output", "mylib")
  let cmd = @android.android_compile_command(cfg)
  assert_true(cmd.contains("libmylib.so"))
}

test "android_compile_command_contains_ndk_clang" {
  let cfg = @android.default_android_config("/opt/ndk", "output", "mylib")
  let cmd = @android.android_compile_command(cfg)
  assert_true(cmd.contains("clang"))
}

test "android_compile_command_contains_target" {
  let cfg = @android.default_android_config("/opt/ndk", "output", "mylib")
  let cmd = @android.android_compile_command(cfg)
  assert_true(cmd.contains("--target="))
}

test "android_compile_config_construction" {
  let cfg : @android.AndroidCompileConfig = {
    arch: @core.Arch::Arm64,
    api_level: 30,
    ndk_path: "/ndk",
    output_dir: "out",
    output_name: "lib",
  }
  assert_eq(cfg.api_level, 30)
}

test "android_compile_command_api_level_30" {
  let cfg : @android.AndroidCompileConfig = {
    arch: @core.Arch::Arm64,
    api_level: 30,
    ndk_path: "/ndk",
    output_dir: "out",
    output_name: "lib",
  }
  let cmd = @android.android_compile_command(cfg)
  assert_true(cmd.contains("aarch64-linux-android30"))
}
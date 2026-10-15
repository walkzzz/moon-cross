test "ohos_platform_id" {
  assert_eq(ohos_platform_id(), "ohos")
}

test "ohos_so_name" {
  assert_eq(ohos_so_name("mylib"), "libmylib.so")
}

test "ohos_so_name_empty" {
  assert_eq(ohos_so_name(""), "lib.so")
}

test "ohos_napi_module_name" {
  assert_eq(ohos_napi_module_name("mylib"), "libmylib.so")
}

test "ohos_napi_module_name_empty" {
  assert_eq(ohos_napi_module_name(""), "lib.so")
}

test "ohos_sdk_path" {
  assert_eq(ohos_sdk_path(), "$OHOS_SDK/native")
}

test "ohos_deveco_project_name" {
  assert_eq(ohos_deveco_project_name("myapp"), "myapp_ohos")
}

test "ohos_deveco_project_name_empty" {
  assert_eq(ohos_deveco_project_name(""), "_ohos")
}

test "ohos_min_api_version" {
  assert_eq(ohos_min_api_version(), 10)
}

test "ohos_supported_archs_count" {
  assert_eq(ohos_supported_archs().length(), 2)
}

test "ohos_supported_archs_arm64" {
  let archs = ohos_supported_archs()
  assert_eq(archs[0], @core.Arch::Arm64)
}

test "ohos_supported_archs_x86_64" {
  let archs = ohos_supported_archs()
  assert_eq(archs[1], @core.Arch::X86_64)
}

test "default_ohos_config_arch" {
  let cfg = default_ohos_config("/sdk", "output", "mylib")
  assert_eq(cfg.arch, @core.Arch::Arm64)
}

test "default_ohos_config_sdk_path" {
  let cfg = default_ohos_config("/sdk", "output", "mylib")
  assert_eq(cfg.sdk_path, "/sdk")
}

test "default_ohos_config_output_dir" {
  let cfg = default_ohos_config("/sdk", "output", "mylib")
  assert_eq(cfg.output_dir, "output")
}

test "default_ohos_config_output_name" {
  let cfg = default_ohos_config("/sdk", "output", "mylib")
  assert_eq(cfg.output_name, "mylib")
}

test "ohos_compile_command_arm64" {
  let cfg = default_ohos_config("/sdk", "output", "mylib")
  let cmd = ohos_compile_command(cfg)
  assert_true(cmd.contains("aarch64-linux-ohos"))
}

test "ohos_compile_command_x86_64" {
  let cfg : OhosCompileConfig = {
    arch: @core.Arch::X86_64,
    sdk_path: "/sdk",
    output_dir: "output",
    output_name: "mylib",
  }
  let cmd = ohos_compile_command(cfg)
  assert_true(cmd.contains("x86_64-linux-ohos"))
}

test "ohos_compile_command_contains_clang" {
  let cfg = default_ohos_config("/sdk", "output", "mylib")
  let cmd = ohos_compile_command(cfg)
  assert_true(cmd.contains("clang"))
}

test "ohos_compile_command_contains_target" {
  let cfg = default_ohos_config("/sdk", "output", "mylib")
  let cmd = ohos_compile_command(cfg)
  assert_true(cmd.contains("--target="))
}

test "ohos_compile_command_contains_so" {
  let cfg = default_ohos_config("/sdk", "output", "mylib")
  let cmd = ohos_compile_command(cfg)
  assert_true(cmd.contains("libmylib.so"))
}

test "ohos_compile_config_construction" {
  let cfg : OhosCompileConfig = {
    arch: @core.Arch::X86_64,
    sdk_path: "/sdk",
    output_dir: "out",
    output_name: "lib",
  }
  assert_eq(cfg.arch, @core.Arch::X86_64)
  assert_eq(cfg.output_name, "lib")
}
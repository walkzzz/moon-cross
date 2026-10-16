test "ohos_platform_id" {
  assert_eq(@ohos.ohos_platform_id(), "ohos")
}

test "ohos_so_name" {
  assert_eq(@ohos.ohos_so_name("mylib"), "libmylib.so")
}

test "ohos_so_name_empty" {
  assert_eq(@ohos.ohos_so_name(""), "lib.so")
}

test "ohos_napi_module_name" {
  assert_eq(@ohos.ohos_napi_module_name("mylib"), "libmylib.so")
}

test "ohos_napi_module_name_empty" {
  assert_eq(@ohos.ohos_napi_module_name(""), "lib.so")
}

test "ohos_sdk_path" {
  assert_eq(@ohos.ohos_sdk_path(), "$OHOS_SDK/native")
}

test "ohos_deveco_project_name" {
  assert_eq(@ohos.ohos_deveco_project_name("myapp"), "myapp_ohos")
}

test "ohos_deveco_project_name_empty" {
  assert_eq(@ohos.ohos_deveco_project_name(""), "_ohos")
}

test "ohos_min_api_version" {
  assert_eq(@ohos.ohos_min_api_version(), 10)
}

test "ohos_supported_archs_count" {
  assert_eq(@ohos.ohos_supported_archs().length(), 2)
}

test "ohos_supported_archs_arm64" {
  let archs = @ohos.ohos_supported_archs()
  assert_eq(archs[0], @core.Arch::Arm64)
}

test "ohos_supported_archs_x86_64" {
  let archs = @ohos.ohos_supported_archs()
  assert_eq(archs[1], @core.Arch::X86_64)
}

test "default_ohos_config_arch" {
  let cfg = @ohos.default_ohos_config("/sdk", "output", "mylib")
  assert_eq(cfg.arch, @core.Arch::Arm64)
}

test "default_ohos_config_sdk_path" {
  let cfg = @ohos.default_ohos_config("/sdk", "output", "mylib")
  assert_eq(cfg.sdk_path, "/sdk")
}

test "default_ohos_config_output_dir" {
  let cfg = @ohos.default_ohos_config("/sdk", "output", "mylib")
  assert_eq(cfg.output_dir, "output")
}

test "default_ohos_config_output_name" {
  let cfg = @ohos.default_ohos_config("/sdk", "output", "mylib")
  assert_eq(cfg.output_name, "mylib")
}

test "ohos_compile_command_arm64" {
  let cfg = @ohos.default_ohos_config("/sdk", "output", "mylib")
  let cmd = @ohos.ohos_compile_command(cfg)
  assert_true(cmd.contains("aarch64-linux-ohos"))
}

test "ohos_compile_command_x86_64" {
  let cfg : @ohos.OhosCompileConfig = {
    arch: @core.Arch::X86_64,
    sdk_path: "/sdk",
    output_dir: "output",
    output_name: "mylib",
  }
  let cmd = @ohos.ohos_compile_command(cfg)
  assert_true(cmd.contains("x86_64-linux-ohos"))
}

test "ohos_compile_command_contains_clang" {
  let cfg = @ohos.default_ohos_config("/sdk", "output", "mylib")
  let cmd = @ohos.ohos_compile_command(cfg)
  assert_true(cmd.contains("clang"))
}

test "ohos_compile_command_contains_target" {
  let cfg = @ohos.default_ohos_config("/sdk", "output", "mylib")
  let cmd = @ohos.ohos_compile_command(cfg)
  assert_true(cmd.contains("--target="))
}

test "ohos_compile_command_contains_so" {
  let cfg = @ohos.default_ohos_config("/sdk", "output", "mylib")
  let cmd = @ohos.ohos_compile_command(cfg)
  assert_true(cmd.contains("libmylib.so"))
}

test "ohos_compile_config_construction" {
  let cfg : @ohos.OhosCompileConfig = {
    arch: @core.Arch::X86_64,
    sdk_path: "/sdk",
    output_dir: "out",
    output_name: "lib",
  }
  assert_eq(cfg.arch, @core.Arch::X86_64)
  assert_eq(cfg.output_name, "lib")
}
test "ohos_hap_name" {
  assert_eq(@ohos.ohos_hap_name("myapp"), "myapp.hap")
}

test "ohos_hsp_name" {
  assert_eq(@ohos.ohos_hsp_name("mymodule"), "mymodule.hsp")
}

test "ohos_stage_model" {
  assert_eq(@ohos.ohos_stage_model(), "stage")
}

test "ohos_bundle_name" {
  assert_eq(@ohos.ohos_bundle_name("myapp"), "com.example.myapp")
}

test "ohos_module_type_entry" {
  assert_eq(@ohos.ohos_module_type(true), "entry")
}

test "ohos_module_type_feature" {
  assert_eq(@ohos.ohos_module_type(false), "feature")
}

test "ohos_build_command" {
  let cmd = @ohos.ohos_build_command("release")
  assert_true(cmd.contains("hvigorw"))
  assert_true(cmd.contains("assembleHap"))
  assert_true(cmd.contains("release"))
}

test "ohos_min_harmony_api" {
  assert_eq(@ohos.ohos_min_harmony_api(), 12)
}

test "ohos_signing_config" {
  let cmd = @ohos.ohos_signing_config("release")
  assert_true(cmd.contains("signHap"))
  assert_true(cmd.contains("release"))
}

test "ohos_oh_package_json5" {
  let content = @ohos.ohos_oh_package_json5("mylib", "1.0.0")
  assert_true(content.contains("mylib"))
  assert_true(content.contains("1.0.0"))
}

test "ohos_build_profile_json5" {
  let content = @ohos.ohos_build_profile_json5("myapp")
  assert_true(content.contains("myapp"))
  assert_true(content.contains("signingConfigs"))
}
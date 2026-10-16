test "linux_platform_id" {
  assert_eq(@linux.linux_platform_id(), "linux")
}

test "linux_so_name" {
  assert_eq(@linux.linux_so_name("mylib"), "libmylib.so")
}

test "linux_so_name_empty" {
  assert_eq(@linux.linux_so_name(""), "lib.so")
}

test "linux_supported_archs_count" {
  assert_eq(@linux.linux_supported_archs().length(), 2)
}

test "linux_supported_archs_arm64" {
  let archs = @linux.linux_supported_archs()
  assert_eq(archs[0], @core.Arch::Arm64)
}

test "linux_supported_archs_x86_64" {
  let archs = @linux.linux_supported_archs()
  assert_eq(archs[1], @core.Arch::X86_64)
}

test "linux_cross_compiler_x86_64" {
  assert_eq(@linux.linux_cross_compiler(@core.Arch::X86_64), "gcc")
}

test "linux_cross_compiler_arm64" {
  assert_eq(@linux.linux_cross_compiler(@core.Arch::Arm64), "aarch64-linux-gnu-gcc")
}

test "linux_dynamic_linker_x86_64" {
  assert_eq(@linux.linux_dynamic_linker(@core.Arch::X86_64), "/lib64/ld-linux-x86-64.so.2")
}

test "linux_dynamic_linker_arm64" {
  assert_eq(@linux.linux_dynamic_linker(@core.Arch::Arm64), "/lib/ld-linux-aarch64.so.1")
}

test "linux_pkg_config_command" {
  let cmd = @linux.linux_pkg_config_command("zlib")
  assert_true(cmd.contains("pkg-config"))
  assert_true(cmd.contains("zlib"))
}

test "linux_min_glibc_version" {
  assert_eq(@linux.linux_min_glibc_version(), "2.17")
}

test "default_linux_config_arch" {
  let cfg = @linux.default_linux_config("output", "mylib")
  assert_eq(cfg.arch, @core.Arch::X86_64)
}

test "default_linux_config_output_dir" {
  let cfg = @linux.default_linux_config("output", "mylib")
  assert_eq(cfg.output_dir, "output")
}

test "default_linux_config_output_name" {
  let cfg = @linux.default_linux_config("output", "mylib")
  assert_eq(cfg.output_name, "mylib")
}

test "default_linux_config_use_static" {
  let cfg = @linux.default_linux_config("output", "mylib")
  assert_eq(cfg.use_static, false)
}

test "linux_compile_command_x86_64" {
  let cfg = @linux.default_linux_config("output", "mylib")
  let cmd = @linux.linux_compile_command(cfg)
  assert_true(cmd.contains("gcc"))
  assert_true(cmd.contains("-shared"))
  assert_true(cmd.contains("-fPIC"))
  assert_true(cmd.contains("libmylib.so"))
}

test "linux_compile_command_arm64" {
  let cfg : @linux.LinuxCompileConfig = {
    arch: @core.Arch::Arm64,
    output_dir: "output",
    output_name: "mylib",
    use_static: false,
  }
  let cmd = @linux.linux_compile_command(cfg)
  assert_true(cmd.contains("aarch64-linux-gnu-gcc"))
  assert_true(cmd.contains("libmylib.so"))
}

test "linux_compile_command_static" {
  let cfg : @linux.LinuxCompileConfig = {
    arch: @core.Arch::X86_64,
    output_dir: "output",
    output_name: "mylib",
    use_static: true,
  }
  let cmd = @linux.linux_compile_command(cfg)
  assert_true(cmd.contains("-static"))
}

test "linux_compile_command_no_static" {
  let cfg = @linux.default_linux_config("output", "mylib")
  let cmd = @linux.linux_compile_command(cfg)
  assert_false(cmd.contains("-static"))
}

test "linux_version" {
  let v = @linux.linux_version()
  assert_true(v.contains("linux"))
}

test "linux_compile_config_construction" {
  let cfg : @linux.LinuxCompileConfig = {
    arch: @core.Arch::Arm64,
    output_dir: "out",
    output_name: "lib",
    use_static: true,
  }
  assert_eq(cfg.arch, @core.Arch::Arm64)
  assert_eq(cfg.output_name, "lib")
  assert_eq(cfg.use_static, true)
}
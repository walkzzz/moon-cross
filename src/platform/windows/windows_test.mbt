test "windows_platform_id" {
  assert_eq(windows_platform_id(), "windows")
}

test "windows_compile_command_x86_64" {
  let cfg = default_windows_config("output", "mylib")
  let cmd = windows_compile_command(cfg)
  assert_true(cmd.contains("x86_64-pc-windows-msvc"))
}

test "windows_compile_command_output" {
  let cfg = default_windows_config("output", "mylib")
  let cmd = windows_compile_command(cfg)
  assert_true(cmd.contains("mylib.dll"))
}
///|
/// CLI 命令与解析逻辑测试（白盒） | CLI command and parsing logic tests (white-box)

///|
test "parse_arg_returns_value_when_flag_present" {
  let args = ["cmd", "--name", "demo", "--platform", "linux"]
  assert_eq(parse_arg(args, "--name", "default"), "demo")
  assert_eq(parse_arg(args, "--platform", "all"), "linux")
}

///|
test "parse_arg_returns_default_when_flag_missing" {
  let args = ["cmd"]
  assert_eq(parse_arg(args, "--name", "default"), "default")
}

///|
test "has_flag_detects_boolean_flags" {
  assert_true(has_flag(["build", "--script"], "--script"))
  assert_false(has_flag(["build"], "--script"))
}

///|
test "format_help_lists_all_commands" {
  let help = format_help()
  for
    cmd in [
      "build", "check", "plan", "init", "sync", "doctor", "publish", "wizard", "version",
      "help",
    ] {
    assert_true(help.contains(cmd))
  }
}

///|
test "format_version_contains_cli_version" {
  assert_true(format_version().contains(cli_version()))
}

///|
async test "run_cli_dispatches_help" {
  let out = run_cli(["help"]) catch { _ => "" }
  assert_true(out.contains("Usage: moon-cross"))
}

///|
async test "run_cli_dispatches_version" {
  let out = run_cli(["version"]) catch { _ => "" }
  assert_true(out.contains(cli_version()))
}

///|
async test "run_cli_rejects_unknown_command" {
  let out = run_cli(["frobnicate"]) catch { _ => "" }
  assert_true(out.contains("Unknown command: frobnicate"))
}

///|
test "validate_config_accepts_valid_config" {
  let json =
    #|{
    #|"version": 1,
    #|"module_path": "./demo",
    #|"package_name": "walkzzz/demo",
    #|"targets": ["linux", "windows"],
    #|"functions": [
    #|  { "name": "add", "params": [{ "name": "a", "typ": "Int" }, { "name": "b", "typ": "Int" }], "return_type": "Int" }
    #|],
    #|"types": []
    #|}
  let cfg = @config.parse_config(json)
  assert_true(validate_config(cfg).is_empty())
  assert_eq(cfg.functions.length(), 1)
  assert_eq(cfg.targets.length(), 2)
}

///|
test "validate_config_flags_duplicate_and_unknown_types" {
  let json =
    #|{
    #|"version": 1,
    #|"module_path": "./demo",
    #|"package_name": "walkzzz/demo",
    #|"targets": ["linux"],
    #|"functions": [
    #|  { "name": "dup", "params": [], "return_type": "Int" },
    #|  { "name": "dup", "params": [{ "name": "x", "typ": "Wibble" }], "return_type": "Wobble" }
    #|],
    #|"types": []
    #|}
  let cfg = @config.parse_config(json)
  let problems = validate_config(cfg)
  assert_eq(problems.length(), 3)
}

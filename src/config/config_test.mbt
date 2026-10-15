test "config_version" {
  assert_eq(@config.config_version(), 1)
}

test "default_config_version" {
  let cfg = @config.default_config("my-lib")
  assert_eq(cfg.version, 1)
}

test "default_config_module_path" {
  let cfg = @config.default_config("my-lib")
  assert_eq(cfg.module_path, "./my-lib")
}

test "default_config_package_name" {
  let cfg = @config.default_config("my-lib")
  assert_eq(cfg.package_name, "walkzzz/my-lib")
}

test "default_config_targets_count" {
  let cfg = @config.default_config("my-lib")
  assert_eq(cfg.targets.length(), 4)
}

test "default_config_empty_functions" {
  let cfg = @config.default_config("my-lib")
  assert_eq(cfg.functions.length(), 0)
}

test "default_config_empty_types" {
  let cfg = @config.default_config("my-lib")
  assert_eq(cfg.types.length(), 0)
}

test "export_param_construction" {
  let p : @config.ExportParam = { name: "data", typ: "Bytes" }
  assert_eq(p.name, "data")
  assert_eq(p.typ, "Bytes")
}
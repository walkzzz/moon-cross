test "toml_module_name" {
  assert_eq(@integration.toml_module_name(), "bobzhang_toml")
}

test "toml_version" {
  assert_eq(@integration.toml_version(), "0.4.3")
}

test "toml_function_count" {
  assert_eq(@integration.toml_function_count(), 10)
}

test "toml_type_count" {
  assert_eq(@integration.toml_type_count(), 2)
}

test "toml_target_count" {
  assert_eq(@integration.toml_target_count(), 4)
}

test "toml_has_parse" {
  assert_true(has_fn(@integration.toml_export_functions(), "toml_parse"))
}

test "toml_has_to_string" {
  assert_true(has_fn(@integration.toml_export_functions(), "toml_to_string"))
}

test "toml_has_get" {
  assert_true(has_fn(@integration.toml_export_functions(), "toml_get"))
}

test "toml_has_get_string" {
  assert_true(has_fn(@integration.toml_export_functions(), "toml_get_string"))
}

test "toml_has_get_int" {
  assert_true(has_fn(@integration.toml_export_functions(), "toml_get_int"))
}

test "toml_has_value_type" {
  assert_true(has_fn(@integration.toml_export_functions(), "toml_value_type"))
}

test "toml_parse_return_type" {
  match find_fn(@integration.toml_export_functions(), "toml_parse") {
    Some(f) => assert_eq(f.return_type, "TomlValue")
    None => assert_true(false)
  }
}

test "toml_parse_param" {
  match find_fn(@integration.toml_export_functions(), "toml_parse") {
    Some(f) => {
      assert_eq(f.params.length(), 1)
      assert_eq(f.params[0].name, "input")
      assert_eq(f.params[0].typ, "String")
    }
    None => assert_true(false)
  }
}

test "toml_get_params" {
  match find_fn(@integration.toml_export_functions(), "toml_get") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "table")
      assert_eq(f.params[0].typ, "TomlValue")
      assert_eq(f.params[1].name, "key")
      assert_eq(f.params[1].typ, "String")
    }
    None => assert_true(false)
  }
}

test "toml_get_int_return_type" {
  match find_fn(@integration.toml_export_functions(), "toml_get_int") {
    Some(f) => assert_eq(f.return_type, "Int")
    None => assert_true(false)
  }
}

test "toml_get_double_return_type" {
  match find_fn(@integration.toml_export_functions(), "toml_get_double") {
    Some(f) => assert_eq(f.return_type, "Double")
    None => assert_true(false)
  }
}

test "toml_get_bool_return_type" {
  match find_fn(@integration.toml_export_functions(), "toml_get_bool") {
    Some(f) => assert_eq(f.return_type, "Bool")
    None => assert_true(false)
  }
}

test "toml_cross_config_version" {
  let cfg = @integration.toml_cross_config()
  assert_eq(cfg.version, 1)
}

test "toml_cross_config_module_path" {
  let cfg = @integration.toml_cross_config()
  assert_eq(cfg.module_path, "bobzhang/toml")
}

test "toml_cross_config_package_name" {
  let cfg = @integration.toml_cross_config()
  assert_eq(cfg.package_name, "bobzhang/toml")
}

test "toml_cross_config_targets" {
  let cfg = @integration.toml_cross_config()
  assert_eq(cfg.targets.length(), 4)
}

test "toml_cross_config_functions" {
  let cfg = @integration.toml_cross_config()
  assert_eq(cfg.functions.length(), 10)
}

test "toml_cross_config_types" {
  let cfg = @integration.toml_cross_config()
  assert_eq(cfg.types.length(), 2)
}

test "toml_has_toml_value_type" {
  assert_true(has_ty(@integration.toml_export_types(), "TomlValue"))
}

test "toml_has_toml_error_type" {
  assert_true(has_ty(@integration.toml_export_types(), "TomlError"))
}

test "toml_c_header_not_empty" {
  let header = @integration.toml_c_header()
  assert_true(header.length() > 0)
}

test "toml_c_header_contains_module" {
  let header = @integration.toml_c_header()
  assert_true(header.contains("bobzhang_toml"))
}

test "toml_c_header_contains_guard" {
  let header = @integration.toml_c_header()
  assert_true(header.contains("#ifndef"))
}

test "toml_c_export_macro_contains_win32" {
  let export_macro = @integration.toml_c_export_macro()
  assert_true(export_macro.contains("_WIN32"))
}

test "toml_platform_specs_count" {
  assert_eq(@integration.toml_platform_specs().length(), 4)
}

test "toml_ffi_bindings_count" {
  assert_eq(@integration.toml_ffi_bindings().length(), 4)
}

test "toml_windows_command_contains_dll" {
  let cmd = @integration.toml_windows_compile_command()
  assert_true(cmd.contains(".dll"))
}

test "toml_windows_command_contains_module" {
  let cmd = @integration.toml_windows_compile_command()
  assert_true(cmd.contains("bobzhang_toml"))
}

test "toml_android_command_contains_so" {
  let cmd = @integration.toml_android_compile_command()
  assert_true(cmd.contains(".so"))
}

test "toml_android_command_contains_module" {
  let cmd = @integration.toml_android_compile_command()
  assert_true(cmd.contains("bobzhang_toml"))
}

test "toml_ios_command_contains_dylib" {
  let cmd = @integration.toml_ios_compile_command()
  assert_true(cmd.contains(".dylib"))
}

test "toml_ios_command_contains_module" {
  let cmd = @integration.toml_ios_compile_command()
  assert_true(cmd.contains("bobzhang_toml"))
}

test "toml_ohos_command_contains_so" {
  let cmd = @integration.toml_ohos_compile_command()
  assert_true(cmd.contains(".so"))
}

test "toml_ohos_command_contains_module" {
  let cmd = @integration.toml_ohos_compile_command()
  assert_true(cmd.contains("bobzhang_toml"))
}

test "run_toml_pipeline_config" {
  let result = @integration.run_toml_pipeline()
  assert_eq(result.config.functions.length(), 10)
  assert_eq(result.config.types.length(), 2)
}

test "run_toml_pipeline_c_header" {
  let result = @integration.run_toml_pipeline()
  assert_true(result.c_header.contains("bobzhang_toml"))
}

test "run_toml_pipeline_platform_specs" {
  let result = @integration.run_toml_pipeline()
  assert_eq(result.platform_specs.length(), 4)
}

test "run_toml_pipeline_ffi_bindings" {
  let result = @integration.run_toml_pipeline()
  assert_eq(result.ffi_bindings.length(), 4)
}

test "run_toml_pipeline_all_commands" {
  let result = @integration.run_toml_pipeline()
  assert_true(result.windows_command.contains(".dll"))
  assert_true(result.android_command.contains(".so"))
  assert_true(result.ios_command.contains(".dylib"))
  assert_true(result.ohos_command.contains(".so"))
}

test "validate_toml_pipeline_success" {
  let result = @integration.run_toml_pipeline()
  assert_true(@integration.validate_toml_pipeline(result))
}

test "toml_pipeline_config_module_path" {
  let result = @integration.run_toml_pipeline()
  assert_eq(result.config.module_path, "bobzhang/toml")
}
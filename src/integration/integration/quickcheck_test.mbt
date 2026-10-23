test "quickcheck_module_name" {
  assert_eq(@integration.quickcheck_module_name(), "moonbitlang_quickcheck")
}

test "quickcheck_version" {
  assert_eq(@integration.quickcheck_version(), "0.15.0")
}

test "quickcheck_function_count" {
  assert_eq(@integration.quickcheck_function_count(), 10)
}

test "quickcheck_type_count" {
  assert_eq(@integration.quickcheck_type_count(), 4)
}

test "quickcheck_target_count" {
  assert_eq(@integration.quickcheck_target_count(), 5)
}

test "quickcheck_has_check" {
  assert_true(has_fn(@integration.quickcheck_export_functions(), "quickcheck_check"))
}

test "quickcheck_has_for_all_int" {
  assert_true(has_fn(@integration.quickcheck_export_functions(), "quickcheck_for_all_int"))
}

test "quickcheck_has_for_all_bool" {
  assert_true(has_fn(@integration.quickcheck_export_functions(), "quickcheck_for_all_bool"))
}

test "quickcheck_has_for_all_string" {
  assert_true(has_fn(@integration.quickcheck_export_functions(), "quickcheck_for_all_string"))
}

test "quickcheck_has_arbitrary_int" {
  assert_true(has_fn(@integration.quickcheck_export_functions(), "quickcheck_arbitrary_int"))
}

test "quickcheck_has_with_seed" {
  assert_true(has_fn(@integration.quickcheck_export_functions(), "quickcheck_with_seed"))
}

test "quickcheck_has_minimize" {
  assert_true(has_fn(@integration.quickcheck_export_functions(), "quickcheck_minimize"))
}

test "quickcheck_check_return_type" {
  match find_fn(@integration.quickcheck_export_functions(), "quickcheck_check") {
    Some(f) => assert_eq(f.return_type, "QuickCheckResult")
    None => assert_true(false)
  }
}

test "quickcheck_check_params" {
  match find_fn(@integration.quickcheck_export_functions(), "quickcheck_check") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "property")
      assert_eq(f.params[0].typ, "Property")
      assert_eq(f.params[1].name, "iterations")
      assert_eq(f.params[1].typ, "Int")
    }
    None => assert_true(false)
  }
}

test "quickcheck_arbitrary_int_return_type" {
  match find_fn(@integration.quickcheck_export_functions(), "quickcheck_arbitrary_int") {
    Some(f) => assert_eq(f.return_type, "Int")
    None => assert_true(false)
  }
}

test "quickcheck_arbitrary_bool_return_type" {
  match find_fn(@integration.quickcheck_export_functions(), "quickcheck_arbitrary_bool") {
    Some(f) => assert_eq(f.return_type, "Bool")
    None => assert_true(false)
  }
}

test "quickcheck_arbitrary_string_params" {
  match find_fn(@integration.quickcheck_export_functions(), "quickcheck_arbitrary_string") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "seed")
      assert_eq(f.params[0].typ, "UInt")
      assert_eq(f.params[1].name, "max_len")
      assert_eq(f.params[1].typ, "Int")
    }
    None => assert_true(false)
  }
}

test "quickcheck_cross_config_version" {
  let cfg = @integration.quickcheck_cross_config()
  assert_eq(cfg.version, 1)
}

test "quickcheck_cross_config_module_path" {
  let cfg = @integration.quickcheck_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/quickcheck")
}

test "quickcheck_cross_config_package_name" {
  let cfg = @integration.quickcheck_cross_config()
  assert_eq(cfg.package_name, "moonbitlang/quickcheck")
}

test "quickcheck_cross_config_targets" {
  let cfg = @integration.quickcheck_cross_config()
  assert_eq(cfg.targets.length(), 5)
}

test "quickcheck_cross_config_functions" {
  let cfg = @integration.quickcheck_cross_config()
  assert_eq(cfg.functions.length(), 10)
}

test "quickcheck_cross_config_types" {
  let cfg = @integration.quickcheck_cross_config()
  assert_eq(cfg.types.length(), 4)
}

test "quickcheck_has_property_type" {
  assert_true(has_ty(@integration.quickcheck_export_types(), "Property"))
}

test "quickcheck_has_arbitrary_type" {
  assert_true(has_ty(@integration.quickcheck_export_types(), "Arbitrary"))
}

test "quickcheck_has_result_type" {
  assert_true(has_ty(@integration.quickcheck_export_types(), "QuickCheckResult"))
}

test "quickcheck_has_error_type" {
  assert_true(has_ty(@integration.quickcheck_export_types(), "QuickCheckError"))
}

test "quickcheck_c_header_not_empty" {
  let header = @integration.quickcheck_c_header()
  assert_true(header.length() > 0)
}

test "quickcheck_c_header_contains_module" {
  let header = @integration.quickcheck_c_header()
  assert_true(header.contains("moonbitlang_quickcheck"))
}

test "quickcheck_c_header_contains_guard" {
  let header = @integration.quickcheck_c_header()
  assert_true(header.contains("#ifndef"))
}

test "quickcheck_c_export_macro_contains_win32" {
  let export_macro = @integration.quickcheck_c_export_macro()
  assert_true(export_macro.contains("_WIN32"))
}

test "quickcheck_platform_specs_count" {
  assert_eq(@integration.quickcheck_platform_specs().length(), 5)
}

test "quickcheck_ffi_bindings_count" {
  assert_eq(@integration.quickcheck_ffi_bindings().length(), 5)
}

test "quickcheck_windows_command_contains_dll" {
  let cmd = @integration.quickcheck_windows_compile_command()
  assert_true(cmd.contains(".dll"))
}

test "quickcheck_windows_command_contains_module" {
  let cmd = @integration.quickcheck_windows_compile_command()
  assert_true(cmd.contains("moonbitlang_quickcheck"))
}

test "quickcheck_android_command_contains_so" {
  let cmd = @integration.quickcheck_android_compile_command()
  assert_true(cmd.contains(".so"))
}

test "quickcheck_android_command_contains_module" {
  let cmd = @integration.quickcheck_android_compile_command()
  assert_true(cmd.contains("moonbitlang_quickcheck"))
}

test "quickcheck_ios_command_contains_dylib" {
  let cmd = @integration.quickcheck_ios_compile_command()
  assert_true(cmd.contains(".dylib"))
}

test "quickcheck_ios_command_contains_module" {
  let cmd = @integration.quickcheck_ios_compile_command()
  assert_true(cmd.contains("moonbitlang_quickcheck"))
}

test "quickcheck_ohos_command_contains_so" {
  let cmd = @integration.quickcheck_ohos_compile_command()
  assert_true(cmd.contains(".so"))
}

test "quickcheck_ohos_command_contains_module" {
  let cmd = @integration.quickcheck_ohos_compile_command()
  assert_true(cmd.contains("moonbitlang_quickcheck"))
}

test "run_quickcheck_pipeline_config" {
  let result = @integration.run_quickcheck_pipeline()
  assert_eq(result.config.functions.length(), 10)
  assert_eq(result.config.types.length(), 4)
}

test "run_quickcheck_pipeline_c_header" {
  let result = @integration.run_quickcheck_pipeline()
  assert_true(result.c_header.contains("moonbitlang_quickcheck"))
}

test "run_quickcheck_pipeline_platform_specs" {
  let result = @integration.run_quickcheck_pipeline()
  assert_eq(result.platform_specs.length(), 5)
}

test "run_quickcheck_pipeline_ffi_bindings" {
  let result = @integration.run_quickcheck_pipeline()
  assert_eq(result.ffi_bindings.length(), 5)
}

test "run_quickcheck_pipeline_all_commands" {
  let result = @integration.run_quickcheck_pipeline()
  assert_true(result.windows_command.contains(".dll"))
  assert_true(result.android_command.contains(".so"))
  assert_true(result.ios_command.contains(".dylib"))
  assert_true(result.ohos_command.contains(".so"))
}

test "validate_quickcheck_pipeline_success" {
  let result = @integration.run_quickcheck_pipeline()
  assert_true(@integration.validate_quickcheck_pipeline(result))
}

test "quickcheck_pipeline_config_module_path" {
  let result = @integration.run_quickcheck_pipeline()
  assert_eq(result.config.module_path, "moonbitlang/quickcheck")
}
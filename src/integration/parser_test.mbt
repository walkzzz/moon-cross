test "parser_module_name" {
  assert_eq(@integration.parser_module_name(), "moonbitlang_parser")
}

test "parser_version" {
  assert_eq(@integration.parser_version(), "0.4.4")
}

test "parser_function_count" {
  assert_eq(@integration.parser_function_count(), 10)
}

test "parser_type_count" {
  assert_eq(@integration.parser_type_count(), 4)
}

test "parser_target_count" {
  assert_eq(@integration.parser_target_count(), 5)
}

test "parser_has_parse" {
  assert_true(has_fn(@integration.parser_export_functions(), "parser_parse"))
}

test "parser_has_tokenize" {
  assert_true(has_fn(@integration.parser_export_functions(), "parser_tokenize"))
}

test "parser_has_to_string" {
  assert_true(has_fn(@integration.parser_export_functions(), "parser_to_string"))
}

test "parser_has_ast_kind" {
  assert_true(has_fn(@integration.parser_export_functions(), "parser_ast_kind"))
}

test "parser_has_token_kind" {
  assert_true(has_fn(@integration.parser_export_functions(), "parser_token_kind"))
}

test "parser_has_format" {
  assert_true(has_fn(@integration.parser_export_functions(), "parser_format"))
}

test "parser_has_comments" {
  assert_true(has_fn(@integration.parser_export_functions(), "parser_comments"))
}

test "parser_parse_return_type" {
  match find_fn(@integration.parser_export_functions(), "parser_parse") {
    Some(f) => assert_eq(f.return_type, "Ast")
    None => assert_true(false)
  }
}

test "parser_parse_param" {
  match find_fn(@integration.parser_export_functions(), "parser_parse") {
    Some(f) => {
      assert_eq(f.params.length(), 1)
      assert_eq(f.params[0].name, "source")
      assert_eq(f.params[0].typ, "String")
    }
    None => assert_true(false)
  }
}

test "parser_tokenize_return_type" {
  match find_fn(@integration.parser_export_functions(), "parser_tokenize") {
    Some(f) => assert_eq(f.return_type, "Array")
    None => assert_true(false)
  }
}

test "parser_token_position_return_type" {
  match find_fn(@integration.parser_export_functions(), "parser_token_position") {
    Some(f) => assert_eq(f.return_type, "Span")
    None => assert_true(false)
  }
}

test "parser_ast_children_return_type" {
  match find_fn(@integration.parser_export_functions(), "parser_ast_children") {
    Some(f) => assert_eq(f.return_type, "Array")
    None => assert_true(false)
  }
}

test "parser_cross_config_version" {
  let cfg = @integration.parser_cross_config()
  assert_eq(cfg.version, 1)
}

test "parser_cross_config_module_path" {
  let cfg = @integration.parser_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/parser")
}

test "parser_cross_config_package_name" {
  let cfg = @integration.parser_cross_config()
  assert_eq(cfg.package_name, "moonbitlang/parser")
}

test "parser_cross_config_targets" {
  let cfg = @integration.parser_cross_config()
  assert_eq(cfg.targets.length(), 5)
}

test "parser_cross_config_functions" {
  let cfg = @integration.parser_cross_config()
  assert_eq(cfg.functions.length(), 10)
}

test "parser_cross_config_types" {
  let cfg = @integration.parser_cross_config()
  assert_eq(cfg.types.length(), 4)
}

test "parser_has_token_type" {
  assert_true(has_ty(@integration.parser_export_types(), "Token"))
}

test "parser_has_ast_type" {
  assert_true(has_ty(@integration.parser_export_types(), "Ast"))
}

test "parser_has_span_type" {
  assert_true(has_ty(@integration.parser_export_types(), "Span"))
}

test "parser_has_parse_error_type" {
  assert_true(has_ty(@integration.parser_export_types(), "ParseError"))
}

test "parser_c_header_not_empty" {
  let header = @integration.parser_c_header()
  assert_true(header.length() > 0)
}

test "parser_c_header_contains_module" {
  let header = @integration.parser_c_header()
  assert_true(header.contains("moonbitlang_parser"))
}

test "parser_c_header_contains_guard" {
  let header = @integration.parser_c_header()
  assert_true(header.contains("#ifndef"))
}

test "parser_c_export_macro_contains_win32" {
  let export_macro = @integration.parser_c_export_macro()
  assert_true(export_macro.contains("_WIN32"))
}

test "parser_platform_specs_count" {
  assert_eq(@integration.parser_platform_specs().length(), 5)
}

test "parser_ffi_bindings_count" {
  assert_eq(@integration.parser_ffi_bindings().length(), 5)
}

test "parser_windows_command_contains_dll" {
  let cmd = @integration.parser_windows_compile_command()
  assert_true(cmd.contains(".dll"))
}

test "parser_windows_command_contains_module" {
  let cmd = @integration.parser_windows_compile_command()
  assert_true(cmd.contains("moonbitlang_parser"))
}

test "parser_android_command_contains_so" {
  let cmd = @integration.parser_android_compile_command()
  assert_true(cmd.contains(".so"))
}

test "parser_android_command_contains_module" {
  let cmd = @integration.parser_android_compile_command()
  assert_true(cmd.contains("moonbitlang_parser"))
}

test "parser_ios_command_contains_dylib" {
  let cmd = @integration.parser_ios_compile_command()
  assert_true(cmd.contains(".dylib"))
}

test "parser_ios_command_contains_module" {
  let cmd = @integration.parser_ios_compile_command()
  assert_true(cmd.contains("moonbitlang_parser"))
}

test "parser_ohos_command_contains_so" {
  let cmd = @integration.parser_ohos_compile_command()
  assert_true(cmd.contains(".so"))
}

test "parser_ohos_command_contains_module" {
  let cmd = @integration.parser_ohos_compile_command()
  assert_true(cmd.contains("moonbitlang_parser"))
}

test "run_parser_pipeline_config" {
  let result = @integration.run_parser_pipeline()
  assert_eq(result.config.functions.length(), 10)
  assert_eq(result.config.types.length(), 4)
}

test "run_parser_pipeline_c_header" {
  let result = @integration.run_parser_pipeline()
  assert_true(result.c_header.contains("moonbitlang_parser"))
}

test "run_parser_pipeline_platform_specs" {
  let result = @integration.run_parser_pipeline()
  assert_eq(result.platform_specs.length(), 5)
}

test "run_parser_pipeline_ffi_bindings" {
  let result = @integration.run_parser_pipeline()
  assert_eq(result.ffi_bindings.length(), 5)
}

test "run_parser_pipeline_all_commands" {
  let result = @integration.run_parser_pipeline()
  assert_true(result.windows_command.contains(".dll"))
  assert_true(result.android_command.contains(".so"))
  assert_true(result.ios_command.contains(".dylib"))
  assert_true(result.ohos_command.contains(".so"))
}

test "validate_parser_pipeline_success" {
  let result = @integration.run_parser_pipeline()
  assert_true(@integration.validate_parser_pipeline(result))
}

test "parser_pipeline_config_module_path" {
  let result = @integration.run_parser_pipeline()
  assert_eq(result.config.module_path, "moonbitlang/parser")
}
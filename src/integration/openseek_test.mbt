fn has_fn(
  fns : Array[@config.ExportFunction],
  name : String,
) -> Bool {
  let mut found = false
  for i in 0..<fns.length() {
    if fns[i].name == name {
      found = true
    }
  }
  found
}

fn find_fn(
  fns : Array[@config.ExportFunction],
  name : String,
) -> @config.ExportFunction? {
  for i in 0..<fns.length() {
    if fns[i].name == name {
      return Some(fns[i])
    }
  }
  None
}

fn has_ty(
  types : Array[@config.ExportType],
  name : String,
) -> Bool {
  let mut found = false
  for i in 0..<types.length() {
    if types[i].name == name {
      found = true
    }
  }
  found
}

test "openseek_module_name" {
  assert_eq(@integration.openseek_module_name(), "moonbitlang_openseek")
}

test "openseek_version" {
  assert_eq(@integration.openseek_version(), "latest")
}

test "openseek_function_count" {
  assert_eq(@integration.openseek_function_count(), 8)
}

test "openseek_type_count" {
  assert_eq(@integration.openseek_type_count(), 5)
}

test "openseek_target_count" {
  assert_eq(@integration.openseek_target_count(), 5)
}

test "openseek_has_chat_message_create" {
  assert_true(has_fn(@integration.openseek_export_functions(), "chat_message_create"))
}

test "openseek_has_tool_definition_create" {
  assert_true(has_fn(@integration.openseek_export_functions(), "tool_definition_create"))
}

test "openseek_has_chat_response_decode" {
  assert_true(has_fn(@integration.openseek_export_functions(), "chat_response_decode"))
}

test "openseek_has_model_from_string" {
  assert_true(has_fn(@integration.openseek_export_functions(), "model_from_string"))
}

test "openseek_has_role_from_string" {
  assert_true(has_fn(@integration.openseek_export_functions(), "role_from_string"))
}

test "openseek_chat_message_create_return_type" {
  match find_fn(@integration.openseek_export_functions(), "chat_message_create") {
    Some(f) => assert_eq(f.return_type, "ChatMessage")
    None => assert_true(false)
  }
}

test "openseek_chat_message_create_params" {
  match find_fn(@integration.openseek_export_functions(), "chat_message_create") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "role")
      assert_eq(f.params[0].typ, "String")
      assert_eq(f.params[1].name, "content")
      assert_eq(f.params[1].typ, "String")
    }
    None => assert_true(false)
  }
}

test "openseek_tool_definition_create_params" {
  match find_fn(@integration.openseek_export_functions(), "tool_definition_create") {
    Some(f) => {
      assert_eq(f.params.length(), 3)
      assert_eq(f.params[0].name, "name")
      assert_eq(f.params[1].name, "description")
      assert_eq(f.params[2].name, "parameters")
    }
    None => assert_true(false)
  }
}

test "openseek_chat_response_decode_return" {
  match find_fn(@integration.openseek_export_functions(), "chat_response_decode") {
    Some(f) => assert_eq(f.return_type, "ChatResponse")
    None => assert_true(false)
  }
}

test "openseek_cross_config_version" {
  let cfg = @integration.openseek_cross_config()
  assert_eq(cfg.version, 1)
}

test "openseek_cross_config_module_path" {
  let cfg = @integration.openseek_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/openseek/deepseek")
}

test "openseek_cross_config_package_name" {
  let cfg = @integration.openseek_cross_config()
  assert_eq(cfg.package_name, "moonbitlang/openseek")
}

test "openseek_cross_config_targets" {
  let cfg = @integration.openseek_cross_config()
  assert_eq(cfg.targets.length(), 5)
}

test "openseek_cross_config_functions" {
  let cfg = @integration.openseek_cross_config()
  assert_eq(cfg.functions.length(), 8)
}

test "openseek_cross_config_types" {
  let cfg = @integration.openseek_cross_config()
  assert_eq(cfg.types.length(), 5)
}

test "openseek_has_model_type" {
  assert_true(has_ty(@integration.openseek_export_types(), "Model"))
}

test "openseek_has_role_type" {
  assert_true(has_ty(@integration.openseek_export_types(), "Role"))
}

test "openseek_has_chat_message_type" {
  assert_true(has_ty(@integration.openseek_export_types(), "ChatMessage"))
}

test "openseek_has_tool_definition_type" {
  assert_true(has_ty(@integration.openseek_export_types(), "ToolDefinition"))
}

test "openseek_has_chat_response_type" {
  assert_true(has_ty(@integration.openseek_export_types(), "ChatResponse"))
}

test "openseek_c_header_not_empty" {
  let header = @integration.openseek_c_header()
  assert_true(header.length() > 0)
}

test "openseek_c_header_contains_module" {
  let header = @integration.openseek_c_header()
  assert_true(header.contains("moonbitlang_openseek"))
}

test "openseek_c_header_contains_guard" {
  let header = @integration.openseek_c_header()
  assert_true(header.contains("#ifndef"))
}

test "openseek_c_export_macro_contains_win32" {
  let export_macro = @integration.openseek_c_export_macro()
  assert_true(export_macro.contains("_WIN32"))
}

test "openseek_platform_specs_count" {
  assert_eq(@integration.openseek_platform_specs().length(), 5)
}

test "openseek_ffi_bindings_count" {
  assert_eq(@integration.openseek_ffi_bindings().length(), 5)
}

test "openseek_windows_command_contains_dll" {
  let cmd = @integration.openseek_windows_compile_command()
  assert_true(cmd.contains(".dll"))
}

test "openseek_windows_command_contains_module" {
  let cmd = @integration.openseek_windows_compile_command()
  assert_true(cmd.contains("moonbitlang_openseek"))
}

test "openseek_android_command_contains_so" {
  let cmd = @integration.openseek_android_compile_command()
  assert_true(cmd.contains(".so"))
}

test "openseek_android_command_contains_module" {
  let cmd = @integration.openseek_android_compile_command()
  assert_true(cmd.contains("moonbitlang_openseek"))
}

test "openseek_ios_command_contains_dylib" {
  let cmd = @integration.openseek_ios_compile_command()
  assert_true(cmd.contains(".dylib"))
}

test "openseek_ios_command_contains_module" {
  let cmd = @integration.openseek_ios_compile_command()
  assert_true(cmd.contains("moonbitlang_openseek"))
}

test "openseek_ohos_command_contains_so" {
  let cmd = @integration.openseek_ohos_compile_command()
  assert_true(cmd.contains(".so"))
}

test "openseek_ohos_command_contains_module" {
  let cmd = @integration.openseek_ohos_compile_command()
  assert_true(cmd.contains("moonbitlang_openseek"))
}

test "run_openseek_pipeline_config" {
  let result = @integration.run_openseek_pipeline()
  assert_eq(result.config.functions.length(), 8)
  assert_eq(result.config.types.length(), 5)
}

test "run_openseek_pipeline_c_header" {
  let result = @integration.run_openseek_pipeline()
  assert_true(result.c_header.contains("moonbitlang_openseek"))
}

test "run_openseek_pipeline_platform_specs" {
  let result = @integration.run_openseek_pipeline()
  assert_eq(result.platform_specs.length(), 5)
}

test "run_openseek_pipeline_ffi_bindings" {
  let result = @integration.run_openseek_pipeline()
  assert_eq(result.ffi_bindings.length(), 5)
}

test "run_openseek_pipeline_all_commands" {
  let result = @integration.run_openseek_pipeline()
  assert_true(result.windows_command.contains(".dll"))
  assert_true(result.android_command.contains(".so"))
  assert_true(result.ios_command.contains(".dylib"))
  assert_true(result.ohos_command.contains(".so"))
}

test "validate_openseek_pipeline_success" {
  let result = @integration.run_openseek_pipeline()
  assert_true(@integration.validate_openseek_pipeline(result))
}

test "openseek_pipeline_config_module_path" {
  let result = @integration.run_openseek_pipeline()
  assert_eq(result.config.module_path, "moonbitlang/openseek/deepseek")
}

test "openseek_pipeline_config_package_name" {
  let result = @integration.run_openseek_pipeline()
  assert_eq(result.config.package_name, "moonbitlang/openseek")
}
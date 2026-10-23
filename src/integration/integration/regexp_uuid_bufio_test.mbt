test "regexp_module_name" {
  assert_eq(@integration.regexp_module_name(), "moonbitlang_regexp")
}

test "regexp_version" {
  assert_eq(@integration.regexp_version(), "0.1.0")
}

test "regexp_export_functions_count" {
  assert_eq(@integration.regexp_export_functions().length(), 5)
}

test "regexp_has_compile" {
  assert_true(has_fn(@integration.regexp_export_functions(), "regexp_compile"))
}

test "regexp_has_match" {
  assert_true(has_fn(@integration.regexp_export_functions(), "regexp_match"))
}

test "regexp_has_replace" {
  assert_true(has_fn(@integration.regexp_export_functions(), "regexp_replace"))
}

test "regexp_compile_return_type" {
  match find_fn(@integration.regexp_export_functions(), "regexp_compile") {
    Some(f) => assert_eq(f.return_type, "Regexp")
    None => assert_true(false)
  }
}

test "regexp_match_params" {
  match find_fn(@integration.regexp_export_functions(), "regexp_match") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "re")
      assert_eq(f.params[1].name, "input")
    }
    None => assert_true(false)
  }
}

test "regexp_cross_config" {
  let cfg = @integration.regexp_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/regexp")
  assert_eq(cfg.targets.length(), 5)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 2)
}

test "regexp_has_regexp_type" {
  assert_true(has_ty(@integration.regexp_export_types(), "Regexp"))
}

test "regexp_has_match_result_type" {
  assert_true(has_ty(@integration.regexp_export_types(), "MatchResult"))
}

test "run_regexp_pipeline" {
  let result = @integration.run_regexp_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 5)
  assert_eq(result.ffi_bindings.length(), 5)
  assert_true(result.c_header.contains("moonbitlang_regexp"))
}

test "uuid_module_name" {
  assert_eq(@integration.uuid_module_name(), "moonbitlang_uuid")
}

test "uuid_version" {
  assert_eq(@integration.uuid_version(), "0.1.0")
}

test "uuid_export_functions_count" {
  assert_eq(@integration.uuid_export_functions().length(), 5)
}

test "uuid_has_v4" {
  assert_true(has_fn(@integration.uuid_export_functions(), "uuid_v4"))
}

test "uuid_has_v7" {
  assert_true(has_fn(@integration.uuid_export_functions(), "uuid_v7"))
}

test "uuid_has_validate" {
  assert_true(has_fn(@integration.uuid_export_functions(), "uuid_validate"))
}

test "uuid_v4_no_params" {
  match find_fn(@integration.uuid_export_functions(), "uuid_v4") {
    Some(f) => assert_eq(f.params.length(), 0)
    None => assert_true(false)
  }
}

test "uuid_v4_return_type" {
  match find_fn(@integration.uuid_export_functions(), "uuid_v4") {
    Some(f) => assert_eq(f.return_type, "String")
    None => assert_true(false)
  }
}

test "uuid_cross_config" {
  let cfg = @integration.uuid_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/uuid")
  assert_eq(cfg.targets.length(), 5)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 1)
}

test "uuid_has_uuid_type" {
  assert_true(has_ty(@integration.uuid_export_types(), "Uuid"))
}

test "run_uuid_pipeline" {
  let result = @integration.run_uuid_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 5)
  assert_true(result.c_header.contains("moonbitlang_uuid"))
}

test "bufio_module_name" {
  assert_eq(@integration.bufio_module_name(), "moonbitlang_bufio")
}

test "bufio_version" {
  assert_eq(@integration.bufio_version(), "0.1.0")
}

test "bufio_export_functions_count" {
  assert_eq(@integration.bufio_export_functions().length(), 5)
}

test "bufio_has_new_buffer" {
  assert_true(has_fn(@integration.bufio_export_functions(), "bufio_new_buffer"))
}

test "bufio_has_write_string" {
  assert_true(has_fn(@integration.bufio_export_functions(), "bufio_write_string"))
}

test "bufio_has_read_line" {
  assert_true(has_fn(@integration.bufio_export_functions(), "bufio_read_line"))
}

test "bufio_new_buffer_return_type" {
  match find_fn(@integration.bufio_export_functions(), "bufio_new_buffer") {
    Some(f) => assert_eq(f.return_type, "Buffer")
    None => assert_true(false)
  }
}

test "bufio_write_string_return_type" {
  match find_fn(@integration.bufio_export_functions(), "bufio_write_string") {
    Some(f) => assert_eq(f.return_type, "Unit")
    None => assert_true(false)
  }
}

test "bufio_cross_config" {
  let cfg = @integration.bufio_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/bufio")
  assert_eq(cfg.targets.length(), 5)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 1)
}

test "bufio_has_buffer_type" {
  assert_true(has_ty(@integration.bufio_export_types(), "Buffer"))
}

test "run_bufio_pipeline" {
  let result = @integration.run_bufio_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 5)
  assert_true(result.c_header.contains("moonbitlang_bufio"))
}
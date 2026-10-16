test "base64_module_name" {
  assert_eq(@integration.base64_module_name(), "moonbitlang_base64")
}

test "base64_version" {
  assert_eq(@integration.base64_version(), "0.1.0")
}

test "base64_export_functions_count" {
  assert_eq(@integration.base64_export_functions().length(), 5)
}

test "base64_has_encode" {
  assert_true(has_fn(@integration.base64_export_functions(), "base64_encode"))
}

test "base64_has_decode" {
  assert_true(has_fn(@integration.base64_export_functions(), "base64_decode"))
}

test "base64_has_urlsafe_encode" {
  assert_true(has_fn(@integration.base64_export_functions(), "base64_encode_urlsafe"))
}

test "base64_encode_return_type" {
  match find_fn(@integration.base64_export_functions(), "base64_encode") {
    Some(f) => assert_eq(f.return_type, "String")
    None => assert_true(false)
  }
}

test "base64_decode_return_type" {
  match find_fn(@integration.base64_export_functions(), "base64_decode") {
    Some(f) => assert_eq(f.return_type, "Bytes")
    None => assert_true(false)
  }
}

test "base64_cross_config" {
  let cfg = @integration.base64_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/base64")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
}

test "run_base64_pipeline" {
  let result = @integration.run_base64_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_eq(result.ffi_bindings.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_base64"))
}

test "json_module_name" {
  assert_eq(@integration.json_module_name(), "moonbitlang_json")
}

test "json_version" {
  assert_eq(@integration.json_version(), "0.1.0")
}

test "json_export_functions_count" {
  assert_eq(@integration.json_export_functions().length(), 5)
}

test "json_has_parse" {
  assert_true(has_fn(@integration.json_export_functions(), "json_parse"))
}

test "json_has_to_string" {
  assert_true(has_fn(@integration.json_export_functions(), "json_to_string"))
}

test "json_parse_return_type" {
  match find_fn(@integration.json_export_functions(), "json_parse") {
    Some(f) => assert_eq(f.return_type, "JsonValue")
    None => assert_true(false)
  }
}

test "json_cross_config" {
  let cfg = @integration.json_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/json")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 2)
}

test "json_has_json_value_type" {
  assert_true(has_ty(@integration.json_export_types(), "JsonValue"))
}

test "json_has_json_error_type" {
  assert_true(has_ty(@integration.json_export_types(), "JsonError"))
}

test "run_json_pipeline" {
  let result = @integration.run_json_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_json"))
}

test "hash_module_name" {
  assert_eq(@integration.hash_module_name(), "moonbitlang_hash")
}

test "hash_version" {
  assert_eq(@integration.hash_version(), "0.1.0")
}

test "hash_export_functions_count" {
  assert_eq(@integration.hash_export_functions().length(), 5)
}

test "hash_has_md5" {
  assert_true(has_fn(@integration.hash_export_functions(), "hash_md5"))
}

test "hash_has_sha256" {
  assert_true(has_fn(@integration.hash_export_functions(), "hash_sha256"))
}

test "hash_has_hmac_sha256" {
  assert_true(has_fn(@integration.hash_export_functions(), "hash_hmac_sha256"))
}

test "hash_md5_return_type" {
  match find_fn(@integration.hash_export_functions(), "hash_md5") {
    Some(f) => assert_eq(f.return_type, "Bytes")
    None => assert_true(false)
  }
}

test "hash_hmac_params" {
  match find_fn(@integration.hash_export_functions(), "hash_hmac_sha256") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "key")
      assert_eq(f.params[1].name, "data")
    }
    None => assert_true(false)
  }
}

test "hash_cross_config" {
  let cfg = @integration.hash_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/hash")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
}

test "run_hash_pipeline" {
  let result = @integration.run_hash_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_hash"))
}
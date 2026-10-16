test "crypto_module_name" {
  assert_eq(@integration.crypto_module_name(), "moonbitlang_crypto")
}

test "crypto_version" {
  assert_eq(@integration.crypto_version(), "0.1.0")
}

test "crypto_export_functions_count" {
  assert_eq(@integration.crypto_export_functions().length(), 5)
}

test "crypto_has_aes_encrypt" {
  assert_true(has_fn(@integration.crypto_export_functions(), "crypto_aes_encrypt"))
}

test "crypto_has_aes_decrypt" {
  assert_true(has_fn(@integration.crypto_export_functions(), "crypto_aes_decrypt"))
}

test "crypto_has_random_bytes" {
  assert_true(has_fn(@integration.crypto_export_functions(), "crypto_random_bytes"))
}

test "crypto_aes_encrypt_params" {
  match find_fn(@integration.crypto_export_functions(), "crypto_aes_encrypt") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "key")
      assert_eq(f.params[1].name, "data")
    }
    None => assert_true(false)
  }
}

test "crypto_random_bytes_return_type" {
  match find_fn(@integration.crypto_export_functions(), "crypto_random_bytes") {
    Some(f) => assert_eq(f.return_type, "Bytes")
    None => assert_true(false)
  }
}

test "crypto_cross_config" {
  let cfg = @integration.crypto_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/crypto")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 1)
}

test "crypto_has_cipher_key_type" {
  assert_true(has_ty(@integration.crypto_export_types(), "CipherKey"))
}

test "run_crypto_pipeline" {
  let result = @integration.run_crypto_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_crypto"))
}

test "time_module_name" {
  assert_eq(@integration.time_module_name(), "moonbitlang_time")
}

test "time_version" {
  assert_eq(@integration.time_version(), "0.1.0")
}

test "time_export_functions_count" {
  assert_eq(@integration.time_export_functions().length(), 5)
}

test "time_has_now" {
  assert_true(has_fn(@integration.time_export_functions(), "time_now"))
}

test "time_has_format" {
  assert_true(has_fn(@integration.time_export_functions(), "time_format"))
}

test "time_has_parse" {
  assert_true(has_fn(@integration.time_export_functions(), "time_parse"))
}

test "time_now_no_params" {
  match find_fn(@integration.time_export_functions(), "time_now") {
    Some(f) => assert_eq(f.params.length(), 0)
    None => assert_true(false)
  }
}

test "time_now_return_type" {
  match find_fn(@integration.time_export_functions(), "time_now") {
    Some(f) => assert_eq(f.return_type, "Int")
    None => assert_true(false)
  }
}

test "time_cross_config" {
  let cfg = @integration.time_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/time")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 1)
}

test "time_has_duration_type" {
  assert_true(has_ty(@integration.time_export_types(), "Duration"))
}

test "run_time_pipeline" {
  let result = @integration.run_time_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_time"))
}

test "sort_module_name" {
  assert_eq(@integration.sort_module_name(), "moonbitlang_sort")
}

test "sort_version" {
  assert_eq(@integration.sort_version(), "0.1.0")
}

test "sort_export_functions_count" {
  assert_eq(@integration.sort_export_functions().length(), 5)
}

test "sort_has_quick_sort" {
  assert_true(has_fn(@integration.sort_export_functions(), "sort_quick_sort"))
}

test "sort_has_merge_sort" {
  assert_true(has_fn(@integration.sort_export_functions(), "sort_merge_sort"))
}

test "sort_has_binary_search" {
  assert_true(has_fn(@integration.sort_export_functions(), "sort_binary_search"))
}

test "sort_binary_search_params" {
  match find_fn(@integration.sort_export_functions(), "sort_binary_search") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "arr")
      assert_eq(f.params[1].name, "target")
    }
    None => assert_true(false)
  }
}

test "sort_is_sorted_return_type" {
  match find_fn(@integration.sort_export_functions(), "sort_is_sorted") {
    Some(f) => assert_eq(f.return_type, "Bool")
    None => assert_true(false)
  }
}

test "sort_cross_config" {
  let cfg = @integration.sort_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/sort")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 0)
}

test "run_sort_pipeline" {
  let result = @integration.run_sort_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_sort"))
}
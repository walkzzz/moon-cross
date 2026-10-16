test "encoding_module_name" {
  assert_eq(@integration.encoding_module_name(), "moonbitlang_encoding")
}

test "encoding_version" {
  assert_eq(@integration.encoding_version(), "0.1.0")
}

test "encoding_export_functions_count" {
  assert_eq(@integration.encoding_export_functions().length(), 5)
}

test "encoding_has_encode" {
  assert_true(has_fn(@integration.encoding_export_functions(), "encoding_encode"))
}

test "encoding_has_decode" {
  assert_true(has_fn(@integration.encoding_export_functions(), "encoding_decode"))
}

test "encoding_has_convert" {
  assert_true(has_fn(@integration.encoding_export_functions(), "encoding_convert"))
}

test "encoding_encode_params" {
  match find_fn(@integration.encoding_export_functions(), "encoding_encode") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "data")
      assert_eq(f.params[1].name, "scheme")
    }
    None => assert_true(false)
  }
}

test "encoding_validate_return_type" {
  match find_fn(@integration.encoding_export_functions(), "encoding_validate") {
    Some(f) => assert_eq(f.return_type, "Bool")
    None => assert_true(false)
  }
}

test "encoding_cross_config" {
  let cfg = @integration.encoding_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/encoding")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 1)
}

test "encoding_has_scheme_type" {
  assert_true(has_ty(@integration.encoding_export_types(), "EncodingScheme"))
}

test "run_encoding_pipeline" {
  let result = @integration.run_encoding_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_encoding"))
}

test "container_module_name" {
  assert_eq(@integration.container_module_name(), "moonbitlang_container")
}

test "container_version" {
  assert_eq(@integration.container_version(), "0.1.0")
}

test "container_export_functions_count" {
  assert_eq(@integration.container_export_functions().length(), 5)
}

test "container_has_push" {
  assert_true(has_fn(@integration.container_export_functions(), "container_push"))
}

test "container_has_pop" {
  assert_true(has_fn(@integration.container_export_functions(), "container_pop"))
}

test "container_has_peek" {
  assert_true(has_fn(@integration.container_export_functions(), "container_peek"))
}

test "container_push_params" {
  match find_fn(@integration.container_export_functions(), "container_push") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "container")
      assert_eq(f.params[1].name, "item")
    }
    None => assert_true(false)
  }
}

test "container_size_return_type" {
  match find_fn(@integration.container_export_functions(), "container_size") {
    Some(f) => assert_eq(f.return_type, "Int")
    None => assert_true(false)
  }
}

test "container_cross_config" {
  let cfg = @integration.container_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/container")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 2)
}

test "container_has_container_type" {
  assert_true(has_ty(@integration.container_export_types(), "Container"))
}

test "run_container_pipeline" {
  let result = @integration.run_container_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_container"))
}

test "random_module_name" {
  assert_eq(@integration.random_module_name(), "moonbitlang_random")
}

test "random_version" {
  assert_eq(@integration.random_version(), "0.1.0")
}

test "random_export_functions_count" {
  assert_eq(@integration.random_export_functions().length(), 5)
}

test "random_has_next" {
  assert_true(has_fn(@integration.random_export_functions(), "random_next"))
}

test "random_has_range" {
  assert_true(has_fn(@integration.random_export_functions(), "random_range"))
}

test "random_has_seed" {
  assert_true(has_fn(@integration.random_export_functions(), "random_seed"))
}

test "random_has_shuffle" {
  assert_true(has_fn(@integration.random_export_functions(), "random_shuffle"))
}

test "random_range_params" {
  match find_fn(@integration.random_export_functions(), "random_range") {
    Some(f) => {
      assert_eq(f.params.length(), 3)
      assert_eq(f.params[0].name, "state")
      assert_eq(f.params[1].name, "min")
      assert_eq(f.params[2].name, "max")
    }
    None => assert_true(false)
  }
}

test "random_seed_return_type" {
  match find_fn(@integration.random_export_functions(), "random_seed") {
    Some(f) => assert_eq(f.return_type, "RngState")
    None => assert_true(false)
  }
}

test "random_cross_config" {
  let cfg = @integration.random_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/random")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 1)
}

test "random_has_rng_state_type" {
  assert_true(has_ty(@integration.random_export_types(), "RngState"))
}

test "run_random_pipeline" {
  let result = @integration.run_random_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_random"))
}
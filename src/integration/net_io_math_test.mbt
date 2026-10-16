test "net_module_name" {
  assert_eq(@integration.net_module_name(), "moonbitlang_net")
}

test "net_version" {
  assert_eq(@integration.net_version(), "0.1.0")
}

test "net_export_functions_count" {
  assert_eq(@integration.net_export_functions().length(), 5)
}

test "net_has_connect" {
  assert_true(has_fn(@integration.net_export_functions(), "net_connect"))
}

test "net_has_listen" {
  assert_true(has_fn(@integration.net_export_functions(), "net_listen"))
}

test "net_has_close" {
  assert_true(has_fn(@integration.net_export_functions(), "net_close"))
}

test "net_connect_params" {
  match find_fn(@integration.net_export_functions(), "net_connect") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "addr")
      assert_eq(f.params[1].name, "port")
    }
    None => assert_true(false)
  }
}

test "net_listen_return_type" {
  match find_fn(@integration.net_export_functions(), "net_listen") {
    Some(f) => assert_eq(f.return_type, "Socket")
    None => assert_true(false)
  }
}

test "net_cross_config" {
  let cfg = @integration.net_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/net")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 2)
}

test "net_has_socket_type" {
  assert_true(has_ty(@integration.net_export_types(), "Socket"))
}

test "net_has_address_type" {
  assert_true(has_ty(@integration.net_export_types(), "Address"))
}

test "run_net_pipeline" {
  let result = @integration.run_net_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_net"))
}

test "io_module_name" {
  assert_eq(@integration.io_module_name(), "moonbitlang_io")
}

test "io_version" {
  assert_eq(@integration.io_version(), "0.1.0")
}

test "io_export_functions_count" {
  assert_eq(@integration.io_export_functions().length(), 5)
}

test "io_has_open" {
  assert_true(has_fn(@integration.io_export_functions(), "io_open"))
}

test "io_has_read" {
  assert_true(has_fn(@integration.io_export_functions(), "io_read"))
}

test "io_has_write" {
  assert_true(has_fn(@integration.io_export_functions(), "io_write"))
}

test "io_open_params" {
  match find_fn(@integration.io_export_functions(), "io_open") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "path")
      assert_eq(f.params[1].name, "mode")
    }
    None => assert_true(false)
  }
}

test "io_read_return_type" {
  match find_fn(@integration.io_export_functions(), "io_read") {
    Some(f) => assert_eq(f.return_type, "Bytes")
    None => assert_true(false)
  }
}

test "io_cross_config" {
  let cfg = @integration.io_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/io")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 2)
}

test "io_has_file_handle_type" {
  assert_true(has_ty(@integration.io_export_types(), "FileHandle"))
}

test "io_has_buffer_type" {
  assert_true(has_ty(@integration.io_export_types(), "Buffer"))
}

test "run_io_pipeline" {
  let result = @integration.run_io_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_io"))
}

test "math_module_name" {
  assert_eq(@integration.math_module_name(), "moonbitlang_math")
}

test "math_version" {
  assert_eq(@integration.math_version(), "0.1.0")
}

test "math_export_functions_count" {
  assert_eq(@integration.math_export_functions().length(), 8)
}

test "math_has_sin" {
  assert_true(has_fn(@integration.math_export_functions(), "math_sin"))
}

test "math_has_cos" {
  assert_true(has_fn(@integration.math_export_functions(), "math_cos"))
}

test "math_has_sqrt" {
  assert_true(has_fn(@integration.math_export_functions(), "math_sqrt"))
}

test "math_has_pow" {
  assert_true(has_fn(@integration.math_export_functions(), "math_pow"))
}

test "math_pow_params" {
  match find_fn(@integration.math_export_functions(), "math_pow") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "base")
      assert_eq(f.params[1].name, "exp")
    }
    None => assert_true(false)
  }
}

test "math_sin_return_type" {
  match find_fn(@integration.math_export_functions(), "math_sin") {
    Some(f) => assert_eq(f.return_type, "Double")
    None => assert_true(false)
  }
}

test "math_cross_config" {
  let cfg = @integration.math_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/math")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 8)
  assert_eq(cfg.types.length(), 2)
}

test "math_has_vector2_type" {
  assert_true(has_ty(@integration.math_export_types(), "Vector2"))
}

test "math_has_vector3_type" {
  assert_true(has_ty(@integration.math_export_types(), "Vector3"))
}

test "run_math_pipeline" {
  let result = @integration.run_math_pipeline()
  assert_eq(result.config.functions.length(), 8)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_math"))
}
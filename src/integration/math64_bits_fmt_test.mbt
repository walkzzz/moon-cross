test "math64_module_name" {
  assert_eq(@integration.math64_module_name(), "moonbitlang_math64")
}

test "math64_version" {
  assert_eq(@integration.math64_version(), "0.1.0")
}

test "math64_export_functions_count" {
  assert_eq(@integration.math64_export_functions().length(), 6)
}

test "math64_has_add" {
  assert_true(has_fn(@integration.math64_export_functions(), "math64_add"))
}

test "math64_has_mul" {
  assert_true(has_fn(@integration.math64_export_functions(), "math64_mul"))
}

test "math64_add_params" {
  match find_fn(@integration.math64_export_functions(), "math64_add") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "a")
      assert_eq(f.params[1].name, "b")
    }
    None => assert_true(false)
  }
}

test "math64_compare_return_type" {
  match find_fn(@integration.math64_export_functions(), "math64_compare") {
    Some(f) => assert_eq(f.return_type, "Int")
    None => assert_true(false)
  }
}

test "math64_cross_config" {
  let cfg = @integration.math64_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/math64")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 6)
  assert_eq(cfg.types.length(), 1)
}

test "math64_has_int64_type" {
  assert_true(has_ty(@integration.math64_export_types(), "Int64"))
}

test "run_math64_pipeline" {
  let result = @integration.run_math64_pipeline()
  assert_eq(result.config.functions.length(), 6)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_math64"))
}

test "bits_module_name" {
  assert_eq(@integration.bits_module_name(), "moonbitlang_bits")
}

test "bits_version" {
  assert_eq(@integration.bits_version(), "0.1.0")
}

test "bits_export_functions_count" {
  assert_eq(@integration.bits_export_functions().length(), 6)
}

test "bits_has_and" {
  assert_true(has_fn(@integration.bits_export_functions(), "bits_and"))
}

test "bits_has_xor" {
  assert_true(has_fn(@integration.bits_export_functions(), "bits_xor"))
}

test "bits_shift_left_params" {
  match find_fn(@integration.bits_export_functions(), "bits_shift_left") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "a")
      assert_eq(f.params[1].name, "n")
    }
    None => assert_true(false)
  }
}

test "bits_not_return_type" {
  match find_fn(@integration.bits_export_functions(), "bits_not") {
    Some(f) => assert_eq(f.return_type, "Int")
    None => assert_true(false)
  }
}

test "bits_cross_config" {
  let cfg = @integration.bits_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/bits")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 6)
  assert_eq(cfg.types.length(), 1)
}

test "bits_has_bitfield_type" {
  assert_true(has_ty(@integration.bits_export_types(), "BitField"))
}

test "run_bits_pipeline" {
  let result = @integration.run_bits_pipeline()
  assert_eq(result.config.functions.length(), 6)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_bits"))
}

test "fmt_module_name" {
  assert_eq(@integration.fmt_module_name(), "moonbitlang_fmt")
}

test "fmt_version" {
  assert_eq(@integration.fmt_version(), "0.1.0")
}

test "fmt_export_functions_count" {
  assert_eq(@integration.fmt_export_functions().length(), 5)
}

test "fmt_has_int" {
  assert_true(has_fn(@integration.fmt_export_functions(), "fmt_int"))
}

test "fmt_has_array" {
  assert_true(has_fn(@integration.fmt_export_functions(), "fmt_array"))
}

test "fmt_int_params" {
  match find_fn(@integration.fmt_export_functions(), "fmt_int") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "value")
      assert_eq(f.params[1].name, "spec")
    }
    None => assert_true(false)
  }
}

test "fmt_bool_return_type" {
  match find_fn(@integration.fmt_export_functions(), "fmt_bool") {
    Some(f) => assert_eq(f.return_type, "String")
    None => assert_true(false)
  }
}

test "fmt_cross_config" {
  let cfg = @integration.fmt_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/fmt")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 1)
}

test "fmt_has_format_spec_type" {
  assert_true(has_ty(@integration.fmt_export_types(), "FormatSpec"))
}

test "run_fmt_pipeline" {
  let result = @integration.run_fmt_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_fmt"))
}
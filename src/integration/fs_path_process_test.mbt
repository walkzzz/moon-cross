test "fs_module_name" {
  assert_eq(@integration.fs_module_name(), "moonbitlang_fs")
}

test "fs_version" {
  assert_eq(@integration.fs_version(), "0.1.0")
}

test "fs_export_functions_count" {
  assert_eq(@integration.fs_export_functions().length(), 6)
}

test "fs_has_read" {
  assert_true(has_fn(@integration.fs_export_functions(), "fs_read"))
}

test "fs_has_write" {
  assert_true(has_fn(@integration.fs_export_functions(), "fs_write"))
}

test "fs_has_exists" {
  assert_true(has_fn(@integration.fs_export_functions(), "fs_exists"))
}

test "fs_read_params" {
  match find_fn(@integration.fs_export_functions(), "fs_read") {
    Some(f) => {
      assert_eq(f.params.length(), 1)
      assert_eq(f.params[0].name, "path")
    }
    None => assert_true(false)
  }
}

test "fs_write_params" {
  match find_fn(@integration.fs_export_functions(), "fs_write") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "path")
      assert_eq(f.params[1].name, "data")
    }
    None => assert_true(false)
  }
}

test "fs_exists_return_type" {
  match find_fn(@integration.fs_export_functions(), "fs_exists") {
    Some(f) => assert_eq(f.return_type, "Bool")
    None => assert_true(false)
  }
}

test "fs_stat_return_type" {
  match find_fn(@integration.fs_export_functions(), "fs_stat") {
    Some(f) => assert_eq(f.return_type, "FileInfo")
    None => assert_true(false)
  }
}

test "fs_cross_config" {
  let cfg = @integration.fs_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/fs")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 6)
  assert_eq(cfg.types.length(), 1)
}

test "fs_has_file_info_type" {
  assert_true(has_ty(@integration.fs_export_types(), "FileInfo"))
}

test "run_fs_pipeline" {
  let result = @integration.run_fs_pipeline()
  assert_eq(result.config.functions.length(), 6)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_fs"))
}

test "path_module_name" {
  assert_eq(@integration.path_module_name(), "moonbitlang_path")
}

test "path_version" {
  assert_eq(@integration.path_version(), "0.1.0")
}

test "path_export_functions_count" {
  assert_eq(@integration.path_export_functions().length(), 6)
}

test "path_has_join" {
  assert_true(has_fn(@integration.path_export_functions(), "path_join"))
}

test "path_has_normalize" {
  assert_true(has_fn(@integration.path_export_functions(), "path_normalize"))
}

test "path_has_dirname" {
  assert_true(has_fn(@integration.path_export_functions(), "path_dirname"))
}

test "path_join_params" {
  match find_fn(@integration.path_export_functions(), "path_join") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "base")
      assert_eq(f.params[1].name, "sub")
    }
    None => assert_true(false)
  }
}

test "path_is_absolute_return_type" {
  match find_fn(@integration.path_export_functions(), "path_is_absolute") {
    Some(f) => assert_eq(f.return_type, "Bool")
    None => assert_true(false)
  }
}

test "path_cross_config" {
  let cfg = @integration.path_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/path")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 6)
  assert_eq(cfg.types.length(), 1)
}

test "path_has_path_type" {
  assert_true(has_ty(@integration.path_export_types(), "Path"))
}

test "run_path_pipeline" {
  let result = @integration.run_path_pipeline()
  assert_eq(result.config.functions.length(), 6)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_path"))
}

test "process_module_name" {
  assert_eq(@integration.process_module_name(), "moonbitlang_process")
}

test "process_version" {
  assert_eq(@integration.process_version(), "0.1.0")
}

test "process_export_functions_count" {
  assert_eq(@integration.process_export_functions().length(), 5)
}

test "process_has_spawn" {
  assert_true(has_fn(@integration.process_export_functions(), "process_spawn"))
}

test "process_has_wait" {
  assert_true(has_fn(@integration.process_export_functions(), "process_wait"))
}

test "process_has_kill" {
  assert_true(has_fn(@integration.process_export_functions(), "process_kill"))
}

test "process_spawn_params" {
  match find_fn(@integration.process_export_functions(), "process_spawn") {
    Some(f) => {
      assert_eq(f.params.length(), 2)
      assert_eq(f.params[0].name, "cmd")
      assert_eq(f.params[1].name, "args")
    }
    None => assert_true(false)
  }
}

test "process_wait_return_type" {
  match find_fn(@integration.process_export_functions(), "process_wait") {
    Some(f) => assert_eq(f.return_type, "Int")
    None => assert_true(false)
  }
}

test "process_cross_config" {
  let cfg = @integration.process_cross_config()
  assert_eq(cfg.module_path, "moonbitlang/process")
  assert_eq(cfg.targets.length(), 4)
  assert_eq(cfg.functions.length(), 5)
  assert_eq(cfg.types.length(), 1)
}

test "process_has_process_type" {
  assert_true(has_ty(@integration.process_export_types(), "Process"))
}

test "run_process_pipeline" {
  let result = @integration.run_process_pipeline()
  assert_eq(result.config.functions.length(), 5)
  assert_eq(result.platform_specs.length(), 4)
  assert_true(result.c_header.contains("moonbitlang_process"))
}
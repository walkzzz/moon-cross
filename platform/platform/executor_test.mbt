///|
test "executor_version" {
  assert_eq(@platform.executor_version(), "moon-cross executor v0.3.33")
}

///|
test "simulate_compile_success" {
  let r = @platform.simulate_compile("gcc -shared -o libtest.so", "libtest.so")
  assert_true(r.success)
  assert_eq(r.output_path, "libtest.so")
}

///|
test "compile_failure" {
  let r = @platform.compile_failure("gcc", "compiler not found")
  assert_false(r.success)
  assert_eq(r.error_message, "compiler not found")
}

///|
test "generate_build_script_contains_shebang" {
  let cfg = @platform.default_build_config("mylib")
  let script = @platform.generate_build_script(cfg)
  assert_true(script.contains("#!/bin/bash"))
}

///|
test "generate_build_script_contains_all_platforms" {
  let cfg = @platform.default_build_config("mylib")
  let script = @platform.generate_build_script(cfg)
  assert_true(script.contains("linux"))
  assert_true(script.contains("android"))
  assert_true(script.contains("ios"))
  assert_true(script.contains("windows"))
  assert_true(script.contains("ohos"))
}

///|
test "generate_build_script_contains_module" {
  let cfg = @platform.default_build_config("mylib")
  let script = @platform.generate_build_script(cfg)
  assert_true(script.contains("mylib"))
}

///|
test "generate_compile_plan" {
  let cfg = @platform.default_build_config("mylib")
  let plan = @platform.generate_compile_plan(cfg)
  assert_true(plan.length() > 0)
}

///|
test "generate_bat_script" {
  let cfg = @platform.default_build_config("mylib")
  let script = @platform.generate_bat_script(cfg)
  assert_true(script.contains("@echo off"))
}

///|
test "default_build_config" {
  let cfg = @platform.default_build_config("testlib")
  assert_eq(cfg.module_name, "testlib")
  assert_eq(cfg.platforms.length(), 5)
}

///|
test "compile_result_named" {
  let r = @platform.simulate_compile("gcc", "libtest.so")
  assert_eq(@trait.Named::name(r), "libtest.so")
}

///|
test "compile_result_checkable" {
  let r = @platform.simulate_compile("gcc", "libtest.so")
  assert_true(@trait.Checkable::check(r))
}

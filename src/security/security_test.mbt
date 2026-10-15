test "asan: default config" {
  let config = @security.default_asan_config()
  assert_true(config.enabled)
  assert_true(config.detect_leaks)
  assert_true(config.detect_undefined_behavior)
  assert_false(config.detect_stack_use_after_return)
}

test "asan: disabled config" {
  let config = @security.disabled_asan_config()
  assert_false(config.enabled)
  assert_false(config.detect_leaks)
}

test "asan: compile flags enabled" {
  let config = @security.default_asan_config()
  let flags = @security.asan_compile_flags(config)
  assert_true(flags.length() >= 3)
  assert_true(flags[0].contains("address"))
}

test "asan: compile flags disabled" {
  let config = @security.disabled_asan_config()
  let flags = @security.asan_compile_flags(config)
  assert_eq(flags.length(), 0)
}

test "asan: link flags" {
  let config = @security.default_asan_config()
  let flags = @security.asan_link_flags(config)
  assert_true(flags.length() >= 1)
  assert_true(flags[0].contains("address"))
}

test "asan: env vars" {
  let config = @security.default_asan_config()
  let vars = @security.asan_env_vars(config)
  assert_true(vars.length() >= 1)
  assert_true(vars[0].contains("detect_leaks=1"))
}

test "asan: env vars no leaks" {
  let config = { ..@security.default_asan_config(), detect_leaks: false }
  let vars = @security.asan_env_vars(config)
  assert_true(vars[0].contains("detect_leaks=0"))
}

test "asan: analyze clean output" {
  let result = @security.analyze_asan_output("compilation successful")
  assert_true(result.passed)
  assert_eq(result.errors.length(), 0)
}

test "asan: analyze error output" {
  let output = "ERROR: AddressSanitizer: heap-buffer-overflow"
  let result = @security.analyze_asan_output(output)
  assert_false(result.passed)
  assert_true(result.errors.length() >= 2)
}

test "asan: analyze use after free" {
  let output = "ERROR: AddressSanitizer: use-after-free"
  let result = @security.analyze_asan_output(output)
  assert_false(result.passed)
}

test "asan: analyze warning" {
  let output = "WARNING: AddressSanitizer: memory leak"
  let result = @security.analyze_asan_output(output)
  assert_true(result.passed)
  assert_true(result.warnings.length() >= 2)
}

test "asan: passed result" {
  let result = @security.asan_passed(5000)
  assert_true(result.passed)
  assert_eq(result.duration_ms, 5000)
}

test "asan: failed result" {
  let result = @security.asan_failed(["error1"], 3000)
  assert_false(result.passed)
  assert_eq(result.errors.length(), 1)
}

test "asan: version" {
  assert_true(@security.asan_version().contains("v0.9.0"))
}

test "ffi_safety: null check with pointer" {
  let result = @security.check_null_safety("my_func", ["int* ptr", "int len"])
  let has_issue = match result {
    Some(_) => true
    None => false
  }
  assert_true(has_issue)
}

test "ffi_safety: null check without pointer" {
  let result = @security.check_null_safety("my_func", ["int a", "int b"])
  assert_eq(result, None)
}

test "ffi_safety: buffer bounds with array" {
  let result = @security.check_buffer_bounds("my_func", true)
  let has_issue = match result {
    Some(_) => true
    None => false
  }
  assert_true(has_issue)
}

test "ffi_safety: buffer bounds without array" {
  assert_eq(@security.check_buffer_bounds("my_func", false), None)
}

test "ffi_safety: type check with pointer return" {
  let result = @security.check_type_safety("my_func", "int*")
  let has_issue = match result {
    Some(_) => true
    None => false
  }
  assert_true(has_issue)
}

test "ffi_safety: type check with safe return" {
  assert_eq(@security.check_type_safety("my_func", "int"), None)
}

test "ffi_safety: generate wrapper" {
  let code = @security.generate_safety_wrapper("my_func", ["int* ptr", "int len"])
  assert_true(code.contains("safe_my_func"))
  assert_true(code.contains("null check"))
  assert_true(code.contains("ptr == NULL"))
}

test "ffi_safety: comprehensive check safe" {
  let result = @security.comprehensive_safety_check("safe_func", ["int a", "int b"], "int")
  assert_true(result.safe)
  assert_eq(result.issues.length(), 0)
}

test "ffi_safety: comprehensive check unsafe" {
  let result = @security.comprehensive_safety_check("unsafe_func", ["int* ptr"], "int*")
  assert_false(result.safe)
  assert_true(result.issues.length() >= 2)
}

test "ffi_safety: version" {
  assert_true(@security.ffi_safety_version().contains("v0.9.0"))
}

test "sandbox: default config" {
  let config = @security.default_sandbox_config()
  assert_true(config.isolated)
  assert_eq(config.timeout_ms, 60000)
  assert_eq(config.max_memory_mb, 512)
}

test "sandbox: work dir for platform" {
  assert_true(@security.sandbox_work_dir(@core.Platform::Windows).contains("windows"))
  assert_true(@security.sandbox_work_dir(@core.Platform::Ios).contains("ios"))
  assert_true(@security.sandbox_work_dir(@core.Platform::Android).contains("android"))
  assert_true(@security.sandbox_work_dir(@core.Platform::Ohos).contains("ohos"))
}

test "sandbox: compile command isolated" {
  let config = @security.default_sandbox_config()
  let cmd = @security.sandbox_compile_command(config, "clang -c file.c")
  assert_true(cmd.contains("cd "))
  assert_true(cmd.contains("timeout"))
  assert_true(cmd.contains("clang"))
}

test "sandbox: compile command not isolated" {
  let config = { ..@security.default_sandbox_config(), isolated: false }
  let cmd = @security.sandbox_compile_command(config, "clang -c file.c")
  assert_true(cmd.contains("clang"))
}

test "sandbox: cleanup" {
  let config = @security.default_sandbox_config()
  let cmd = @security.cleanup_sandbox(config)
  assert_true(cmd.contains("rm -rf"))
}

test "sandbox: cleanup not isolated" {
  let config = { ..@security.default_sandbox_config(), isolated: false }
  let cmd = @security.cleanup_sandbox(config)
  assert_eq(cmd, "")
}

test "sandbox: success result" {
  let result = @security.sandbox_success("output", 1000)
  assert_true(result.success)
  assert_eq(result.exit_code, 0)
  assert_false(result.timed_out)
}

test "sandbox: failure result" {
  let result = @security.sandbox_failure(1, "error", 500)
  assert_false(result.success)
  assert_eq(result.exit_code, 1)
}

test "sandbox: timeout result" {
  let result = @security.sandbox_timeout(30000)
  assert_false(result.success)
  assert_true(result.timed_out)
  assert_eq(result.exit_code, 124)
}

test "sandbox: validate config valid" {
  let config = @security.default_sandbox_config()
  assert_eq(@security.validate_sandbox_config(config), None)
}

test "sandbox: validate config invalid timeout" {
  let config = { ..@security.default_sandbox_config(), timeout_ms: 0 }
  let result = @security.validate_sandbox_config(config)
  let has_issue = match result {
    Some(_) => true
    None => false
  }
  assert_true(has_issue)
}

test "sandbox: version" {
  assert_true(@security.sandbox_version().contains("v0.9.0"))
}

test "supply_chain: make dependency" {
  let dep = @security.make_dependency("libfoo", "1.0.0", "MIT", "abc123")
  assert_eq(dep.name, "libfoo")
  assert_eq(dep.version, "1.0.0")
  assert_eq(dep.license, "MIT")
  assert_eq(dep.checksum, "abc123")
}

test "supply_chain: verify checksum match" {
  assert_true(@security.verify_checksum("abc123", "abc123"))
}

test "supply_chain: verify checksum mismatch" {
  assert_false(@security.verify_checksum("abc123", "def456"))
}

test "supply_chain: verify checksum empty" {
  assert_false(@security.verify_checksum("", ""))
}

test "supply_chain: license compat MIT MIT" {
  let result = @security.check_license_compatibility("MIT", "MIT")
  assert_true(result.compatible)
}

test "supply_chain: license compat MIT Apache" {
  let result = @security.check_license_compatibility("MIT", "Apache-2.0")
  assert_true(result.compatible)
}

test "supply_chain: license compat GPL Apache" {
  let result = @security.check_license_compatibility("GPL-3.0", "Apache-2.0")
  assert_false(result.compatible)
}

test "supply_chain: license compat unlicensed" {
  let result = @security.check_license_compatibility("MIT", "UNLICENSED")
  assert_false(result.compatible)
}

test "supply_chain: license compat proprietary" {
  let result = @security.check_license_compatibility("MIT", "PROPRIETARY")
  assert_false(result.compatible)
}

test "supply_chain: lock entry" {
  let dep = @security.make_dependency("libfoo", "1.0.0", "MIT", "abc123")
  let entry = @security.make_lock_entry(dep, "mooncakes")
  assert_eq(entry.name, "libfoo")
  assert_eq(entry.source, "mooncakes")
}

test "supply_chain: generate lock file" {
  let entries = [
    @security.make_lock_entry(@security.make_dependency("libfoo", "1.0.0", "MIT", "abc123"), "mooncakes"),
    @security.make_lock_entry(@security.make_dependency("libbar", "2.0.0", "Apache-2.0", "def456"), "mooncakes"),
  ]
  let content = @security.generate_lock_file(entries)
  assert_true(content.contains("libfoo"))
  assert_true(content.contains("libbar"))
  assert_true(content.contains("1.0.0"))
  assert_true(content.contains("2.0.0"))
}

test "supply_chain: check dependency safe" {
  let dep = @security.make_dependency("libfoo", "1.0.0", "MIT", "abc123")
  assert_eq(@security.check_dependency_safety(dep), None)
}

test "supply_chain: check dependency unlicensed" {
  let dep = @security.make_dependency("libfoo", "1.0.0", "UNLICENSED", "abc123")
  let result = @security.check_dependency_safety(dep)
  let has_issue = match result {
    Some(_) => true
    None => false
  }
  assert_true(has_issue)
}

test "supply_chain: check dependency missing checksum" {
  let dep = @security.make_dependency("libfoo", "1.0.0", "MIT", "")
  let result = @security.check_dependency_safety(dep)
  let has_issue = match result {
    Some(_) => true
    None => false
  }
  assert_true(has_issue)
}

test "supply_chain: batch check" {
  let deps = [
    @security.make_dependency("libfoo", "1.0.0", "MIT", "abc123"),
    @security.make_dependency("libbar", "2.0.0", "UNLICENSED", "def456"),
  ]
  let issues = @security.batch_check_dependencies(deps)
  assert_eq(issues.length(), 1)
}

test "supply_chain: version" {
  assert_true(@security.supply_chain_version().contains("v0.9.0"))
}
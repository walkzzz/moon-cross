test "retry: default config" {
  let config = @robust.default_retry_config()
  assert_eq(config.max_attempts, 3)
  assert_eq(config.initial_delay_ms, 100)
  assert_eq(config.backoff_multiplier, 2)
  assert_eq(config.timeout_ms, 30000)
}

test "retry: exponential backoff" {
  let config = @robust.default_retry_config()
  assert_eq(@robust.exponential_backoff(config, 0), 0)
  assert_eq(@robust.exponential_backoff(config, 1), 100)
  assert_eq(@robust.exponential_backoff(config, 2), 200)
  assert_eq(@robust.exponential_backoff(config, 3), 400)
}

test "retry: should retry" {
  let config = @robust.default_retry_config()
  assert_true(@robust.should_retry(config, 0))
  assert_true(@robust.should_retry(config, 1))
  assert_true(@robust.should_retry(config, 2))
  assert_false(@robust.should_retry(config, 3))
}

test "retry: success result" {
  let result = @robust.retry_success(2, 300)
  assert_true(result.success)
  assert_eq(result.attempts, 2)
  assert_eq(result.total_delay_ms, 300)
  assert_eq(result.last_error, None)
}

test "retry: failure result" {
  let result = @robust.retry_failure(3, "timeout", 700)
  assert_false(result.success)
  assert_eq(result.attempts, 3)
  assert_eq(result.last_error, Some("timeout"))
  assert_eq(result.total_delay_ms, 700)
}

test "retry: total timeout" {
  let config = @robust.default_retry_config()
  let total = @robust.total_timeout(config)
  assert_eq(total, 700)
}

test "retry: version" {
  assert_true(@robust.retry_version().contains("v0.0.8"))
}

test "recovery: compile result success" {
  let result = @robust.compile_result(@core.Platform::Windows, true, None, ["output.lib"], 5000)
  assert_true(result.success)
  assert_eq(result.platform, @core.Platform::Windows)
  assert_eq(result.output_files.length(), 1)
  assert_eq(result.duration_ms, 5000)
}

test "recovery: compile result failure" {
  let result = @robust.compile_result(@core.Platform::Ios, false, Some("xcode not found"), [], 0)
  assert_false(result.success)
  assert_eq(result.error_message, Some("xcode not found"))
}

test "recovery: summarize all success" {
  let results = [
    @robust.compile_result(@core.Platform::Windows, true, None, [], 1000),
    @robust.compile_result(@core.Platform::Ios, true, None, [], 2000),
  ]
  let summary = @robust.summarize_compile(results)
  assert_eq(summary.total_platforms, 2)
  assert_eq(summary.successful_platforms, 2)
  assert_eq(summary.failed_platforms, 0)
}

test "recovery: summarize mixed" {
  let results = [
    @robust.compile_result(@core.Platform::Windows, true, None, [], 1000),
    @robust.compile_result(@core.Platform::Ios, false, Some("xcode not found"), [], 0),
    @robust.compile_result(@core.Platform::Android, true, None, [], 2000),
  ]
  let summary = @robust.summarize_compile(results)
  assert_eq(summary.total_platforms, 3)
  assert_eq(summary.successful_platforms, 2)
  assert_eq(summary.failed_platforms, 1)
}

test "recovery: partial success" {
  let results = [
    @robust.compile_result(@core.Platform::Windows, true, None, [], 1000),
    @robust.compile_result(@core.Platform::Ios, false, Some("error"), [], 0),
  ]
  let successful = @robust.partial_success_recovery(results)
  assert_eq(successful.length(), 1)
  assert_eq(successful[0], @core.Platform::Windows)
}

test "recovery: all failure" {
  let results = [
    @robust.compile_result(@core.Platform::Windows, false, Some("err1"), [], 0),
    @robust.compile_result(@core.Platform::Ios, false, Some("err2"), [], 0),
  ]
  let successful = @robust.partial_success_recovery(results)
  assert_eq(successful.length(), 0)
}

test "recovery: ffi fallback" {
  assert_eq(@robust.ffi_binding_fallback("unsupported type"), @robust.FfiFallbackMode::ManualFfi)
  assert_eq(@robust.ffi_binding_fallback("codegen error"), @robust.FfiFallbackMode::PureC)
}

test "recovery: config degradation" {
  assert_eq(@robust.config_degradation("optimization"), "O2")
  assert_eq(@robust.config_degradation("debug"), "false")
  assert_eq(@robust.config_degradation("strip"), "true")
  assert_eq(@robust.config_degradation("unknown"), "default")
}

test "recovery: has partial success" {
  let results = [
    @robust.compile_result(@core.Platform::Windows, true, None, [], 1000),
    @robust.compile_result(@core.Platform::Ios, false, Some("error"), [], 0),
  ]
  let summary = @robust.summarize_compile(results)
  assert_true(@robust.has_partial_success(summary))
}

test "recovery: no partial success all pass" {
  let results = [
    @robust.compile_result(@core.Platform::Windows, true, None, [], 1000),
    @robust.compile_result(@core.Platform::Ios, true, None, [], 2000),
  ]
  let summary = @robust.summarize_compile(results)
  assert_false(@robust.has_partial_success(summary))
}

test "recovery: failure report" {
  let results = [
    @robust.compile_result(@core.Platform::Ios, false, Some("xcode missing"), [], 0),
  ]
  let summary = @robust.summarize_compile(results)
  let report = @robust.generate_failure_report(summary)
  assert_true(report.contains("xcode missing"))
  assert_true(report.contains("Compile Summary"))
  assert_true(report.contains("Failed: 1"))
}

test "recovery: version" {
  assert_true(@robust.recovery_version().contains("v0.0.8"))
}

test "validate: non-empty" {
  assert_eq(@robust.validate_non_empty("name", ""), Some(@robust.make_issue("name", "field must not be empty", @robust.Severity::Error)))
  assert_eq(@robust.validate_non_empty("name", "value"), None)
}

test "validate: function name empty" {
  let result = @robust.validate_function_name("")
  let has_issue = match result {
    Some(_) => true
    None => false
  }
  assert_true(has_issue)
}

test "validate: function name with space" {
  let result = @robust.validate_function_name("my func")
  let has_issue = match result {
    Some(_) => true
    None => false
  }
  assert_true(has_issue)
}

test "validate: function name valid" {
  assert_eq(@robust.validate_function_name("valid_name"), None)
}

test "validate: platform compatibility warning" {
  let result = @robust.validate_platform_compatibility("windows_init", @core.Platform::Ohos)
  let has_issue = match result {
    Some(_) => true
    None => false
  }
  assert_true(has_issue)
}

test "validate: platform compatibility ok" {
  assert_eq(@robust.validate_platform_compatibility("common_init", @core.Platform::Ohos), None)
  assert_eq(@robust.validate_platform_compatibility("any_func", @core.Platform::Windows), None)
}

test "validate: merge results" {
  let r1 = @robust.validation_invalid([@robust.make_issue("a", "err1", @robust.Severity::Error)])
  let r2 = @robust.validation_invalid([@robust.make_issue("b", "err2", @robust.Severity::Warning)])
  let merged = @robust.merge_validation([r1, r2])
  assert_eq(merged.issues.length(), 2)
}

test "validate: valid result" {
  let result = @robust.validation_valid()
  assert_true(result.valid)
  assert_eq(result.issues.length(), 0)
}

test "validate: invalid with error" {
  let result = @robust.validation_invalid([@robust.make_issue("a", "err", @robust.Severity::Error)])
  assert_false(result.valid)
}

test "validate: invalid with only warnings" {
  let result = @robust.validation_invalid([@robust.make_issue("a", "warn", @robust.Severity::Warning)])
  assert_true(result.valid)
}

test "validate: version" {
  assert_true(@robust.validate_version().contains("v0.0.8"))
}

test "boundary: reserved keywords" {
  assert_true(@robust.is_reserved_keyword("fn"))
  assert_true(@robust.is_reserved_keyword("macro"))
  assert_true(@robust.is_reserved_keyword("let"))
  assert_false(@robust.is_reserved_keyword("my_func"))
}

test "boundary: sanitize identifier" {
  assert_eq(@robust.sanitize_identifier("hello-world"), "hello_world")
  assert_eq(@robust.sanitize_identifier("test.name"), "test_name")
  assert_eq(@robust.sanitize_identifier("123abc"), "_123abc")
  assert_eq(@robust.sanitize_identifier("valid_name"), "valid_name")
  assert_eq(@robust.sanitize_identifier(""), "")
}

test "boundary: empty input" {
  let result = @robust.handle_empty_input([])
  assert_true(result.safe)
  assert_true(result.warning is Some(_))
}

test "boundary: non-empty input" {
  let result = @robust.handle_empty_input(["a", "b"])
  assert_true(result.safe)
  assert_true(result.warning is None)
}

test "boundary: large input" {
  let items = ["a", "b", "c", "d", "e"]
  let result = @robust.handle_large_input(items, 3)
  assert_false(result.safe)
}

test "boundary: input within limit" {
  let items = ["a", "b", "c"]
  let result = @robust.handle_large_input(items, 5)
  assert_true(result.safe)
}

test "boundary: identifier safety reserved" {
  let result = @robust.check_identifier_safety("fn")
  assert_false(result.safe)
}

test "boundary: identifier safety empty" {
  let result = @robust.check_identifier_safety("")
  assert_false(result.safe)
}

test "boundary: identifier safety valid" {
  let result = @robust.check_identifier_safety("valid_name")
  assert_true(result.safe)
}

test "boundary: identifier safety special chars" {
  let result = @robust.check_identifier_safety("hello-world")
  assert_false(result.safe)
}

test "boundary: unicode detection" {
  assert_true(@robust.has_unicode("hello世界"))
  assert_false(@robust.has_unicode("hello"))
  assert_false(@robust.has_unicode("test_123"))
}

test "boundary: version" {
  assert_true(@robust.boundary_version().contains("v0.0.8"))
}
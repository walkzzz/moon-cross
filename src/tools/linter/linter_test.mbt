fn make_test_config(
  module_path : String,
  functions : Array[@config.ExportFunction],
  targets : Array[@core.Platform],
  version : Int,
) -> @config.CrossConfig {
  {
    version,
    module_path,
    package_name: module_path,
    targets,
    functions,
    types: [],
  }
}

fn make_test_fn(
  name : String,
  params : Array[@config.ExportParam],
  return_type : String,
) -> @config.ExportFunction {
  { name, params, return_type }
}

test "lint_severity_to_string" {
  assert_eq(@linter.LintSeverity::Info.to_string(), "info")
  assert_eq(@linter.LintSeverity::Warning.to_string(), "warning")
  assert_eq(@linter.LintSeverity::Error.to_string(), "error")
}

test "make_rule_basic" {
  let rule = @linter.make_rule("MC001", "test", "desc", @linter.LintSeverity::Error)
  assert_eq(rule.id, "MC001")
  assert_eq(rule.name, "test")
  assert_true(rule.enabled)
}

test "make_disabled_rule" {
  let rule = @linter.make_disabled_rule("MC001", "test", "desc", @linter.LintSeverity::Error)
  assert_true(!rule.enabled)
}

test "rule_module_path_format" {
  let rule = @linter.rule_module_path_format()
  assert_eq(rule.id, "MC001")
  assert_eq(rule.severity, @linter.LintSeverity::Error)
}

test "rule_function_name_format" {
  let rule = @linter.rule_function_name_format()
  assert_eq(rule.id, "MC002")
  assert_eq(rule.severity, @linter.LintSeverity::Warning)
}

test "default_lint_config_rules" {
  let cfg = @linter.default_lint_config()
  assert_eq(cfg.rules.length(), 8)
  assert_true(cfg.fail_on_error)
  assert_true(!cfg.fail_on_warning)
}

test "check_module_path_valid" {
  let issues = @linter.check_module_path("walkzzz/moon-cross")
  assert_eq(issues.length(), 0)
}

test "check_module_path_empty" {
  let issues = @linter.check_module_path("")
  assert_eq(issues.length(), 1)
  assert_eq(issues[0].severity, @linter.LintSeverity::Error)
}

test "check_module_path_no_slash" {
  let issues = @linter.check_module_path("mooncross")
  assert_eq(issues.length(), 1)
  assert_eq(issues[0].rule_id, "MC001")
}

test "check_function_name_snake_case" {
  let issues = @linter.check_function_name("my_function")
  assert_eq(issues.length(), 0)
}

test "check_function_name_camel_case" {
  let issues = @linter.check_function_name("myFunction")
  assert_eq(issues.length(), 1)
  assert_eq(issues[0].rule_id, "MC002")
}

test "check_non_empty_exports_valid" {
  let fns = [make_test_fn("test", [], "Int")]
  let issues = @linter.check_non_empty_exports(fns)
  assert_eq(issues.length(), 0)
}

test "check_non_empty_exports_empty" {
  let fns : Array[@config.ExportFunction] = []
  let issues = @linter.check_non_empty_exports(fns)
  assert_eq(issues.length(), 1)
  assert_eq(issues[0].rule_id, "MC003")
}

test "check_non_empty_targets_valid" {
  let targets = [@core.Platform::Windows]
  let issues = @linter.check_non_empty_targets(targets)
  assert_eq(issues.length(), 0)
}

test "check_non_empty_targets_empty" {
  let targets : Array[@core.Platform] = []
  let issues = @linter.check_non_empty_targets(targets)
  assert_eq(issues.length(), 1)
}

test "check_version_valid" {
  let issues = @linter.check_version(1)
  assert_eq(issues.length(), 0)
}

test "check_version_invalid" {
  let issues = @linter.check_version(0)
  assert_eq(issues.length(), 1)
  assert_eq(issues[0].rule_id, "MC005")
}

test "check_duplicate_functions_none" {
  let fns = [
    make_test_fn("func_a", [], "Int"),
    make_test_fn("func_b", [], "Int"),
  ]
  let issues = @linter.check_duplicate_functions(fns)
  assert_eq(issues.length(), 0)
}

test "check_duplicate_functions_found" {
  let fns = [
    make_test_fn("func_a", [], "Int"),
    make_test_fn("func_a", [], "Int"),
  ]
  let issues = @linter.check_duplicate_functions(fns)
  assert_eq(issues.length(), 1)
  assert_eq(issues[0].rule_id, "MC006")
}

test "check_return_type_valid" {
  let fns = [make_test_fn("test", [], "Int")]
  let issues = @linter.check_return_type(fns)
  assert_eq(issues.length(), 0)
}

test "check_return_type_unknown" {
  let fns = [make_test_fn("test", [], "MyCustomType")]
  let issues = @linter.check_return_type(fns)
  assert_eq(issues.length(), 1)
  assert_eq(issues[0].rule_id, "MC007")
}

test "check_param_types_valid" {
  let fns = [make_test_fn("test", [{ name: "x", typ: "Int" }], "Int")]
  let issues = @linter.check_param_types(fns)
  assert_eq(issues.length(), 0)
}

test "check_param_types_unknown" {
  let fns = [make_test_fn("test", [{ name: "x", typ: "MyType" }], "Int")]
  let issues = @linter.check_param_types(fns)
  assert_eq(issues.length(), 1)
  assert_eq(issues[0].rule_id, "MC008")
}

test "lint_config_valid" {
  let cfg = make_test_config(
    "walkzzz/moon-cross",
    [make_test_fn("test_func", [], "Int")],
    [@core.Platform::Windows],
    1,
  )
  let result = @linter.lint_config(cfg)
  assert_true(result.passed)
  assert_eq(result.error_count, 0)
}

test "lint_config_empty_functions" {
  let cfg = make_test_config(
    "walkzzz/moon-cross",
    [],
    [@core.Platform::Windows],
    1,
  )
  let result = @linter.lint_config(cfg)
  assert_true(!result.passed)
  assert_true(result.error_count > 0)
}

test "lint_config_bad_module_path" {
  let cfg = make_test_config(
    "invalid",
    [make_test_fn("test_func", [], "Int")],
    [@core.Platform::Windows],
    1,
  )
  let result = @linter.lint_config(cfg)
  assert_true(!result.passed)
}

test "lint_config_duplicate_functions" {
  let cfg = make_test_config(
    "walkzzz/moon-cross",
    [
      make_test_fn("dup_func", [], "Int"),
      make_test_fn("dup_func", [], "Int"),
    ],
    [@core.Platform::Windows],
    1,
  )
  let result = @linter.lint_config(cfg)
  assert_true(!result.passed)
  assert_true(result.error_count > 0)
}

test "lint_config_camel_case_warning" {
  let cfg = make_test_config(
    "walkzzz/moon-cross",
    [make_test_fn("myFunction", [], "Int")],
    [@core.Platform::Windows],
    1,
  )
  let result = @linter.lint_config(cfg)
  assert_true(result.warning_count > 0)
}

test "summarize_empty" {
  let result = @linter.summarize([])
  assert_true(result.passed)
  assert_eq(result.error_count, 0)
  assert_eq(result.warning_count, 0)
}

test "summarize_with_errors" {
  let issues = [
    @linter.make_issue("MC001", @linter.LintSeverity::Error, "err1", "loc1"),
    @linter.make_issue("MC002", @linter.LintSeverity::Warning, "warn1", "loc2"),
  ]
  let result = @linter.summarize(issues)
  assert_true(!result.passed)
  assert_eq(result.error_count, 1)
  assert_eq(result.warning_count, 1)
}

test "format_issue_basic" {
  let issue = @linter.make_issue("MC001", @linter.LintSeverity::Error, "test error", "loc")
  let formatted = @linter.format_issue(issue)
  assert_true(formatted.contains("MC001"))
  assert_true(formatted.contains("error"))
  assert_true(formatted.contains("test error"))
}

test "format_result_passed" {
  let result = @linter.summarize([])
  let formatted = @linter.format_result(result)
  assert_true(formatted.contains("PASSED"))
}

test "format_result_failed" {
  let issues = [@linter.make_issue("MC001", @linter.LintSeverity::Error, "err", "loc")]
  let result = @linter.summarize(issues)
  let formatted = @linter.format_result(result)
  assert_true(formatted.contains("FAILED"))
}

test "linter_version" {
  let v = @linter.linter_version()
  assert_true(v.contains("linter"))
}

test "enabled_rules" {
  let cfg = @linter.default_lint_config()
  let enabled = @linter.enabled_rules(cfg)
  assert_eq(enabled.length(), 8)
}

test "disabled_rules" {
  let cfg = @linter.default_lint_config()
  let disabled = @linter.disabled_rules(cfg)
  assert_eq(disabled.length(), 0)
}

test "filter_by_severity" {
  let issues = [
    @linter.make_issue("MC001", @linter.LintSeverity::Info, "i", "l"),
    @linter.make_issue("MC002", @linter.LintSeverity::Warning, "w", "l"),
    @linter.make_issue("MC003", @linter.LintSeverity::Error, "e", "l"),
  ]
  let filtered = @linter.filter_by_severity(issues, @linter.LintSeverity::Warning)
  assert_eq(filtered.length(), 2)
}

test "enable_rule" {
  let cfg = @linter.default_lint_config()
  let updated = @linter.disable_rule(cfg, "MC001")
  let re_enabled = @linter.enable_rule(updated, "MC001")
  let enabled = @linter.enabled_rules(re_enabled)
  assert_eq(enabled.length(), 8)
}

test "disable_rule" {
  let cfg = @linter.default_lint_config()
  let updated = @linter.disable_rule(cfg, "MC001")
  let enabled = @linter.enabled_rules(updated)
  assert_eq(enabled.length(), 7)
  let disabled = @linter.disabled_rules(updated)
  assert_eq(disabled.length(), 1)
}
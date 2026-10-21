///|
/// Lint 严重级别 | Lint severity level
pub(all) enum LintSeverity {
  Info
  Warning
  Error
} derive(Debug, Eq)
pub extend LintSeverity with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LintSeverity with Eq::{not_equal, equal}

///|
/// Lint 严重级别转字符串 | Convert lint severity to string
pub fn LintSeverity::to_string(self : LintSeverity) -> String {
  match self {
    Info => "info"
    Warning => "warning"
    Error => "error"
  }
}

///|
/// Lint 规则 | Lint rule
pub(all) struct LintRule {
  id : String
  name : String
  description : String
  severity : LintSeverity
  enabled : Bool
} derive(Debug, Eq)
pub extend LintRule with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LintRule with Eq::{not_equal, equal}

///|
/// Lint 问题 | Lint issue
pub(all) struct LintIssue {
  rule_id : String
  severity : LintSeverity
  message : String
  location : String
} derive(Debug, Eq)
pub extend LintIssue with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LintIssue with Eq::{not_equal, equal}

///|
/// Lint 结果 | Lint result
pub(all) struct LintResult {
  issues : Array[LintIssue]
  error_count : Int
  warning_count : Int
  info_count : Int
  passed : Bool
} derive(Debug, Eq)
pub extend LintResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LintResult with Eq::{not_equal, equal}

///|
/// Lint 配置 | Lint configuration
pub(all) struct LintConfig {
  rules : Array[LintRule]
  fail_on_error : Bool
  fail_on_warning : Bool
} derive(Debug, Eq)
pub extend LintConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LintConfig with Eq::{not_equal, equal}

///|
/// 创建 lint 规则 | Create lint rule
pub fn make_rule(
  id : String,
  name : String,
  description : String,
  severity : LintSeverity,
) -> LintRule {
  { id, name, description, severity, enabled: true }
}

///|
/// 创建禁用的 lint 规则 | Create disabled lint rule
pub fn make_disabled_rule(
  id : String,
  name : String,
  description : String,
  severity : LintSeverity,
) -> LintRule {
  { id, name, description, severity, enabled: false }
}

///|
/// 创建 lint 问题 | Create lint issue
pub fn make_issue(
  rule_id : String,
  severity : LintSeverity,
  message : String,
  location : String,
) -> LintIssue {
  { rule_id, severity, message, location }
}

///|
/// 内置规则：检查模块路径格式 | Built-in rule: check module path format
pub fn rule_module_path_format() -> LintRule {
  make_rule(
    "MC001",
    "module-path-format",
    "Module path must be in 'owner/repo' format",
    Error,
  )
}

///|
/// 内置规则：检查函数名格式 | Built-in rule: check function name format
pub fn rule_function_name_format() -> LintRule {
  make_rule(
    "MC002",
    "function-name-format",
    "Function names must be snake_case",
    Warning,
  )
}

///|
/// 内置规则：检查导出函数非空 | Built-in rule: check non-empty exports
pub fn rule_non_empty_exports() -> LintRule {
  make_rule(
    "MC003",
    "non-empty-exports",
    "At least one export function is required",
    Error,
  )
}

///|
/// 内置规则：检查目标平台非空 | Built-in rule: check non-empty targets
pub fn rule_non_empty_targets() -> LintRule {
  make_rule(
    "MC004",
    "non-empty-targets",
    "At least one target platform is required",
    Error,
  )
}

///|
/// 内置规则：检查版本号格式 | Built-in rule: check version format
pub fn rule_version_format() -> LintRule {
  make_rule(
    "MC005",
    "version-format",
    "Version must be a positive integer",
    Warning,
  )
}

///|
/// 内置规则：检查重复函数名 | Built-in rule: check duplicate function names
pub fn rule_no_duplicate_functions() -> LintRule {
  make_rule(
    "MC006",
    "no-duplicate-functions",
    "Export function names must be unique",
    Error,
  )
}

///|
/// 内置规则：检查返回类型有效 | Built-in rule: check valid return type
pub fn rule_valid_return_type() -> LintRule {
  make_rule(
    "MC007",
    "valid-return-type",
    "Return type must be a known type",
    Warning,
  )
}

///|
/// 内置规则：检查参数类型有效 | Built-in rule: check valid param type
pub fn rule_valid_param_type() -> LintRule {
  make_rule(
    "MC008",
    "valid-param-type",
    "Parameter type must be a known type",
    Warning,
  )
}

///|
/// 默认 lint 配置 | Default lint configuration
pub fn default_lint_config() -> LintConfig {
  {
    rules: [
      rule_module_path_format(),
      rule_function_name_format(),
      rule_non_empty_exports(),
      rule_non_empty_targets(),
      rule_version_format(),
      rule_no_duplicate_functions(),
      rule_valid_return_type(),
      rule_valid_param_type(),
    ],
    fail_on_error: true,
    fail_on_warning: false,
  }
}

///|
/// 检查模块路径格式 | Check module path format
pub fn check_module_path(path : String) -> Array[LintIssue] {
  if path.length() == 0 {
    [make_issue("MC001", Error, "Module path is empty", "module_path")]
  } else if !path.contains("/") {
    [make_issue("MC001", Error, "Module path must contain '/' separator: " + path, "module_path")]
  } else {
    []
  }
}

///|
/// 检查函数名格式（snake_case） | Check function name format (snake_case)
pub fn check_function_name(name : String) -> Array[LintIssue] {
  let has_upper = contains_uppercase(name)
  if has_upper {
    [make_issue("MC002", Warning, "Function name should be snake_case: " + name, "function:" + name)]
  } else {
    []
  }
}

///|
/// 检查是否包含大写字母 | Check if contains uppercase
fn contains_uppercase(s : String) -> Bool {
  for c in s.to_array() {
    let code = c.to_int()
    if code >= 65 && code <= 90 {
      return true
    }
  }
  false
}

///|
/// 检查导出函数非空 | Check non-empty exports
pub fn check_non_empty_exports(functions : Array[@config.ExportFunction]) -> Array[LintIssue] {
  if functions.length() == 0 {
    [make_issue("MC003", Error, "No export functions defined", "functions")]
  } else {
    []
  }
}

///|
/// 检查目标平台非空 | Check non-empty targets
pub fn check_non_empty_targets(targets : Array[@core.Platform]) -> Array[LintIssue] {
  if targets.length() == 0 {
    [make_issue("MC004", Error, "No target platforms specified", "targets")]
  } else {
    []
  }
}

///|
/// 检查版本号格式 | Check version format
pub fn check_version(version : Int) -> Array[LintIssue] {
  if version <= 0 {
    [make_issue("MC005", Warning, "Version should be positive: " + version.to_string(), "version")]
  } else {
    []
  }
}

///|
/// 检查重复函数名 | Check duplicate function names
pub fn check_duplicate_functions(
  functions : Array[@config.ExportFunction],
) -> Array[LintIssue] {
  let issues = []
  for i in 0..<functions.length() {
    for j in 0..<functions.length() {
      if i < j && functions[i].name == functions[j].name {
        issues.push(
          make_issue(
            "MC006",
            Error,
            "Duplicate function name: " + functions[i].name,
            "function:" + functions[i].name,
          ),
        )
      }
    }
  }
  issues
}

///|
/// 已知类型列表 | Known types list
fn known_types() -> Array[String] {
  ["Int", "UInt", "Double", "Bool", "String", "Bytes", "Unit", "Array", "Char"]
}

///|
/// 检查返回类型是否有效 | Check if return type is valid
pub fn check_return_type(
  functions : Array[@config.ExportFunction],
) -> Array[LintIssue] {
  let issues = []
  let types = known_types()
  for f in functions {
    let mut found = false
    for t in types {
      if t == f.return_type {
        found = true
      }
    }
    if !found {
      issues.push(
        make_issue(
          "MC007",
          Warning,
          "Unknown return type: " + f.return_type + " in function " + f.name,
          "function:" + f.name,
        ),
      )
    }
  }
  issues
}

///|
/// 检查参数类型是否有效 | Check if param types are valid
pub fn check_param_types(
  functions : Array[@config.ExportFunction],
) -> Array[LintIssue] {
  let issues = []
  let types = known_types()
  for f in functions {
    for p in f.params {
      let mut found = false
      for t in types {
        if t == p.typ {
          found = true
        }
      }
      if !found {
        issues.push(
          make_issue(
            "MC008",
            Warning,
            "Unknown param type: " + p.typ + " in function " + f.name + " param " + p.name,
            "function:" + f.name,
          ),
        )
      }
    }
  }
  issues
}

///|
/// 运行所有 lint 检查 | Run all lint checks
pub fn lint_config(config : @config.CrossConfig) -> LintResult {
  let all_issues = []
  for issue in check_module_path(config.module_path) {
    all_issues.push(issue)
  }
  for issue in check_non_empty_exports(config.functions) {
    all_issues.push(issue)
  }
  for issue in check_non_empty_targets(config.targets) {
    all_issues.push(issue)
  }
  for issue in check_version(config.version) {
    all_issues.push(issue)
  }
  for issue in check_duplicate_functions(config.functions) {
    all_issues.push(issue)
  }
  for issue in check_return_type(config.functions) {
    all_issues.push(issue)
  }
  for issue in check_param_types(config.functions) {
    all_issues.push(issue)
  }
  for f in config.functions {
    for issue in check_function_name(f.name) {
      all_issues.push(issue)
    }
  }
  summarize(all_issues)
}

///|
/// 汇总 lint 结果 | Summarize lint result
pub fn summarize(issues : Array[LintIssue]) -> LintResult {
  let mut errors = 0
  let mut warnings = 0
  let mut infos = 0
  for issue in issues {
    match issue.severity {
      Error => errors = errors + 1
      Warning => warnings = warnings + 1
      Info => infos = infos + 1
    }
  }
  { issues, error_count: errors, warning_count: warnings, info_count: infos, passed: errors == 0 }
}

///|
/// 格式化 lint 问题 | Format lint issue
pub fn format_issue(issue : LintIssue) -> String {
  issue.severity.to_string() + ": [" + issue.rule_id + "] " + issue.message + " (at " + issue.location + ")"
}

///|
/// 格式化 lint 结果 | Format lint result
pub fn format_result(result : LintResult) -> String {
  let mut output = "Lint Result:\n"
  output = output + "  Errors:   " + result.error_count.to_string() + "\n"
  output = output + "  Warnings: " + result.warning_count.to_string() + "\n"
  output = output + "  Info:     " + result.info_count.to_string() + "\n"
  let status = if result.passed {
    "PASSED"
  } else {
    "FAILED"
  }
  output = output + "  Status:   " + status + "\n"
  if result.issues.length() > 0 {
    output = output + "\nIssues:\n"
    for issue in result.issues {
      output = output + "  " + format_issue(issue) + "\n"
    }
  }
  output
}

///|
/// Lint 版本 | Linter version
pub fn linter_version() -> String {
  "moon-cross linter v0.1.8"
}

///|
/// 获取启用的规则 | Get enabled rules
pub fn enabled_rules(config : LintConfig) -> Array[LintRule] {
  let result = []
  for rule in config.rules {
    if rule.enabled {
      result.push(rule)
    }
  }
  result
}

///|
/// 获取禁用的规则 | Get disabled rules
pub fn disabled_rules(config : LintConfig) -> Array[LintRule] {
  let result = []
  for rule in config.rules {
    if !rule.enabled {
      result.push(rule)
    }
  }
  result
}

///|
/// 按严重级别过滤问题 | Filter issues by severity
pub fn filter_by_severity(
  issues : Array[LintIssue],
  min_severity : LintSeverity,
) -> Array[LintIssue] {
  let result = []
  for issue in issues {
    let issue_level = match issue.severity {
      Info => 0
      Warning => 1
      Error => 2
    }
    let min_level = match min_severity {
      Info => 0
      Warning => 1
      Error => 2
    }
    if issue_level >= min_level {
      result.push(issue)
    }
  }
  result
}

///|
/// 启用规则 | Enable rule
pub fn enable_rule(
  config : LintConfig,
  rule_id : String,
) -> LintConfig {
  let new_rules = []
  for rule in config.rules {
    if rule.id == rule_id {
      new_rules.push({ ..rule, enabled: true })
    } else {
      new_rules.push(rule)
    }
  }
  { ..config, rules: new_rules }
}

///|
/// 禁用规则 | Disable rule
pub fn disable_rule(
  config : LintConfig,
  rule_id : String,
) -> LintConfig {
  let new_rules = []
  for rule in config.rules {
    if rule.id == rule_id {
      new_rules.push({ ..rule, enabled: false })
    } else {
      new_rules.push(rule)
    }
  }
  { ..config, rules: new_rules }
}

///|
/// LintRule 实现 Named trait | LintRule implements Named
pub impl @trait.Named for LintRule with name(self) {
  self.name
}
pub extend LintRule with @trait.Named::{name}
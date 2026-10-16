///|
/// 校验严重级别 | Validation severity level
pub(all) enum Severity {
  Error
  Warning
  Info
} derive(Debug, Eq)

pub extend Severity with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Severity with Eq::{not_equal, equal}

///|
/// 校验问题 | Validation issue
pub(all) struct ValidationIssue {
  field : String
  message : String
  severity : Severity
} derive(Debug, Eq)

pub extend ValidationIssue with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ValidationIssue with Eq::{not_equal, equal}

///|
/// 校验结果 | Validation result
pub(all) struct ValidationResult {
  valid : Bool
  issues : Array[ValidationIssue]
} derive(Debug, Eq)

pub extend ValidationResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ValidationResult with Eq::{not_equal, equal}

///|
/// 创建校验问题 | Create validation issue
pub fn make_issue(field : String, message : String, severity : Severity) -> ValidationIssue {
  { field, message, severity }
}

///|
/// 创建有效校验结果 | Create valid validation result
pub fn validation_valid() -> ValidationResult {
  { valid: true, issues: [] }
}

///|
/// 创建无效校验结果 | Create invalid validation result
pub fn validation_invalid(issues : Array[ValidationIssue]) -> ValidationResult {
  let mut has_error = false
  for issue in issues {
    if issue.severity is Error {
      has_error = true
    }
  }
  { valid: !has_error, issues }
}

///|
/// 校验配置字段非空 | Validate config field is non-empty
pub fn validate_non_empty(field : String, value : String) -> ValidationIssue? {
  if value.length() == 0 {
    Some(make_issue(field, "field must not be empty", Error))
  } else {
    None
  }
}

///|
/// 校验函数名合法性 | Validate function name legality
pub fn validate_function_name(name : String) -> ValidationIssue? {
  if name.length() == 0 {
    Some(make_issue("function_name", "function name must not be empty", Error))
  } else if name.contains(" ") {
    Some(make_issue("function_name", "function name must not contain spaces", Error))
  } else {
    None
  }
}

///|
/// 校验平台兼容性 | Validate platform compatibility
pub fn validate_platform_compatibility(
  func_name : String,
  platform : @core.Platform,
) -> ValidationIssue? {
  match platform {
    Ohos => {
      if func_name.contains("windows") || func_name.contains("ios") {
        Some(make_issue("platform_compat", "function \{func_name} may not be compatible with HarmonyOS", Warning))
      } else {
        None
      }
    }
    _ => None
  }
}

///|
/// 合并校验结果 | Merge validation results
pub fn merge_validation(results : Array[ValidationResult]) -> ValidationResult {
  let all_issues = []
  for result in results {
    for issue in result.issues {
      all_issues.push(issue)
    }
  }
  validation_invalid(all_issues)
}

///|
/// 校验版本 | Validation version
pub fn validate_version() -> String {
  "moon-cross robust/validate v0.0.8"
}
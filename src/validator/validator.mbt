///|
/// 验证错误 | Validation error
pub(all) struct ValidationError {
  field : String
  message : String
  code : String
} derive(Debug, Eq)
pub extend ValidationError with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ValidationError with Eq::{not_equal, equal}

///|
/// 验证结果 | Validation result
pub(all) struct ValidationResult {
  valid : Bool
  errors : Array[ValidationError]
} derive(Debug, Eq)
pub extend ValidationResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ValidationResult with Eq::{not_equal, equal}

///|
/// 验证配置 | Validation configuration
pub(all) struct ValidationConfig {
  strict : Bool
  stop_on_first_error : Bool
} derive(Debug, Eq)
pub extend ValidationConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ValidationConfig with Eq::{not_equal, equal}

///|
/// 验证规则 | Validation rule
pub(all) struct ValidationRule {
  name : String
  description : String
  enabled : Bool
} derive(Debug, Eq)
pub extend ValidationRule with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ValidationRule with Eq::{not_equal, equal}

///|
/// 默认验证配置 | Default validation configuration
pub fn default_validation_config() -> ValidationConfig {
  { strict: false, stop_on_first_error: false }
}

///|
/// 创建验证错误 | Create validation error
pub fn make_error(
  field : String,
  message : String,
  code : String,
) -> ValidationError {
  { field, message, code }
}

///|
/// 创建验证结果 | Create validation result
pub fn create_result(errors : Array[ValidationError]) -> ValidationResult {
  { valid: errors.length() == 0, errors }
}

///|
/// 有效结果 | Valid result
pub fn valid_result() -> ValidationResult {
  { valid: true, errors: [] }
}

///|
/// 是否有效 | Check if valid
pub fn is_valid(result : ValidationResult) -> Bool {
  result.valid
}

///|
/// 错误数 | Error count
pub fn error_count(result : ValidationResult) -> Int {
  result.errors.length()
}

///|
/// 验证必填 | Validate required
pub fn validate_required(value : String) -> ValidationError? {
  if value.length() == 0 {
    return Some({ field: "value", message: "Value is required", code: "REQUIRED" })
  }
  None
}

///|
/// 验证必填（带字段名） | Validate required with field name
pub fn validate_required_field(
  field : String,
  value : String,
) -> ValidationError? {
  if value.length() == 0 {
    return Some({ field, message: field + " is required", code: "REQUIRED" })
  }
  None
}

///|
/// 验证最小长度 | Validate min length
pub fn validate_min_length(
  field : String,
  value : String,
  min : Int,
) -> ValidationError? {
  if value.length() < min {
    return Some({ field, message: field + " must be at least " + min.to_string() + " characters", code: "MIN_LENGTH" })
  }
  None
}

///|
/// 验证最大长度 | Validate max length
pub fn validate_max_length(
  field : String,
  value : String,
  max : Int,
) -> ValidationError? {
  if value.length() > max {
    return Some({ field, message: field + " must be at most " + max.to_string() + " characters", code: "MAX_LENGTH" })
  }
  None
}

///|
/// 验证最小值 | Validate min value
pub fn validate_min_value(
  field : String,
  value : Int,
  min : Int,
) -> ValidationError? {
  if value < min {
    return Some({ field, message: field + " must be at least " + min.to_string(), code: "MIN_VALUE" })
  }
  None
}

///|
/// 验证最大值 | Validate max value
pub fn validate_max_value(
  field : String,
  value : Int,
  max : Int,
) -> ValidationError? {
  if value > max {
    return Some({ field, message: field + " must be at most " + max.to_string(), code: "MAX_VALUE" })
  }
  None
}

///|
/// 验证非空 | Validate not empty
pub fn validate_not_empty(
  field : String,
  value : Array[String],
) -> ValidationError? {
  if value.length() == 0 {
    return Some({ field, message: field + " must not be empty", code: "NOT_EMPTY" })
  }
  None
}

///|
/// 合并验证结果 | Merge validation results
pub fn merge_results(
  r1 : ValidationResult,
  r2 : ValidationResult,
) -> ValidationResult {
  let errors = []
  for e in r1.errors {
    errors.push(e)
  }
  for e in r2.errors {
    errors.push(e)
  }
  { valid: errors.length() == 0, errors }
}

///|
/// 格式化错误 | Format errors
pub fn format_errors(errors : Array[ValidationError]) -> String {
  let mut result = ""
  for error in errors {
    result = result + "[" + error.code + "] " + error.field + ": " + error.message + "\n"
  }
  result
}

///|
/// 格式化结果 | Format result
pub fn format_result(result : ValidationResult) -> String {
  if result.valid {
    return "Validation: PASSED"
  }
  "Validation: FAILED\n" + format_errors(result.errors)
}

///|
/// 按字段过滤错误 | Filter errors by field
pub fn filter_errors_by_field(
  errors : Array[ValidationError],
  field : String,
) -> Array[ValidationError] {
  let result = []
  for error in errors {
    if error.field == field {
      result.push(error)
    }
  }
  result
}

///|
/// 按错误码过滤 | Filter errors by code
pub fn filter_errors_by_code(
  errors : Array[ValidationError],
  code : String,
) -> Array[ValidationError] {
  let result = []
  for error in errors {
    if error.code == code {
      result.push(error)
    }
  }
  result
}

///|
/// 收集错误字段 | Collect error fields
pub fn error_fields(errors : Array[ValidationError]) -> Array[String] {
  let result : Array[String] = []
  for error in errors {
    let mut found = false
    for f in result {
      if f == error.field {
        found = true
        break
      }
    }
    if !found {
      result.push(error.field)
    }
  }
  result
}

///|
/// 验证器版本 | Validator version
pub fn validator_version() -> String {
  "moon-cross validator v0.2.9"
}

///|
/// 内置验证规则 | Built-in validation rules
pub fn builtin_rules() -> Array[ValidationRule] {
  [
    { name: "required", description: "Field is required", enabled: true },
    { name: "min-length", description: "Minimum length check", enabled: true },
    { name: "max-length", description: "Maximum length check", enabled: true },
    { name: "min-value", description: "Minimum value check", enabled: true },
    { name: "max-value", description: "Maximum value check", enabled: true },
    { name: "not-empty", description: "Non-empty check", enabled: true },
    { name: "pattern", description: "Pattern match check", enabled: true },
    { name: "email", description: "Email format check", enabled: true },
  ]
}

///|
/// 批量验证 | Batch validate
pub fn batch_validate(
  checks : Array[ValidationError?],
) -> ValidationResult {
  let errors = []
  for check in checks {
    match check {
      Some(e) => errors.push(e)
      None => continue
    }
  }
  { valid: errors.length() == 0, errors }
}

///|
/// ValidationRule 实现 Named trait | ValidationRule implements Named
pub impl @trait.Named for ValidationRule with name(self) {
  self.name
}
pub extend ValidationRule with @trait.Named::{name}
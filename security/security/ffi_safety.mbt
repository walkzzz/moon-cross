///|
/// 安全检查类型 | Safety check type
pub(all) enum SafetyCheckType {
  NullCheck
  BufferBounds
  TypeCheck
  LifetimeCheck
} derive(Debug, Eq)

pub extend SafetyCheckType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SafetyCheckType with Eq::{not_equal, equal}

///|
/// 安全问题 | Safety issue
pub(all) struct SafetyIssue {
  check_type : SafetyCheckType
  function_name : String
  message : String
  severity : String
} derive(Debug, Eq)

pub extend SafetyIssue with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SafetyIssue with Eq::{not_equal, equal}

///|
/// FFI 安全检查结果 | FFI safety check result
pub(all) struct FfiSafetyResult {
  safe : Bool
  issues : Array[SafetyIssue]
  injected_checks : Array[String]
} derive(Debug, Eq)

pub extend FfiSafetyResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FfiSafetyResult with Eq::{not_equal, equal}

///|
/// 创建安全问题 | Create safety issue
pub fn make_safety_issue(
  check_type : SafetyCheckType,
  function_name : String,
  message : String,
  severity : String,
) -> SafetyIssue {
  { check_type, function_name, message, severity }
}

///|
/// 检查空指针安全 | Check null safety
pub fn check_null_safety(function_name : String, params : Array[String]) -> SafetyIssue? {
  let mut has_pointer_param = false
  for param in params {
    if param.contains("*") {
      has_pointer_param = true
    }
  }
  if has_pointer_param {
    Some(make_safety_issue(NullCheck, function_name, "pointer parameter requires null check", "warning"))
  } else {
    None
  }
}

///|
/// 检查缓冲区边界 | Check buffer bounds
pub fn check_buffer_bounds(function_name : String, has_array_param : Bool) -> SafetyIssue? {
  if has_array_param {
    Some(make_safety_issue(BufferBounds, function_name, "array parameter requires bounds check", "warning"))
  } else {
    None
  }
}

///|
/// 检查类型安全 | Check type safety
pub fn check_type_safety(function_name : String, return_type : String) -> SafetyIssue? {
  if return_type.contains("*") {
    Some(make_safety_issue(TypeCheck, function_name, "raw pointer return type is unsafe", "error"))
  } else {
    None
  }
}

///|
/// 生成安全包装代码 | Generate safety wrapper code
pub fn generate_safety_wrapper(function_name : String, params : Array[String]) -> String {
  let mut code = "// Safety wrapper for \{function_name}\n"
  code = code + "int safe_\{function_name}("
  let mut first = true
  for param in params {
    if !first {
      code = code + ", "
    }
    code = code + param
    first = false
  }
  code = code + ") {\n"
  let mut check_index = 0
  for param in params {
    if param.contains("*") {
      let param_name = extract_param_name(param)
      code = code + "  if (\{param_name} == NULL) return -1; // null check\n"
      check_index = check_index + 1
    }
  }
  code = code + "  return \{function_name}("
  first = true
  for param in params {
    let param_name = extract_param_name(param)
    if !first {
      code = code + ", "
    }
    code = code + param_name
    first = false
  }
  code = code + ");\n"
  code = code + "}\n"
  code
}

///|
/// 提取参数名 | Extract parameter name
fn extract_param_name(param : String) -> String {
  let mut last_space = -1
  let mut i = 0
  for ch in param {
    if ch == ' ' || ch == '*' {
      last_space = i
    }
    i = i + 1
  }
  if last_space >= 0 && last_space < param.length() - 1 {
    let mut result = ""
    let mut j = 0
    let mut started = false
    for ch in param {
      if j > last_space && ch != ' ' && ch != '*' {
        started = true
      }
      if started {
        result = result + ch.to_string()
      }
      j = j + 1
    }
    result
  } else {
    param
  }
}

///|
/// 综合安全检查 | Comprehensive safety check
pub fn comprehensive_safety_check(
  function_name : String,
  params : Array[String],
  return_type : String,
) -> FfiSafetyResult {
  let issues = []
  let null_check = check_null_safety(function_name, params)
  match null_check {
    Some(issue) => issues.push(issue)
    None => ()
  }
  let mut has_array = false
  for param in params {
    if param.contains("[]") || param.contains("Array") {
      has_array = true
    }
  }
  let buffer_check = check_buffer_bounds(function_name, has_array)
  match buffer_check {
    Some(issue) => issues.push(issue)
    None => ()
  }
  let type_check = check_type_safety(function_name, return_type)
  match type_check {
    Some(issue) => issues.push(issue)
    None => ()
  }
  let injected = []
  for issue in issues {
    injected.push("// \{issue.check_type.to_string()} for \{issue.function_name}")
  }
  let mut has_error = false
  for issue in issues {
    if issue.severity == "error" {
      has_error = true
    }
  }
  { safe: !has_error, issues, injected_checks: injected }
}

///|
/// SafetyCheckType 转字符串 | SafetyCheckType to string
pub fn SafetyCheckType::to_string(self : SafetyCheckType) -> String {
  match self {
    NullCheck => "NullCheck"
    BufferBounds => "BufferBounds"
    TypeCheck => "TypeCheck"
    LifetimeCheck => "LifetimeCheck"
  }
}

///|
/// FFI 安全版本 | FFI safety version
pub fn ffi_safety_version() -> String {
  "moon-cross security/ffi_safety v0.0.9"
}


///|
/// AsanConfig 实现 Checkable trait | AsanConfig implements Checkable
pub impl @trait.Checkable for AsanConfig with check(self) {
  self.enabled
}
pub extend AsanConfig with @trait.Checkable::{check}

///|
/// AsanResult 实现 Checkable trait | AsanResult implements Checkable
pub impl @trait.Checkable for AsanResult with check(self) {
  self.passed
}
pub extend AsanResult with @trait.Checkable::{check}

///|
/// AsanResult 实现 Countable trait | AsanResult implements Countable
pub impl @trait.Countable for AsanResult with count(self) {
  self.errors.length()
}
pub extend AsanResult with @trait.Countable::{count}

///|
/// SandboxResult 实现 Checkable trait | SandboxResult implements Checkable
pub impl @trait.Checkable for SandboxResult with check(self) {
  self.success
}
pub extend SandboxResult with @trait.Checkable::{check}
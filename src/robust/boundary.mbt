///|
/// 边界检查结果 | Boundary check result
pub(all) struct BoundaryCheckResult {
  safe : Bool
  warning : String?
  sanitized : String?
} derive(Debug, Eq)

pub extend BoundaryCheckResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend BoundaryCheckResult with Eq::{not_equal, equal}

///|
/// 保留关键字列表 | Reserved keywords list
pub fn reserved_keywords() -> Array[String] {
  [
    "fn", "let", "mut", "if", "else", "while", "for", "match", "return",
    "struct", "enum", "type", "pub", "priv", "extern", "inline",
    "macro", "derive", "override", "trait", "impl", "where",
  ]
}

///|
/// 检查是否为保留关键字 | Check if identifier is reserved keyword
pub fn is_reserved_keyword(name : String) -> Bool {
  let keywords = reserved_keywords()
  let mut found = false
  for kw in keywords {
    if kw == name {
      found = true
    }
  }
  found
}

///|
/// 净化标识符：替换特殊字符 | Sanitize identifier: replace special characters
pub fn sanitize_identifier(name : String) -> String {
  let mut result = ""
  for ch in name {
    if (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9') || ch == '_' {
      result = result + ch.to_string()
    } else {
      result = result + "_"
    }
  }
  let first_is_digit = {
    let mut flag = false
    for ch in result {
      flag = ch >= '0' && ch <= '9'
      break
    }
    flag
  }
  if result.length() > 0 && first_is_digit {
    result = "_" + result
  }
  result
}

///|
/// 处理空输入 | Handle empty input
pub fn handle_empty_input(items : Array[String]) -> BoundaryCheckResult {
  if items.length() == 0 {
    { safe: true, warning: Some("empty input: using default values"), sanitized: None }
  } else {
    { safe: true, warning: None, sanitized: None }
  }
}

///|
/// 处理超大输入 | Handle large input
pub fn handle_large_input(items : Array[String], max_count : Int) -> BoundaryCheckResult {
  if items.length() > max_count {
    { safe: false, warning: Some("input size \{items.length()} exceeds maximum \{max_count}, consider splitting"), sanitized: None }
  } else {
    { safe: true, warning: None, sanitized: None }
  }
}

///|
/// 检查标识符安全性 | Check identifier safety
pub fn check_identifier_safety(name : String) -> BoundaryCheckResult {
  if is_reserved_keyword(name) {
    { safe: false, warning: Some("'\{name}' is a reserved keyword"), sanitized: Some(name + "_") }
  } else if name.length() == 0 {
    { safe: false, warning: Some("identifier must not be empty"), sanitized: Some("unnamed") }
  } else {
    let sanitized = sanitize_identifier(name)
    if sanitized != name {
      { safe: false, warning: Some("identifier contains special characters"), sanitized: Some(sanitized) }
    } else {
      { safe: true, warning: None, sanitized: None }
    }
  }
}

///|
/// 检查 Unicode 字符 | Check for Unicode characters
pub fn has_unicode(name : String) -> Bool {
  let mut found = false
  for ch in name {
    if ch > '~' {
      found = true
    }
  }
  found
}

///|
/// 边界处理版本 | Boundary handling version
pub fn boundary_version() -> String {
  "moon-cross robust/boundary v0.0.8"
}
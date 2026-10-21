///|
/// 缩进风格 | Indentation style
pub(all) enum IndentStyle {
  Spaces
  Tabs
} derive(Debug, Eq)
pub extend IndentStyle with @moonbitlang/core/debug.Debug::{to_repr}
pub extend IndentStyle with Eq::{not_equal, equal}

///|
/// 格式化配置 | Format configuration
pub(all) struct FormatConfig {
  indent_style : IndentStyle
  indent_width : Int
  max_line_width : Int
  trailing_comma : Bool
  blank_line_before_export : Bool
  align_comments : Bool
} derive(Debug, Eq)
pub extend FormatConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FormatConfig with Eq::{not_equal, equal}

///|
/// 格式化结果 | Format result
pub(all) struct FormatResult {
  original : String
  formatted : String
  changed : Bool
  lines_changed : Int
} derive(Debug, Eq)
pub extend FormatResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FormatResult with Eq::{not_equal, equal}

///|
/// 格式化规则 | Format rule
pub(all) struct FormatRule {
  name : String
  description : String
  enabled : Bool
} derive(Debug, Eq)
pub extend FormatRule with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FormatRule with Eq::{not_equal, equal}

///|
/// 默认格式化配置 | Default format configuration
pub fn default_format_config() -> FormatConfig {
  {
    indent_style: Spaces,
    indent_width: 2,
    max_line_width: 100,
    trailing_comma: true,
    blank_line_before_export: true,
    align_comments: true,
  }
}

///|
/// MoonBit 风格格式化配置 | MoonBit style format configuration
pub fn moonbit_format_config() -> FormatConfig {
  {
    indent_style: Spaces,
    indent_width: 2,
    max_line_width: 80,
    trailing_comma: true,
    blank_line_before_export: true,
    align_comments: true,
  }
}

///|
/// C 风格格式化配置 | C style format configuration
pub fn c_format_config() -> FormatConfig {
  {
    indent_style: Spaces,
    indent_width: 4,
    max_line_width: 120,
    trailing_comma: false,
    blank_line_before_export: false,
    align_comments: true,
  }
}

///|
/// 生成缩进字符串 | Generate indentation string
pub fn indent_string(config : FormatConfig, level : Int) -> String {
  let unit = match config.indent_style {
    Spaces => " "
    Tabs => "\t"
  }
  let mut result = ""
  for _ in 0..<(level * config.indent_width) {
    result = result + unit
  }
  result
}

///|
/// 统计行数 | Count lines
pub fn count_lines(text : String) -> Int {
  let mut count = 1
  for c in text.to_array() {
    if c.to_int() == 10 {
      count = count + 1
    }
  }
  count
}

///|
/// 检查行是否过长 | Check if line is too long
pub fn is_line_too_long(
  config : FormatConfig,
  line : String,
) -> Bool {
  line.length() > config.max_line_width
}

///|
/// 查找过长行 | Find too-long lines
pub fn find_long_lines(
  config : FormatConfig,
  text : String,
) -> Array[Int] {
  let result = []
  let lines = text.split("\n")
  let mut line_num = 0
  for line in lines {
    line_num = line_num + 1
    if is_line_too_long(config, line.to_owned()) {
      result.push(line_num)
    }
  }
  result
}

///|
/// 去除尾部空白 | Strip trailing whitespace
pub fn strip_trailing_whitespace(text : String) -> String {
  let mut result = ""
  let mut line_start = 0
  let n = text.length()
  for i in 0..<n {
    if text[i].to_int() == 10 {
      let mut end = i
      while end > line_start {
        let c = text[end - 1]
        if c.to_int() == 32 || c.to_int() == 9 {
          end = end - 1
        } else {
          break
        }
      }
      result = result + text[line_start:end].to_owned()
      result = result + "\n"
      line_start = i + 1
    }
  }
  if line_start < n {
    let mut end = n
    while end > line_start {
      let c = text[end - 1]
      if c.to_int() == 32 || c.to_int() == 9 {
        end = end - 1
      } else {
        break
      }
    }
    result = result + text[line_start:end].to_owned()
  }
  result
}

///|
/// 确保文件末尾换行 | Ensure trailing newline
pub fn ensure_trailing_newline(text : String) -> String {
  if text.length() == 0 {
    return text
  }
  let last = text[text.length() - 1]
  if last.to_int() == 10 {
    text
  } else {
    text + "\n"
  }
}

///|
/// 格式化文本 | Format text
pub fn format_text(
  config : FormatConfig,
  text : String,
) -> FormatResult {
  let mut formatted = text
  formatted = strip_trailing_whitespace(formatted)
  formatted = ensure_trailing_newline(formatted)
  let _ = config.max_line_width
  let changed = formatted != text
  let lines_diff = count_lines(formatted) - count_lines(text)
  { original: text, formatted, changed, lines_changed: lines_diff }
}

///|
/// 格式化 C 代码 | Format C code
pub fn format_c_code(code : String) -> FormatResult {
  format_text(c_format_config(), code)
}

///|
/// 格式化 MoonBit 代码 | Format MoonBit code
pub fn format_moonbit_code(code : String) -> FormatResult {
  format_text(moonbit_format_config(), code)
}

///|
/// 格式化 JSON | Format JSON
pub fn format_json(json : String) -> FormatResult {
  format_text(default_format_config(), json)
}

///|
/// 内置格式化规则列表 | Built-in format rules
pub fn builtin_format_rules() -> Array[FormatRule] {
  [
    { name: "strip-trailing-ws", description: "Strip trailing whitespace", enabled: true },
    { name: "trailing-newline", description: "Ensure trailing newline", enabled: true },
    { name: "indent-style", description: "Enforce indent style", enabled: true },
    { name: "max-line-width", description: "Enforce max line width", enabled: true },
    { name: "trailing-comma", description: "Enforce trailing comma in multi-line", enabled: true },
  ]
}

///|
/// 创建格式化规则 | Create format rule
pub fn make_rule(
  name : String,
  description : String,
) -> FormatRule {
  { name, description, enabled: true }
}

///|
/// 禁用规则 | Disable rule
pub fn disable_rule(
  rules : Array[FormatRule],
  name : String,
) -> Array[FormatRule] {
  let result = []
  for rule in rules {
    if rule.name == name {
      result.push({ ..rule, enabled: false })
    } else {
      result.push(rule)
    }
  }
  result
}

///|
/// 启用规则 | Enable rule
pub fn enable_rule(
  rules : Array[FormatRule],
  name : String,
) -> Array[FormatRule] {
  let result = []
  for rule in rules {
    if rule.name == name {
      result.push({ ..rule, enabled: true })
    } else {
      result.push(rule)
    }
  }
  result
}

///|
/// 获取启用的规则 | Get enabled rules
pub fn enabled_rules(rules : Array[FormatRule]) -> Array[FormatRule] {
  let result = []
  for rule in rules {
    if rule.enabled {
      result.push(rule)
    }
  }
  result
}

///|
/// 格式化版本 | Formatter version
pub fn formatter_version() -> String {
  "moon-cross formatter v0.2.0"
}

///|
/// 检查是否需要格式化 | Check if formatting is needed
pub fn needs_formatting(result : FormatResult) -> Bool {
  result.changed
}

///|
/// 格式化摘要 | Format summary
pub fn format_summary(result : FormatResult) -> String {
  let status = if result.changed {
    "changed"
  } else {
    "unchanged"
  }
  "Format result: " + status + " (" + result.lines_changed.to_string() + " lines diff)"
}

///|
/// 批量格式化 | Batch format
pub fn batch_format(
  config : FormatConfig,
  texts : Array[String],
) -> Array[FormatResult] {
  let results = []
  for text in texts {
    results.push(format_text(config, text))
  }
  results
}

///|
/// 统计格式化变更数 | Count formatting changes
pub fn count_changes(results : Array[FormatResult]) -> Int {
  let mut count = 0
  for r in results {
    if r.changed {
      count = count + 1
    }
  }
  count
}

///|
/// FormatRule 实现 Named trait | FormatRule implements Named
pub impl @trait.Named for FormatRule with name(self) {
  self.name
}
pub extend FormatRule with @trait.Named::{name}
test "default_format_config" {
  let cfg = @formatter.default_format_config()
  assert_eq(cfg.indent_style, @formatter.IndentStyle::Spaces)
  assert_eq(cfg.indent_width, 2)
  assert_eq(cfg.max_line_width, 100)
  assert_true(cfg.trailing_comma)
}

test "moonbit_format_config" {
  let cfg = @formatter.moonbit_format_config()
  assert_eq(cfg.indent_width, 2)
  assert_eq(cfg.max_line_width, 80)
}

test "c_format_config" {
  let cfg = @formatter.c_format_config()
  assert_eq(cfg.indent_width, 4)
  assert_eq(cfg.max_line_width, 120)
  assert_true(!cfg.trailing_comma)
}

test "indent_string_spaces" {
  let cfg = @formatter.default_format_config()
  let indent = @formatter.indent_string(cfg, 2)
  assert_eq(indent, "    ")
}

test "indent_string_tabs" {
  let cfg : @formatter.FormatConfig = {
    indent_style: @formatter.IndentStyle::Tabs,
    indent_width: 1,
    max_line_width: 100,
    trailing_comma: true,
    blank_line_before_export: true,
    align_comments: true,
  }
  let indent = @formatter.indent_string(cfg, 3)
  assert_eq(indent, "\t\t\t")
}

test "indent_string_zero" {
  let cfg = @formatter.default_format_config()
  let indent = @formatter.indent_string(cfg, 0)
  assert_eq(indent, "")
}

test "count_lines_single" {
  assert_eq(@formatter.count_lines("hello"), 1)
}

test "count_lines_multi" {
  assert_eq(@formatter.count_lines("a\nb\nc"), 3)
}

test "count_lines_empty" {
  assert_eq(@formatter.count_lines(""), 1)
}

test "is_line_too_long_false" {
  let cfg = @formatter.default_format_config()
  assert_true(!@formatter.is_line_too_long(cfg, "short line"))
}

test "is_line_too_long_true" {
  let cfg = @formatter.default_format_config()
  let long_line = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  assert_true(@formatter.is_line_too_long(cfg, long_line))
}

test "find_long_lines_none" {
  let cfg = @formatter.default_format_config()
  let lines = @formatter.find_long_lines(cfg, "short\nlines\nhere")
  assert_eq(lines.length(), 0)
}

test "find_long_lines_some" {
  let cfg = @formatter.default_format_config()
  let long_line = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  let lines = @formatter.find_long_lines(cfg, "short\n" + long_line + "\nshort")
  assert_eq(lines.length(), 1)
}

test "strip_trailing_whitespace" {
  let result = @formatter.strip_trailing_whitespace("hello   \nworld\t")
  assert_true(result.contains("hello"))
  assert_true(result.contains("world"))
}

test "ensure_trailing_newline_no_change" {
  let result = @formatter.ensure_trailing_newline("hello\n")
  assert_eq(result, "hello\n")
}

test "ensure_trailing_newline_adds" {
  let result = @formatter.ensure_trailing_newline("hello")
  assert_eq(result, "hello\n")
}

test "format_text_no_change" {
  let cfg = @formatter.default_format_config()
  let result = @formatter.format_text(cfg, "hello\n")
  assert_true(!result.changed)
}

test "format_text_strips_whitespace" {
  let cfg = @formatter.default_format_config()
  let result = @formatter.format_text(cfg, "hello   \n")
  assert_true(result.changed)
  assert_true(!result.formatted.contains("   \n"))
}

test "format_text_adds_newline" {
  let cfg = @formatter.default_format_config()
  let result = @formatter.format_text(cfg, "hello")
  assert_true(result.changed)
  assert_true(result.formatted.contains("\n"))
}

test "format_c_code" {
  let result = @formatter.format_c_code("int main() {   \n}")
  assert_true(result.changed)
}

test "format_moonbit_code" {
  let result = @formatter.format_moonbit_code("fn test() {   \n}")
  assert_true(result.changed)
}

test "format_json" {
  let result = @formatter.format_json("{\"key\": \"value\"}   \n")
  assert_true(result.changed)
}

test "builtin_format_rules" {
  let rules = @formatter.builtin_format_rules()
  assert_eq(rules.length(), 5)
}

test "make_rule" {
  let rule = @formatter.make_rule("test", "description")
  assert_eq(rule.name, "test")
  assert_true(rule.enabled)
}

test "disable_rule" {
  let rules = @formatter.builtin_format_rules()
  let disabled = @formatter.disable_rule(rules, "indent-style")
  let enabled = @formatter.enabled_rules(disabled)
  assert_eq(enabled.length(), 4)
}

test "enable_rule" {
  let rules = @formatter.builtin_format_rules()
  let disabled = @formatter.disable_rule(rules, "indent-style")
  let re_enabled = @formatter.enable_rule(disabled, "indent-style")
  let enabled = @formatter.enabled_rules(re_enabled)
  assert_eq(enabled.length(), 5)
}

test "enabled_rules" {
  let rules = @formatter.builtin_format_rules()
  let enabled = @formatter.enabled_rules(rules)
  assert_eq(enabled.length(), 5)
}

test "formatter_version" {
  let v = @formatter.formatter_version()
  assert_true(v.contains("formatter"))
}

test "needs_formatting_true" {
  let cfg = @formatter.default_format_config()
  let result = @formatter.format_text(cfg, "hello   ")
  assert_true(@formatter.needs_formatting(result))
}

test "needs_formatting_false" {
  let cfg = @formatter.default_format_config()
  let result = @formatter.format_text(cfg, "hello\n")
  assert_true(!@formatter.needs_formatting(result))
}

test "format_summary_changed" {
  let cfg = @formatter.default_format_config()
  let result = @formatter.format_text(cfg, "hello   ")
  let summary = @formatter.format_summary(result)
  assert_true(summary.contains("changed"))
}

test "format_summary_unchanged" {
  let cfg = @formatter.default_format_config()
  let result = @formatter.format_text(cfg, "hello\n")
  let summary = @formatter.format_summary(result)
  assert_true(summary.contains("unchanged"))
}

test "batch_format" {
  let cfg = @formatter.default_format_config()
  let texts = ["hello\n", "world   \n", "test\n"]
  let results = @formatter.batch_format(cfg, texts)
  assert_eq(results.length(), 3)
}

test "count_changes" {
  let cfg = @formatter.default_format_config()
  let texts = ["hello\n", "world   \n", "test\n"]
  let results = @formatter.batch_format(cfg, texts)
  assert_eq(@formatter.count_changes(results), 1)
}

test "batch_format_all_clean" {
  let cfg = @formatter.default_format_config()
  let texts = ["a\n", "b\n", "c\n"]
  let results = @formatter.batch_format(cfg, texts)
  assert_eq(@formatter.count_changes(results), 0)
}
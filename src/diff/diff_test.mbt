test "default_diff_config" {
  let cfg = @diff.default_diff_config()
  assert_eq(cfg.context_lines, 3)
  assert_true(!cfg.ignore_whitespace)
  assert_eq(cfg.max_diff_lines, 1000)
}

test "line_type_to_string" {
  assert_eq(@diff.line_type_to_string(@diff.DiffLineType::Added), "+")
  assert_eq(@diff.line_type_to_string(@diff.DiffLineType::Removed), "-")
  assert_eq(@diff.line_type_to_string(@diff.DiffLineType::Unchanged), " ")
}

test "line_type_name" {
  assert_eq(@diff.line_type_name(@diff.DiffLineType::Added), "added")
  assert_eq(@diff.line_type_name(@diff.DiffLineType::Removed), "removed")
  assert_eq(@diff.line_type_name(@diff.DiffLineType::Unchanged), "unchanged")
}

test "make_diff_line" {
  let line = @diff.make_diff_line("test", @diff.DiffLineType::Added, 0, 1)
  assert_eq(line.content, "test")
  assert_eq(line.line_type, @diff.DiffLineType::Added)
  assert_eq(line.old_line_num, 0)
  assert_eq(line.new_line_num, 1)
}

test "diff_lines_identical" {
  let result = @diff.diff_lines(["a", "b", "c"], ["a", "b", "c"])
  assert_eq(result.added_count, 0)
  assert_eq(result.removed_count, 0)
  assert_eq(result.unchanged_count, 3)
}

test "diff_lines_all_added" {
  let result = @diff.diff_lines([], ["a", "b", "c"])
  assert_eq(result.added_count, 3)
  assert_eq(result.removed_count, 0)
  assert_eq(result.unchanged_count, 0)
}

test "diff_lines_all_removed" {
  let result = @diff.diff_lines(["a", "b", "c"], [])
  assert_eq(result.added_count, 0)
  assert_eq(result.removed_count, 3)
  assert_eq(result.unchanged_count, 0)
}

test "diff_lines_mixed" {
  let result = @diff.diff_lines(["a", "b", "c"], ["a", "x", "c"])
  assert_eq(result.added_count, 1)
  assert_eq(result.removed_count, 1)
  assert_eq(result.unchanged_count, 2)
}

test "diff_lines_extra_new" {
  let result = @diff.diff_lines(["a", "b"], ["a", "b", "c", "d"])
  assert_eq(result.added_count, 2)
  assert_eq(result.removed_count, 0)
  assert_eq(result.unchanged_count, 2)
}

test "diff_lines_extra_old" {
  let result = @diff.diff_lines(["a", "b", "c", "d"], ["a", "b"])
  assert_eq(result.added_count, 0)
  assert_eq(result.removed_count, 2)
  assert_eq(result.unchanged_count, 2)
}

test "diff_text_identical" {
  let result = @diff.diff_text("hello\nworld", "hello\nworld")
  assert_true(!@diff.has_changes(result))
}

test "diff_text_different" {
  let result = @diff.diff_text("hello\nworld", "hello\nmoon")
  assert_true(@diff.has_changes(result))
}

test "diff_text_empty" {
  let result = @diff.diff_text("", "")
  assert_true(!@diff.has_changes(result))
}

test "diff_text_addition" {
  let result = @diff.diff_text("a\nb", "a\nb\nc")
  assert_true(@diff.has_changes(result))
  assert_eq(result.added_count, 1)
}

test "has_changes_true" {
  let result = @diff.diff_lines(["a"], ["b"])
  assert_true(@diff.has_changes(result))
}

test "has_changes_false" {
  let result = @diff.diff_lines(["a"], ["a"])
  assert_true(!@diff.has_changes(result))
}

test "diff_summary" {
  let result = @diff.diff_lines(["a", "b"], ["a", "x"])
  let summary = @diff.diff_summary(result)
  assert_true(summary.contains("+1"))
  assert_true(summary.contains("-1"))
}

test "format_diff" {
  let result = @diff.diff_lines(["a"], ["b"])
  let formatted = @diff.format_diff(result)
  assert_true(formatted.contains("- a"))
  assert_true(formatted.contains("+ b"))
}

test "filter_added" {
  let result = @diff.diff_lines(["a", "b"], ["x", "y"])
  let added = @diff.filter_added(result)
  assert_eq(added.length(), 2)
}

test "filter_removed" {
  let result = @diff.diff_lines(["a", "b"], ["x", "y"])
  let removed = @diff.filter_removed(result)
  assert_eq(removed.length(), 2)
}

test "filter_unchanged" {
  let result = @diff.diff_lines(["a", "b", "c"], ["a", "x", "c"])
  let unchanged = @diff.filter_unchanged(result)
  assert_eq(unchanged.length(), 2)
}

test "merge_diffs" {
  let d1 = @diff.diff_lines(["a"], ["b"])
  let d2 = @diff.diff_lines(["c"], ["d"])
  let merged = @diff.merge_diffs(d1, d2)
  assert_eq(merged.added_count, 2)
  assert_eq(merged.removed_count, 2)
}

test "diff_stats" {
  let result = @diff.diff_lines(["a", "b", "c"], ["a", "x", "c"])
  let stats = @diff.diff_stats(result)
  assert_eq(stats.added, 1)
  assert_eq(stats.removed, 1)
  assert_eq(stats.unchanged, 2)
}

test "diff_stats_empty" {
  let result = @diff.empty_diff()
  let stats = @diff.diff_stats(result)
  assert_eq(stats.total_lines, 0)
  assert_eq(stats.change_ratio, 0.0)
}

test "empty_diff" {
  let result = @diff.empty_diff()
  assert_eq(result.added_count, 0)
  assert_eq(result.removed_count, 0)
  assert_eq(result.unchanged_count, 0)
  assert_eq(result.lines.length(), 0)
}

test "diff_version" {
  let v = @diff.diff_version()
  assert_true(v.contains("diff"))
}

test "total_lines" {
  let result = @diff.diff_lines(["a", "b"], ["a", "x"])
  assert_eq(@diff.total_lines(result), 3)
}

test "reverse_diff" {
  let result = @diff.diff_lines(["a", "b"], ["x", "y"])
  let reversed = @diff.reverse_diff(result)
  assert_eq(reversed.added_count, result.removed_count)
  assert_eq(reversed.removed_count, result.added_count)
}

test "reverse_diff_unchanged" {
  let result = @diff.diff_lines(["a", "b"], ["a", "b"])
  let reversed = @diff.reverse_diff(result)
  assert_eq(reversed.unchanged_count, 2)
  assert_true(!@diff.has_changes(reversed))
}

test "diff_text_with_config" {
  let cfg = @diff.default_diff_config()
  let result = @diff.diff_text_with_config(cfg, "a\nb", "a\nc")
  assert_true(@diff.has_changes(result))
}
///|
test "default_coverage_config" {
  let cfg = @cov.default_coverage_config()
  assert_eq(cfg.min_threshold, 80.0)
  assert_true(cfg.fail_below)
  assert_true(cfg.show_missing)
}

///|
test "make_entry_basic" {
  let entry = @cov.make_entry("test.mbt", 100, 80)
  assert_eq(entry.file, "test.mbt")
  assert_eq(entry.total_lines, 100)
  assert_eq(entry.covered_lines, 80)
}

///|
test "make_entry_missed_lines" {
  let entry = @cov.make_entry("test.mbt", 10, 7)
  assert_eq(entry.missed_lines.length(), 3)
}

///|
test "make_entry_full_coverage" {
  let entry = @cov.make_entry("test.mbt", 50, 50)
  assert_eq(entry.missed_lines.length(), 0)
}

///|
test "make_entry_with_missed" {
  let entry = @cov.make_entry_with_missed("test.mbt", 10, 8, [3, 7])
  assert_eq(entry.missed_lines.length(), 2)
}

///|
test "entry_percentage_full" {
  let entry = @cov.make_entry("test.mbt", 100, 100)
  assert_eq(@cov.entry_percentage(entry), 100.0)
}

///|
test "entry_percentage_half" {
  let entry = @cov.make_entry("test.mbt", 100, 50)
  assert_eq(@cov.entry_percentage(entry), 50.0)
}

///|
test "entry_percentage_zero" {
  let entry = @cov.make_entry("test.mbt", 100, 0)
  assert_eq(@cov.entry_percentage(entry), 0.0)
}

///|
test "entry_percentage_empty" {
  let entry = @cov.make_entry("test.mbt", 0, 0)
  assert_eq(@cov.entry_percentage(entry), 0.0)
}

///|
test "missed_lines_count" {
  let entry = @cov.make_entry("test.mbt", 100, 75)
  assert_eq(@cov.missed_lines_count(entry), 25)
}

///|
test "merge_entries" {
  let e1 = @cov.make_entry("a.mbt", 100, 80)
  let e2 = @cov.make_entry("b.mbt", 200, 150)
  let report = @cov.merge_entries([e1, e2])
  assert_eq(report.total_lines, 300)
  assert_eq(report.covered_lines, 230)
  assert_eq(report.missed_lines, 70)
}

///|
test "merge_entries_empty" {
  let report = @cov.merge_entries([])
  assert_eq(report.total_lines, 0)
  assert_eq(report.covered_lines, 0)
}

///|
test "coverage_percentage" {
  let e1 = @cov.make_entry("a.mbt", 100, 80)
  let report = @cov.merge_entries([e1])
  assert_eq(@cov.coverage_percentage(report), 80.0)
}

///|
test "coverage_percentage_empty" {
  let report = @cov.merge_entries([])
  assert_eq(@cov.coverage_percentage(report), 0.0)
}

///|
test "count_files" {
  let e1 = @cov.make_entry("a.mbt", 100, 80)
  let e2 = @cov.make_entry("b.mbt", 200, 150)
  let report = @cov.merge_entries([e1, e2])
  assert_eq(@cov.count_files(report), 2)
}

///|
test "is_passing_true" {
  let entry = @cov.make_entry("test.mbt", 100, 90)
  let report = @cov.merge_entries([entry])
  assert_true(@cov.is_passing(report, 80.0))
}

///|
test "is_passing_false" {
  let entry = @cov.make_entry("test.mbt", 100, 50)
  let report = @cov.merge_entries([entry])
  assert_true(!@cov.is_passing(report, 80.0))
}

///|
test "coverage_grade_a" {
  assert_eq(@cov.coverage_grade(95.0), "A")
}

///|
test "coverage_grade_b" {
  assert_eq(@cov.coverage_grade(85.0), "B")
}

///|
test "coverage_grade_c" {
  assert_eq(@cov.coverage_grade(75.0), "C")
}

///|
test "coverage_grade_d" {
  assert_eq(@cov.coverage_grade(65.0), "D")
}

///|
test "coverage_grade_f" {
  assert_eq(@cov.coverage_grade(50.0), "F")
}

///|
test "filter_below_threshold" {
  let e1 = @cov.make_entry("a.mbt", 100, 90)
  let e2 = @cov.make_entry("b.mbt", 100, 50)
  let report = @cov.merge_entries([e1, e2])
  let below = @cov.filter_below_threshold(report, 80.0)
  assert_eq(below.length(), 1)
}

///|
test "filter_below_threshold_none" {
  let e1 = @cov.make_entry("a.mbt", 100, 90)
  let report = @cov.merge_entries([e1])
  let below = @cov.filter_below_threshold(report, 80.0)
  assert_eq(below.length(), 0)
}

///|
test "sort_by_coverage_ascending" {
  let e1 = @cov.make_entry("a.mbt", 100, 90)
  let e2 = @cov.make_entry("b.mbt", 100, 50)
  let e3 = @cov.make_entry("c.mbt", 100, 70)
  let sorted = @cov.sort_by_coverage_ascending([e1, e2, e3])
  assert_eq(sorted[0].file, "b.mbt")
  assert_eq(sorted[1].file, "c.mbt")
  assert_eq(sorted[2].file, "a.mbt")
}

///|
test "sort_by_coverage_descending" {
  let e1 = @cov.make_entry("a.mbt", 100, 90)
  let e2 = @cov.make_entry("b.mbt", 100, 50)
  let e3 = @cov.make_entry("c.mbt", 100, 70)
  let sorted = @cov.sort_by_coverage_descending([e1, e2, e3])
  assert_eq(sorted[0].file, "a.mbt")
  assert_eq(sorted[1].file, "c.mbt")
  assert_eq(sorted[2].file, "b.mbt")
}

///|
test "coverage_summary_stats" {
  let e1 = @cov.make_entry("a.mbt", 100, 90)
  let e2 = @cov.make_entry("b.mbt", 100, 50)
  let report = @cov.merge_entries([e1, e2])
  let stats = @cov.coverage_summary_stats(report)
  assert_eq(stats.min, 50.0)
  assert_eq(stats.max, 90.0)
  assert_eq(stats.files, 2)
}

///|
test "coverage_summary_stats_empty" {
  let report = @cov.merge_entries([])
  let stats = @cov.coverage_summary_stats(report)
  assert_eq(stats.files, 0)
}

///|
test "format_report_text" {
  let entry = @cov.make_entry("test.mbt", 100, 80)
  let report = @cov.merge_entries([entry])
  let text = @cov.format_report_text(report)
  assert_true(text.contains("Coverage Report"))
  assert_true(text.contains("test.mbt"))
}

///|
test "format_report_json" {
  let entry = @cov.make_entry("test.mbt", 100, 80)
  let report = @cov.merge_entries([entry])
  let json = @cov.format_report_json(report)
  assert_true(json.contains("coverage"))
  assert_true(json.contains("percentage"))
}

///|
test "coverage_version" {
  let v = @cov.coverage_version()
  assert_true(v.contains("coverage"))
}

///|
test "empty_report" {
  let report = @cov.empty_report()
  assert_eq(report.total_lines, 0)
  assert_eq(report.covered_lines, 0)
  assert_eq(report.missed_lines, 0)
  assert_eq(report.entries.length(), 0)
}

///|
test "merge_reports" {
  let e1 = @cov.make_entry("a.mbt", 100, 80)
  let e2 = @cov.make_entry("b.mbt", 200, 150)
  let r1 = @cov.merge_entries([e1])
  let r2 = @cov.merge_entries([e2])
  let merged = @cov.merge_reports(r1, r2)
  assert_eq(merged.total_lines, 300)
  assert_eq(merged.covered_lines, 230)
  assert_eq(merged.entries.length(), 2)
}

///|
test "line_status_covered" {
  let entry = @cov.make_entry_with_missed("test.mbt", 10, 8, [3, 7])
  let status = @cov.line_status(entry, 1)
  assert_eq(status, @cov.LineStatus::Covered)
}

///|
test "line_status_uncovered" {
  let entry = @cov.make_entry_with_missed("test.mbt", 10, 8, [3, 7])
  let status = @cov.line_status(entry, 3)
  assert_eq(status, @cov.LineStatus::Uncovered)
}

///|
test "line_status_out_of_range" {
  let entry = @cov.make_entry("test.mbt", 10, 10)
  let status = @cov.line_status(entry, 15)
  assert_eq(status, @cov.LineStatus::Uncovered)
}

///|
test "missing_lines_summary_none" {
  let entry = @cov.make_entry("test.mbt", 100, 100)
  let summary = @cov.missing_lines_summary(entry)
  assert_true(summary.contains("no missing lines"))
}

///|
test "missing_lines_summary_some" {
  let entry = @cov.make_entry_with_missed("test.mbt", 10, 8, [3, 7])
  let summary = @cov.missing_lines_summary(entry)
  assert_true(summary.contains("3"))
  assert_true(summary.contains("7"))
}

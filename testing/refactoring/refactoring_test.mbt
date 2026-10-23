test "suggestion_create" {
  let s = @refactoring.suggestion_create("xxx_version", "pub fn", "pub impl Versioned", "use trait", "high")
  assert_eq(s.target, "xxx_version")
  assert_eq(s.severity, "high")
}

test "pattern_create" {
  let p = @refactoring.pattern_create("test", "desc", "before", "after", ["b1", "b2"])
  assert_eq(p.name, "test")
  assert_eq(p.benefits.length(), 2)
}

test "pattern_traitify" {
  let p = @refactoring.pattern_traitify()
  assert_eq(p.name, "traitify")
  assert_true(p.description.contains("trait"))
}

test "all_patterns" {
  let patterns = @refactoring.all_patterns()
  assert_eq(patterns.length(), 5)
}

test "filter_by_severity" {
  let s1 = @refactoring.suggestion_create("a", "x", "y", "r", "high")
  let s2 = @refactoring.suggestion_create("b", "x", "y", "r", "low")
  let filtered = @refactoring.filter_by_severity([s1, s2], "high")
  assert_eq(filtered.length(), 1)
  assert_eq(filtered[0].target, "a")
}

test "report_create" {
  let s1 = @refactoring.suggestion_create("a", "x", "y", "r", "high")
  let s2 = @refactoring.suggestion_create("b", "x", "y", "r", "low")
  let report = @refactoring.report_create([s1, s2], 1)
  assert_eq(report.total, 2)
  assert_eq(report.applied, 1)
  assert_eq(report.skipped, 1)
}

test "report_summary" {
  let report = @refactoring.report_create([], 0)
  let s = @refactoring.report_summary(report)
  assert_true(s.contains("0 suggestions"))
}

test "Named trait" {
  let s = @refactoring.suggestion_create("target1", "a", "b", "c", "d")
  assert_eq(@trait.Named::name(s), "target1")
}

test "Summarizable trait" {
  let s = @refactoring.suggestion_create("t", "from", "to", "r", "high")
  let sum = @trait.Summarizable::summary(s)
  assert_true(sum.contains("t"))
  assert_true(sum.contains("high"))
}

test "Countable trait" {
  let s1 = @refactoring.suggestion_create("a", "x", "y", "r", "h")
  let report = @refactoring.report_create([s1], 1)
  assert_eq(@trait.Countable::count(report), 1)
}

test "refactoring_version" {
  assert_eq(@refactoring.refactoring_version(), "moon-cross refactoring v0.3.14")
}
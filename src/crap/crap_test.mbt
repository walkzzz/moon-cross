test "complexity_create" {
  let c = @crap.complexity_create("foo", 3, 2, 20)
  assert_eq(c.name, "foo")
  assert_eq(c.cyclomatic, 6)
  assert_eq(c.branches, 3)
  assert_eq(c.loops, 2)
}

test "coverage_create" {
  let ci = @crap.coverage_create(100, 80, 10, 8)
  assert_eq(ci.total_lines, 100)
  assert_eq(ci.covered_lines, 80)
}

test "coverage_percent" {
  let ci = @crap.coverage_create(100, 75, 10, 8)
  assert_eq(@crap.coverage_percent(ci), 75)
}

test "coverage_percent_zero" {
  let ci = @crap.coverage_create(0, 0, 0, 0)
  assert_eq(@crap.coverage_percent(ci), 0)
}

test "branch_coverage_percent" {
  let ci = @crap.coverage_create(100, 80, 10, 5)
  assert_eq(@crap.branch_coverage_percent(ci), 50)
}

test "calculate_crap full_coverage" {
  let f = @crap.complexity_create("simple", 0, 0, 5)
  let r = @crap.calculate_crap(f, 100)
  assert_eq(r.complexity, 1)
  assert_eq(r.coverage, 100)
  assert_eq(r.crap_score, 1)
  assert_eq(r.risk_level, "low")
}

test "calculate_crap no_coverage" {
  let f = @crap.complexity_create("complex", 5, 3, 50)
  let r = @crap.calculate_crap(f, 0)
  assert_true(r.crap_score > r.complexity)
  assert_eq(r.risk_level, "high")
}

test "calculate_crap medium_complexity" {
  let f = @crap.complexity_create("medium", 2, 1, 15)
  let r = @crap.calculate_crap(f, 50)
  assert_true(r.crap_score >= r.complexity)
}

test "calculate_crap_batch" {
  let f1 = @crap.complexity_create("a", 0, 0, 5)
  let f2 = @crap.complexity_create("b", 5, 3, 50)
  let report = @crap.calculate_crap_batch([f1, f2], 50)
  assert_eq(report.total_funcs, 2)
  assert_true(report.high_risk + report.medium_risk + report.low_risk == 2)
}

test "calculate_crap_batch empty" {
  let report = @crap.calculate_crap_batch([], 100)
  assert_eq(report.total_funcs, 0)
  assert_eq(report.avg_crap, 0)
}

test "crap_report_summary" {
  let f = @crap.complexity_create("x", 0, 0, 5)
  let report = @crap.calculate_crap_batch([f], 100)
  let s = @crap.crap_report_summary(report)
  assert_true(s.contains("1 funcs"))
}

test "high_risk_funcs" {
  let f1 = @crap.complexity_create("safe", 0, 0, 5)
  let f2 = @crap.complexity_create("danger", 10, 5, 100)
  let report = @crap.calculate_crap_batch([f1, f2], 0)
  let high = @crap.high_risk_funcs(report)
  assert_true(high.length() >= 1)
}

test "Named trait" {
  let c = @crap.complexity_create("named_fn", 1, 1, 10)
  assert_eq(@trait.Named::name(c), "named_fn")
}

test "Countable trait" {
  let c = @crap.complexity_create("c", 3, 2, 10)
  assert_eq(@trait.Countable::count(c), 6)
}

test "Checkable trait" {
  let f = @crap.complexity_create("safe", 0, 0, 5)
  let r = @crap.calculate_crap(f, 100)
  assert_true(@trait.Checkable::check(r))
}

test "Summarizable trait" {
  let f = @crap.complexity_create("s", 0, 0, 5)
  let r = @crap.calculate_crap(f, 100)
  let sum = @trait.Summarizable::summary(r)
  assert_true(sum.contains("s"))
}

test "crap_version" {
  assert_eq(@crap.crap_version(), "moon-cross crap v0.3.15")
}
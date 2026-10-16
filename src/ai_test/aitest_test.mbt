test "test_case_create basic" {
  let tc = @ai_test.test_case_create("add", "1+1", "2", "unit")
  assert_eq(tc.name, "add")
  assert_eq(tc.input, "1+1")
  assert_eq(tc.expected, "2")
  assert_eq(tc.category, "unit")
}

test "generate_cases" {
  let cases = @ai_test.generate_cases("gen", 5)
  assert_eq(cases.length(), 5)
  assert_eq(cases[0].name, "gen_0")
  assert_eq(cases[0].input, "0")
  assert_eq(cases[0].expected, "0")
  assert_eq(cases[4].name, "gen_4")
  assert_eq(cases[4].expected, "8")
}

test "generate_cases zero" {
  let cases = @ai_test.generate_cases("empty", 0)
  assert_eq(cases.length(), 0)
}

test "boundary_analyze" {
  let cases = @ai_test.boundary_analyze("range", 0, 100)
  assert_eq(cases.length(), 4)
  assert_eq(cases[0].value, 0)
  assert_eq(cases[0].boundary_type, "min")
  assert_eq(cases[1].value, 1)
  assert_eq(cases[1].boundary_type, "edge")
  assert_eq(cases[2].value, 99)
  assert_eq(cases[2].boundary_type, "edge")
  assert_eq(cases[3].value, 100)
  assert_eq(cases[3].boundary_type, "max")
}

test "boundary_analyze_full" {
  let cases = @ai_test.boundary_analyze_full("full", 0, 100)
  assert_eq(cases.length(), 5)
  assert_eq(cases[4].value, 50)
  assert_eq(cases[4].boundary_type, "mid")
}

test "boundary_analyze_full negative" {
  let cases = @ai_test.boundary_analyze_full("neg", -10, 10)
  assert_eq(cases.length(), 5)
  assert_eq(cases[0].value, -10)
  assert_eq(cases[4].value, 0)
}

test "coverage_report basic" {
  let cr = @ai_test.coverage_report(100, 75)
  assert_eq(cr.total_lines, 100)
  assert_eq(cr.covered_lines, 75)
  assert_eq(cr.percentage, 75)
}

test "coverage_report full" {
  let cr = @ai_test.coverage_report(50, 50)
  assert_eq(cr.percentage, 100)
}

test "coverage_report zero" {
  let cr = @ai_test.coverage_report(0, 0)
  assert_eq(cr.percentage, 0)
}

test "coverage_report partial" {
  let cr = @ai_test.coverage_report(3, 2)
  assert_eq(cr.percentage, 66)
}

test "edge_case_detect basic" {
  let cases = @ai_test.edge_case_detect("vals", [5, 3, 8, 1, 9])
  assert_eq(cases.length(), 2)
  assert_eq(cases[0].value, 1)
  assert_eq(cases[0].boundary_type, "min")
  assert_eq(cases[1].value, 9)
  assert_eq(cases[1].boundary_type, "max")
}

test "edge_case_detect empty" {
  let cases = @ai_test.edge_case_detect("empty", [])
  assert_eq(cases.length(), 0)
}

test "edge_case_detect single" {
  let cases = @ai_test.edge_case_detect("single", [42])
  assert_eq(cases.length(), 2)
  assert_eq(cases[0].value, 42)
  assert_eq(cases[1].value, 42)
}

test "edge_case_detect negative" {
  let cases = @ai_test.edge_case_detect("neg", [-5, 0, 3])
  assert_eq(cases[0].value, -5)
  assert_eq(cases[1].value, 3)
}

test "mutation_test killed" {
  let r = @ai_test.mutation_test("m1", true, false)
  assert_eq(r.test_name, "mutation_m1")
  assert_eq(r.passed, 1)
  assert_eq(r.failed, 0)
  assert_eq(r.coverage, 100)
}

test "mutation_test survived" {
  let r = @ai_test.mutation_test("m2", true, true)
  assert_eq(r.passed, 0)
  assert_eq(r.failed, 1)
  assert_eq(r.coverage, 0)
}

test "run_test_suite all pass" {
  let cases = [
    @ai_test.test_case_create("a", "1", "2", "gen"),
    @ai_test.test_case_create("b", "2", "4", "gen"),
  ]
  let r = @ai_test.run_test_suite("suite1", cases, ["2", "4"])
  assert_eq(r.total_cases, 2)
  assert_eq(r.passed, 2)
  assert_eq(r.failed, 0)
  assert_eq(r.coverage, 100)
}

test "run_test_suite partial" {
  let cases = [
    @ai_test.test_case_create("a", "1", "2", "gen"),
    @ai_test.test_case_create("b", "2", "4", "gen"),
  ]
  let r = @ai_test.run_test_suite("suite2", cases, ["2", "wrong"])
  assert_eq(r.passed, 1)
  assert_eq(r.failed, 1)
  assert_eq(r.coverage, 50)
}

test "run_test_suite empty" {
  let r = @ai_test.run_test_suite("empty", [], [])
  assert_eq(r.total_cases, 0)
  assert_eq(r.coverage, 0)
}

test "ai_test_summary" {
  let r = @ai_test.run_test_suite("mytest", [@ai_test.test_case_create("a", "1", "2", "g")], ["2"])
  let s = @ai_test.ai_test_summary(r)
  assert_eq(s, "mytest: 1/1 passed, 0 failed, 100% coverage")
}

test "merge_results" {
  let r1 = @ai_test.run_test_suite("s1", [@ai_test.test_case_create("a", "1", "2", "g")], ["2"])
  let r2 = @ai_test.run_test_suite("s2", [@ai_test.test_case_create("b", "1", "3", "g")], ["wrong"])
  let merged = @ai_test.merge_results("combined", [r1, r2])
  assert_eq(merged.test_name, "combined")
  assert_eq(merged.total_cases, 2)
  assert_eq(merged.passed, 1)
  assert_eq(merged.failed, 1)
  assert_eq(merged.coverage, 50)
}

test "merge_results empty" {
  let merged = @ai_test.merge_results("none", [])
  assert_eq(merged.total_cases, 0)
  assert_eq(merged.coverage, 0)
}

test "ai_test_version" {
  assert_eq(@ai_test.ai_test_version(), "moon-cross ai_test v0.3.2")
}
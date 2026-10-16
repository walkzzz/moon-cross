///|
/// 测试用例 | Test case
pub(all) struct TestCase {
  name : String
  input : String
  expected : String
  category : String
} derive(Debug, Eq)
pub extend TestCase with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TestCase with Eq::{not_equal, equal}

///|
/// 边界用例 | Boundary case
pub(all) struct BoundaryCase {
  name : String
  value : Int
  boundary_type : String
} derive(Debug, Eq)
pub extend BoundaryCase with @moonbitlang/core/debug.Debug::{to_repr}
pub extend BoundaryCase with Eq::{not_equal, equal}

///|
/// 覆盖率报告 | Coverage report
pub(all) struct CoverageReport {
  total_lines : Int
  covered_lines : Int
  percentage : Int
} derive(Debug, Eq)
pub extend CoverageReport with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CoverageReport with Eq::{not_equal, equal}

///|
/// AI 测试结果 | AI test result
pub(all) struct AITestResult {
  test_name : String
  total_cases : Int
  passed : Int
  failed : Int
  coverage : Int
} derive(Debug, Eq)
pub extend AITestResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend AITestResult with Eq::{not_equal, equal}

///|
/// 创建测试用例 | Create test case
pub fn test_case_create(name : String, input : String, expected : String, category : String) -> TestCase {
  { name, input, expected, category, }
}

///|
/// 批量生成测试用例 | Generate test cases
pub fn generate_cases(base_name : String, count : Int) -> Array[TestCase] {
  let cases = []
  for i in 0..<count {
    cases.push({
      name: base_name + "_" + i.to_string(),
      input: i.to_string(),
      expected: (i * 2).to_string(),
      category: "generated",
    })
  }
  cases
}

///|
/// 边界值分析 | Boundary value analysis
pub fn boundary_analyze(name : String, min_val : Int, max_val : Int) -> Array[BoundaryCase] {
  [
    { name: name + "_min", value: min_val, boundary_type: "min", },
    { name: name + "_min_plus_1", value: min_val + 1, boundary_type: "edge", },
    { name: name + "_max_minus_1", value: max_val - 1, boundary_type: "edge", },
    { name: name + "_max", value: max_val, boundary_type: "max", },
  ]
}

///|
/// 边界值分析（含中间值）| Boundary value analysis with mid
pub fn boundary_analyze_full(name : String, min_val : Int, max_val : Int) -> Array[BoundaryCase] {
  let cases = boundary_analyze(name, min_val, max_val)
  let mid = (min_val + max_val) / 2
  let result = []
  for c in cases {
    result.push(c)
  }
  result.push({ name: name + "_mid", value: mid, boundary_type: "mid", })
  result
}

///|
/// 生成覆盖率报告 | Generate coverage report
pub fn coverage_report(total : Int, covered : Int) -> CoverageReport {
  let pct = if total == 0 { 0 } else { covered * 100 / total }
  { total_lines: total, covered_lines: covered, percentage: pct, }
}

///|
/// 边缘用例检测 | Edge case detection from values
pub fn edge_case_detect(name : String, values : Array[Int]) -> Array[BoundaryCase] {
  let cases : Array[BoundaryCase] = []
  if values.length() == 0 {
    cases
  } else {
    let mut min_val = values[0]
    let mut max_val = values[0]
    for v in values {
      if v < min_val {
        min_val = v
      }
      if v > max_val {
        max_val = v
      }
    }
    cases.push({ name: name + "_detected_min", value: min_val, boundary_type: "min", })
    cases.push({ name: name + "_detected_max", value: max_val, boundary_type: "max", })
    cases
  }
}

///|
/// 变异测试 | Mutation test
pub fn mutation_test(name : String, original_pass : Bool, mutated_pass : Bool) -> AITestResult {
  let killed = original_pass && !mutated_pass
  let passed = if killed { 1 } else { 0 }
  let failed = if killed { 0 } else { 1 }
  { test_name: "mutation_" + name, total_cases: 1, passed, failed, coverage: passed * 100, }
}

///|
/// 运行测试套件 | Run test suite
pub fn run_test_suite(name : String, cases : Array[TestCase], actuals : Array[String]) -> AITestResult {
  let total = cases.length()
  let mut passed = 0
  let mut failed = 0
  let mut idx = 0
  for c in cases {
    let actual = if idx < actuals.length() { actuals[idx] } else { "" }
    if actual == c.expected {
      passed = passed + 1
    } else {
      failed = failed + 1
    }
    idx = idx + 1
  }
  let cov = if total == 0 { 0 } else { passed * 100 / total }
  { test_name: name, total_cases: total, passed, failed, coverage: cov, }
}

///|
/// AI 测试摘要 | AI test summary
pub fn ai_test_summary(result : AITestResult) -> String {
  result.test_name + ": " + result.passed.to_string() + "/" + result.total_cases.to_string() + " passed, " + result.failed.to_string() + " failed, " + result.coverage.to_string() + "% coverage"
}

///|
/// 合并测试结果 | Merge test results
pub fn merge_results(name : String, results : Array[AITestResult]) -> AITestResult {
  let mut total = 0
  let mut passed = 0
  let mut failed = 0
  let mut cov_sum = 0
  for r in results {
    total = total + r.total_cases
    passed = passed + r.passed
    failed = failed + r.failed
    cov_sum = cov_sum + r.coverage
  }
  let cov = if results.length() == 0 { 0 } else { cov_sum / results.length() }
  { test_name: name, total_cases: total, passed, failed, coverage: cov, }
}

///|
/// AI 测试包版本 | AI test package version
pub fn ai_test_version() -> String {
  "moon-cross ai_test v0.3.2"
}
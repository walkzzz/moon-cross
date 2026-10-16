///|
/// 测试步骤 | Test step
pub(all) struct Step {
  name : String
  action : String
  expected : String
} derive(Debug, Eq)
pub extend Step with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Step with Eq::{not_equal, equal}

///|
/// 步骤结果 | Step result
pub(all) struct StepResult {
  step_name : String
  passed : Bool
  actual : String
  expected : String
} derive(Debug, Eq)
pub extend StepResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend StepResult with Eq::{not_equal, equal}

///|
/// 测试场景 | Test scenario
pub(all) struct Scenario {
  name : String
  description : String
  steps : Array[Step]
} derive(Debug, Eq)
pub extend Scenario with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Scenario with Eq::{not_equal, equal}

///|
/// 场景结果 | Scenario result
pub(all) struct ScenarioResult {
  scenario_name : String
  step_results : Array[StepResult]
  passed : Bool
} derive(Debug, Eq)
pub extend ScenarioResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ScenarioResult with Eq::{not_equal, equal}

///|
/// E2E 报告 | E2E report
pub(all) struct E2EReport {
  total_scenarios : Int
  passed_scenarios : Int
  failed_scenarios : Int
  results : Array[ScenarioResult]
} derive(Debug, Eq)
pub extend E2EReport with @moonbitlang/core/debug.Debug::{to_repr}
pub extend E2EReport with Eq::{not_equal, equal}

///|
/// 创建步骤 | Create step
pub fn step_create(name : String, action : String, expected : String) -> Step {
  { name, action, expected, }
}

///|
/// 执行步骤 | Execute step (compare actual vs expected)
pub fn step_execute(step : Step, actual : String) -> StepResult {
  let passed = actual == step.expected
  { step_name: step.name, passed, actual, expected: step.expected, }
}

///|
/// 创建场景 | Create scenario
pub fn scenario_create(name : String, description : String) -> Scenario {
  { name, description, steps: [], }
}

///|
/// 添加步骤 | Add step to scenario
pub fn scenario_add_step(scenario : Scenario, step : Step) -> Scenario {
  let steps = []
  for s in scenario.steps {
    steps.push(s)
  }
  steps.push(step)
  { name: scenario.name, description: scenario.description, steps, }
}

///|
/// 运行场景 | Run scenario with actual outputs
pub fn scenario_run(scenario : Scenario, actuals : Array[String]) -> ScenarioResult {
  let step_results = []
  let mut all_passed = true
  let mut idx = 0
  for s in scenario.steps {
    let actual = if idx < actuals.length() { actuals[idx] } else { "" }
    let passed = actual == s.expected
    if !passed {
      all_passed = false
    }
    step_results.push({ step_name: s.name, passed, actual, expected: s.expected, })
    idx = idx + 1
  }
  { scenario_name: scenario.name, step_results, passed: all_passed, }
}

///|
/// 生成 E2E 报告 | Generate E2E report
pub fn e2e_report(results : Array[ScenarioResult]) -> E2EReport {
  let total = results.length()
  let mut passed = 0
  let mut failed = 0
  for r in results {
    if r.passed {
      passed = passed + 1
    } else {
      failed = failed + 1
    }
  }
  { total_scenarios: total, passed_scenarios: passed, failed_scenarios: failed, results, }
}

///|
/// 场景通过率 | Scenario pass rate
pub fn scenario_pass_rate(report : E2EReport) -> String {
  if report.total_scenarios == 0 {
    "0/0 (100%)"
  } else {
    report.passed_scenarios.to_string() + "/" + report.total_scenarios.to_string() + " (" + (report.passed_scenarios * 100 / report.total_scenarios).to_string() + "%)"
  }
}

///|
/// 提取失败场景 | Extract failed scenarios
pub fn failed_scenarios(report : E2EReport) -> Array[String] {
  let names = []
  for r in report.results {
    if !r.passed {
      names.push(r.scenario_name)
    }
  }
  names
}

///|
/// 步骤总数 | Total steps across all scenarios
pub fn total_steps(report : E2EReport) -> Int {
  let mut count = 0
  for r in report.results {
    count = count + r.step_results.length()
  }
  count
}

///|
/// E2E 包版本 | E2E package version
pub fn e2e_version() -> String {
  "moon-cross e2e v0.3.2"
}
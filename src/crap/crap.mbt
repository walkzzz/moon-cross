///|
/// 函数复杂度信息 | Function complexity info
pub(all) struct FuncComplexity {
  name : String
  cyclomatic : Int
  lines : Int
  branches : Int
  loops : Int
} derive(Debug, Eq)
pub extend FuncComplexity with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FuncComplexity with Eq::{not_equal, equal}

///|
/// 覆盖率信息 | Coverage info
pub(all) struct CoverageInfo {
  total_lines : Int
  covered_lines : Int
  total_branches : Int
  covered_branches : Int
} derive(Debug, Eq)
pub extend CoverageInfo with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CoverageInfo with Eq::{not_equal, equal}

///|
/// CRAP 指标结果 | CRAP metric result
pub(all) struct CrapResult {
  func_name : String
  complexity : Int
  coverage : Int
  crap_score : Int
  risk_level : String
} derive(Debug, Eq)
pub extend CrapResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CrapResult with Eq::{not_equal, equal}

///|
/// CRAP 报告 | CRAP report
pub(all) struct CrapReport {
  results : Array[CrapResult]
  total_funcs : Int
  avg_crap : Int
  high_risk : Int
  medium_risk : Int
  low_risk : Int
} derive(Debug, Eq)
pub extend CrapReport with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CrapReport with Eq::{not_equal, equal}

///|
/// 创建函数复杂度 | Create function complexity
pub fn complexity_create(name : String, branches : Int, loops : Int, lines : Int) -> FuncComplexity {
  let cyclomatic = 1 + branches + loops
  { name, cyclomatic, lines, branches, loops, }
}

///|
/// 创建覆盖率信息 | Create coverage info
pub fn coverage_create(total_lines : Int, covered_lines : Int, total_branches : Int, covered_branches : Int) -> CoverageInfo {
  { total_lines, covered_lines, total_branches, covered_branches, }
}

///|
/// 计算覆盖率百分比 | Calculate coverage percentage
pub fn coverage_percent(info : CoverageInfo) -> Int {
  if info.total_lines == 0 {
    0
  } else {
    info.covered_lines * 100 / info.total_lines
  }
}

///|
/// 计算分支覆盖率 | Calculate branch coverage percentage
pub fn branch_coverage_percent(info : CoverageInfo) -> Int {
  if info.total_branches == 0 {
    0
  } else {
    info.covered_branches * 100 / info.total_branches
  }
}

///|
/// 计算 CRAP 指标 | Calculate CRAP metric
/// CRAP = complexity² × (1 − coverage)³ + complexity
pub fn calculate_crap(func : FuncComplexity, coverage_pct : Int) -> CrapResult {
  let comp = func.cyclomatic
  let uncovered = 100 - coverage_pct
  let comp_sq = comp * comp
  let uncovered_factor = uncovered * uncovered * uncovered / 1000000
  let crap_score = comp_sq * uncovered_factor + comp
  let risk = if crap_score > 30 {
    "high"
  } else if crap_score > 10 {
    "medium"
  } else {
    "low"
  }
  { func_name: func.name, complexity: comp, coverage: coverage_pct, crap_score, risk_level: risk, }
}

///|
/// 批量计算 CRAP | Batch calculate CRAP
pub fn calculate_crap_batch(funcs : Array[FuncComplexity], coverage_pct : Int) -> CrapReport {
  let results = []
  let mut high = 0
  let mut medium = 0
  let mut low = 0
  let mut total_crap = 0
  for f in funcs {
    let r = calculate_crap(f, coverage_pct)
    total_crap = total_crap + r.crap_score
    if r.risk_level == "high" {
      high = high + 1
    } else if r.risk_level == "medium" {
      medium = medium + 1
    } else {
      low = low + 1
    }
    results.push(r)
  }
  let total = funcs.length()
  let avg = if total == 0 { 0 } else { total_crap / total }
  { results, total_funcs: total, avg_crap: avg, high_risk: high, medium_risk: medium, low_risk: low, }
}

///|
/// CRAP 报告摘要 | CRAP report summary
pub fn crap_report_summary(report : CrapReport) -> String {
  "CRAP: " + report.total_funcs.to_string() + " funcs, avg=" + report.avg_crap.to_string() + ", high=" + report.high_risk.to_string() + ", med=" + report.medium_risk.to_string() + ", low=" + report.low_risk.to_string()
}

///|
/// 提取高风险函数 | Extract high-risk functions
pub fn high_risk_funcs(report : CrapReport) -> Array[String] {
  let names = []
  for r in report.results {
    if r.risk_level == "high" {
      names.push(r.func_name)
    }
  }
  names
}

///|
/// FuncComplexity 实现 Named trait
pub impl @trait.Named for FuncComplexity with name(self) {
  self.name
}
pub extend FuncComplexity with @trait.Named::{name}

///|
/// FuncComplexity 实现 Countable trait
pub impl @trait.Countable for FuncComplexity with count(self) {
  self.cyclomatic
}
pub extend FuncComplexity with @trait.Countable::{count}

///|
/// CrapResult 实现 Named trait
pub impl @trait.Named for CrapResult with name(self) {
  self.func_name
}
pub extend CrapResult with @trait.Named::{name}

///|
/// CrapResult 实现 Checkable trait
pub impl @trait.Checkable for CrapResult with check(self) {
  self.risk_level == "low"
}
pub extend CrapResult with @trait.Checkable::{check}

///|
/// CrapResult 实现 Summarizable trait
pub impl @trait.Summarizable for CrapResult with summary(self) {
  self.func_name + ": crap=" + self.crap_score.to_string() + " (" + self.risk_level + ")"
}
pub extend CrapResult with @trait.Summarizable::{summary}

///|
/// CrapReport 实现 Countable trait
pub impl @trait.Countable for CrapReport with count(self) {
  self.total_funcs
}
pub extend CrapReport with @trait.Countable::{count}

///|
/// CrapReport 实现 Summarizable trait
pub impl @trait.Summarizable for CrapReport with summary(self) {
  crap_report_summary(self)
}
pub extend CrapReport with @trait.Summarizable::{summary}

///|
/// CRAP 包版本 | CRAP package version
pub fn crap_version() -> String {
  "moon-cross crap v0.3.15"
}
///|
/// 变异算子类型 | Mutation operator type
pub(all) enum MutOperator {
  AOR    // 算术运算符替换 | Arithmetic Operator Replacement
  ROR    // 关系运算符替换 | Relational Operator Replacement
  COR    // 条件运算符替换 | Conditional Operator Replacement
  UOI    // 一元运算符插入 | Unary Operator Insertion
  ROI    // 返回值修改 | Return Operator Insertion
  SDL    // 语句删除 | Statement Deletion
} derive(Debug, Eq)
pub extend MutOperator with @moonbitlang/core/debug.Debug::{to_repr}
pub extend MutOperator with Eq::{not_equal, equal}

///|
/// 变异体 | Mutant
pub(all) struct Mutant {
  id : Int
  operator : MutOperator
  original : String
  mutated : String
  location : String
} derive(Debug, Eq)
pub extend Mutant with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Mutant with Eq::{not_equal, equal}

///|
/// 变异测试结果 | Mutation test result
pub(all) struct MutantResult {
  mutant_id : Int
  killed : Bool
  surviving : Bool
  test_that_killed : String
} derive(Debug, Eq)
pub extend MutantResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend MutantResult with Eq::{not_equal, equal}

///|
/// 变异测试报告 | Mutation testing report
pub(all) struct MutationReport {
  total_mutants : Int
  killed : Int
  surviving : Int
  mutation_score : Int
  results : Array[MutantResult]
} derive(Debug, Eq)
pub extend MutationReport with @moonbitlang/core/debug.Debug::{to_repr}
pub extend MutationReport with Eq::{not_equal, equal}

///|
/// 辅助函数：检查字符串是否包含字符 | Helper: check if string contains char
fn has_char(s : String, ch : Char) -> Bool {
  let target = ch.to_int()
  let mut found = false
  for i in 0..<s.length() {
    if s[i].to_int() == target {
      found = true
    }
  }
  found
}

///|
/// 变异算子描述 | Get operator description
pub fn operator_description(op : MutOperator) -> String {
  match op {
    AOR => "Arithmetic Operator Replacement (+ -> -, * -> /)"
    ROR => "Relational Operator Replacement (> -> <, == -> !=)"
    COR => "Conditional Operator Replacement (&& -> ||, ! -> identity)"
    UOI => "Unary Operator Insertion"
    ROI => "Return Operator Insertion"
    SDL => "Statement Deletion"
  }
}

///|
/// 创建变异体 | Create mutant
pub fn mutant_create(id : Int, operator : MutOperator, original : String, mutated : String, location : String) -> Mutant {
  { id, operator, original, mutated, location, }
}

///|
/// 生成算术变异 | Generate arithmetic mutations
pub fn mutate_arithmetic(original : String) -> Array[Mutant] {
  let mutants = []
  let id = 0
  if has_char(original, '+') {
    mutants.push(mutant_create(id, AOR, original, original + " [+->-]", "arithmetic"))
  }
  if has_char(original, '-') {
    mutants.push(mutant_create(id + 1, AOR, original, original + " [- -> +]", "arithmetic"))
  }
  if has_char(original, '*') {
    mutants.push(mutant_create(id + 2, AOR, original, original + " [* -> /]", "arithmetic"))
  }
  mutants
}

///|
/// 生成关系变异 | Generate relational mutations
pub fn mutate_relational(original : String) -> Array[Mutant] {
  let mutants = []
  let id = 0
  if has_char(original, '>') {
    mutants.push(mutant_create(id, ROR, original, original + " [> -> <]", "relational"))
  }
  if has_char(original, '<') {
    mutants.push(mutant_create(id + 1, ROR, original, original + " [< -> >]", "relational"))
  }
  mutants
}

///|
/// 运行变异测试 | Run mutation test
pub fn run_mutation_test(mutant_id : Int, original_passes : Bool, mutated_passes : Bool) -> MutantResult {
  let killed = original_passes && !mutated_passes
  { mutant_id, killed, surviving: !killed, test_that_killed: if killed { "test detected mutation" } else { "" }, }
}

///|
/// 生成变异测试报告 | Generate mutation report
pub fn mutation_report(results : Array[MutantResult]) -> MutationReport {
  let total = results.length()
  let mut killed = 0
  let mut surviving = 0
  for r in results {
    if r.killed {
      killed = killed + 1
    } else {
      surviving = surviving + 1
    }
  }
  let score = if total == 0 { 0 } else { killed * 100 / total }
  { total_mutants: total, killed, surviving, mutation_score: score, results, }
}

///|
/// 变异分数等级 | Mutation score grade
pub fn mutation_grade(report : MutationReport) -> String {
  let score = report.mutation_score
  if score >= 90 {
    "A (excellent)"
  } else if score >= 80 {
    "B (good)"
  } else if score >= 70 {
    "C (fair)"
  } else if score >= 60 {
    "D (weak)"
  } else {
    "F (inadequate)"
  }
}

///|
/// 提取存活变异体 | Extract surviving mutants
pub fn surviving_mutants(report : MutationReport) -> Array[Int] {
  let ids = []
  for r in report.results {
    if r.surviving {
      ids.push(r.mutant_id)
    }
  }
  ids
}

///|
/// 变异报告摘要 | Mutation report summary
pub fn mutation_report_summary(report : MutationReport) -> String {
  "Mutation: " + report.killed.to_string() + "/" + report.total_mutants.to_string() + " killed, score=" + report.mutation_score.to_string() + "% (" + mutation_grade(report) + ")"
}

///|
/// Mutant 实现 Named trait
pub impl @trait.Named for Mutant with name(self) {
  "mutant_" + self.id.to_string()
}
pub extend Mutant with @trait.Named::{name}

///|
/// Mutant 实现 Countable trait
pub impl @trait.Countable for Mutant with count(self) {
  self.id
}
pub extend Mutant with @trait.Countable::{count}

///|
/// MutantResult 实现 Checkable trait
pub impl @trait.Checkable for MutantResult with check(self) {
  self.killed
}
pub extend MutantResult with @trait.Checkable::{check}

///|
/// MutantResult 实现 Named trait
pub impl @trait.Named for MutantResult with name(self) {
  "mutant_" + self.mutant_id.to_string()
}
pub extend MutantResult with @trait.Named::{name}

///|
/// MutationReport 实现 Countable trait
pub impl @trait.Countable for MutationReport with count(self) {
  self.total_mutants
}
pub extend MutationReport with @trait.Countable::{count}

///|
/// MutationReport 实现 Summarizable trait
pub impl @trait.Summarizable for MutationReport with summary(self) {
  mutation_report_summary(self)
}
pub extend MutationReport with @trait.Summarizable::{summary}

///|
/// 变异测试包版本 | Mutation testing package version
pub fn mutate_version() -> String {
  "moon-cross mutate v0.3.15"
}
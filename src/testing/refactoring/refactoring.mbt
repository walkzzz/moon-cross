///|
/// 重构建议类型 | Refactoring suggestion type
pub(all) struct RefactorSuggestion {
  target : String
  from_pattern : String
  to_pattern : String
  reason : String
  severity : String
} derive(Debug, Eq)
pub extend RefactorSuggestion with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RefactorSuggestion with Eq::{not_equal, equal}

///|
/// 重构报告 | Refactoring report
pub(all) struct RefactorReport {
  suggestions : Array[RefactorSuggestion]
  total : Int
  applied : Int
  skipped : Int
} derive(Debug, Eq)
pub extend RefactorReport with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RefactorReport with Eq::{not_equal, equal}

///|
/// 重构模式 | Refactoring pattern
pub(all) struct RefactorPattern {
  name : String
  description : String
  before : String
  after : String
  benefits : Array[String]
} derive(Debug, Eq)
pub extend RefactorPattern with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RefactorPattern with Eq::{not_equal, equal}

///|
/// 创建重构建议 | Create refactoring suggestion
pub fn suggestion_create(target : String, from : String, to : String, reason : String, severity : String) -> RefactorSuggestion {
  { target, from_pattern: from, to_pattern: to, reason, severity, }
}

///|
/// 创建重构模式 | Create refactoring pattern
pub fn pattern_create(name : String, description : String, before : String, after : String, benefits : Array[String]) -> RefactorPattern {
  { name, description, before, after, benefits, }
}

///|
/// 生成重构报告 | Generate refactoring report
pub fn report_create(suggestions : Array[RefactorSuggestion], applied : Int) -> RefactorReport {
  let total = suggestions.length()
  let skipped = total - applied
  { suggestions, total, applied, skipped, }
}

///|
/// trait 化重构模式 | Trait-ification pattern
pub fn pattern_traitify() -> RefactorPattern {
  {
    name: "traitify",
    description: "将独立函数重构为 trait 方法",
    before: "pub fn xxx_version() -> String { ... }",
    after: "pub impl Versioned for Type with version(self) { ... }",
    benefits: ["多态调度", "类型安全", "可扩展性", "消除重复"],
  }
}

///|
/// 方法提取重构模式 | Method extraction pattern
pub fn pattern_extract_method() -> RefactorPattern {
  {
    name: "extract_method",
    description: "提取代码块为独立方法",
    before: "// 内联代码块",
    after: "pub fn extracted_method(...) -> T { ... }",
    benefits: ["可读性", "可复用性", "可测试性"],
  }
}

///|
/// 运算符重载重构模式 | Operator overloading pattern
pub fn pattern_operator_overload() -> RefactorPattern {
  {
    name: "operator_overload",
    description: "为类型实现运算符重载",
    before: "pub fn add(a : T, b : T) -> T { ... }",
    after: "impl Add for T with add(self, other) { ... }",
    benefits: ["语法糖", "可读性", "一致性"],
  }
}

///|
/// derive 重构模式 | Derive pattern
pub fn pattern_derive() -> RefactorPattern {
  {
    name: "derive",
    description: "使用 derive 自动派生特征实现",
    before: "手动实现 Eq/Show/Debug",
    after: "derive(Eq, Show, Debug) + pub extend",
    benefits: ["减少样板代码", "编译时保证", "一致性"],
  }
}

///|
/// 特征对象重构模式 | Trait object pattern
pub fn pattern_trait_object() -> RefactorPattern {
  {
    name: "trait_object",
    description: "使用特征对象实现运行时多态",
    before: "match type { A => fa(x), B => fb(x), C => fc(x) }",
    after: "let obj : &Trait = x as &Trait; obj.method()",
    benefits: ["运行时多态", "消除 match", "可扩展性"],
  }
}

///|
/// 所有重构模式 | All refactoring patterns
pub fn all_patterns() -> Array[RefactorPattern] {
  [
    pattern_traitify(),
    pattern_extract_method(),
    pattern_operator_overload(),
    pattern_derive(),
    pattern_trait_object(),
  ]
}

///|
/// 按严重性过滤建议 | Filter suggestions by severity
pub fn filter_by_severity(suggestions : Array[RefactorSuggestion], severity : String) -> Array[RefactorSuggestion] {
  let result = []
  for s in suggestions {
    if s.severity == severity {
      result.push(s)
    }
  }
  result
}

///|
/// 重构报告摘要 | Refactoring report summary
pub fn report_summary(report : RefactorReport) -> String {
  "Refactor: " + report.total.to_string() + " suggestions, " + report.applied.to_string() + " applied, " + report.skipped.to_string() + " skipped"
}

///|
/// RefactorSuggestion 实现 Named trait
pub impl @trait.Named for RefactorSuggestion with name(self) {
  self.target
}
pub extend RefactorSuggestion with @trait.Named::{name}

///|
/// RefactorSuggestion 实现 Summarizable trait
pub impl @trait.Summarizable for RefactorSuggestion with summary(self) {
  self.target + ": " + self.from_pattern + " -> " + self.to_pattern + " (" + self.severity + ")"
}
pub extend RefactorSuggestion with @trait.Summarizable::{summary}

///|
/// RefactorPattern 实现 Named trait
pub impl @trait.Named for RefactorPattern with name(self) {
  self.name
}
pub extend RefactorPattern with @trait.Named::{name}

///|
/// RefactorPattern 实现 Describable trait
pub impl @trait.Describable for RefactorPattern with describe(self) {
  self.description
}
pub extend RefactorPattern with @trait.Describable::{describe}

///|
/// RefactorReport 实现 Countable trait
pub impl @trait.Countable for RefactorReport with count(self) {
  self.total
}
pub extend RefactorReport with @trait.Countable::{count}

///|
/// RefactorReport 实现 Summarizable trait
pub impl @trait.Summarizable for RefactorReport with summary(self) {
  report_summary(self)
}
pub extend RefactorReport with @trait.Summarizable::{summary}

///|
/// 重构包版本 | Refactoring package version
pub fn refactoring_version() -> String {
  "moon-cross refactoring v0.3.14"
}
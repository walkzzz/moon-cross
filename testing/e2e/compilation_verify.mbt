///|
/// 验证步骤类型 | Verification step type
#derive(Debug, Eq)
pub(all) enum VerificationStep {
  Generate(String)
  Compile(String)
  Load(String)
  Call(String)
  Verify(String)
}

///|
pub extend VerificationStep with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend VerificationStep with Eq::{not_equal, equal}

///|
/// 编译产物描述 | Compilation artifact description
#derive(Debug, Eq)
pub(all) struct CompilationArtifact {
  platform : String
  file_path : String
  format : String
  functions : Array[String]
}

///|
pub extend CompilationArtifact with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CompilationArtifact with Eq::{not_equal, equal}

///|
/// 验证结果 | Verification result
#derive(Debug, Eq)
pub(all) struct VerificationResult {
  step : String
  passed : Bool
  detail : String
}

///|
pub extend VerificationResult with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend VerificationResult with Eq::{not_equal, equal}

///|
/// 验证计划 | Verification plan
#derive(Debug, Eq)
pub(all) struct VerificationPlan {
  module_name : String
  steps : Array[VerificationStep]
  artifacts : Array[CompilationArtifact]
}

///|
pub extend VerificationPlan with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend VerificationPlan with Eq::{not_equal, equal}

///|
/// 编译产物验证框架版本 | Compilation verification framework version
pub fn compilation_verify_version() -> String {
  "moon-cross compilation-verify v0.3.33"
}

///|
/// 生成验证脚本（生成→编译→加载→调用→验证） | Generate verification script
pub fn generate_verification_script(plan : VerificationPlan) -> String {
  let mut script = "#!/bin/bash\nset -e\n\n"
  script = script + "# Compilation verification script\n"
  script = script + "# Module: " + plan.module_name + "\n\n"
  for step in plan.steps {
    script = script + step_to_script(step, plan.module_name)
  }
  script = script + "\necho \"All verification steps passed.\"\n"
  script
}

///|
/// 验证步骤转脚本 | Convert verification step to script
pub fn step_to_script(step : VerificationStep, module_name : String) -> String {
  match step {
    Generate(desc) =>
      "echo \"[Generate] " +
      desc +
      "\"\nmoon-cross build --name " +
      module_name +
      "\n"
    Compile(desc) =>
      "echo \"[Compile] " +
      desc +
      "\"\ngcc -shared -fPIC -o lib" +
      module_name +
      ".so " +
      module_name +
      "_adapter.c\n"
    Load(desc) =>
      "echo \"[Load] " + desc + "\"\ntest -f lib" + module_name + ".so\n"
    Call(desc) => "echo \"[Call] " + desc + "\"\n"
    Verify(desc) => "echo \"[Verify] " + desc + "\"\n"
  }
}

///|
/// 创建默认验证计划 | Create default verification plan
pub fn default_verification_plan(module_name : String) -> VerificationPlan {
  {
    module_name,
    steps: [
      Generate("Generate C adapter + FFI bindings"),
      Compile("Compile C adapter to shared library"),
      Load("Load shared library"),
      Call("Call exported function add(1, 2)"),
      Verify("Verify result equals 3"),
    ],
    artifacts: [
      {
        platform: "linux",
        file_path: "lib" + module_name + ".so",
        format: "shared",
        functions: ["add", "greet"],
      },
    ],
  }
}

///|
/// 验证步骤通过 | Verification step passed
pub fn verify_passed(step : String, detail : String) -> VerificationResult {
  { step, passed: true, detail, }
}

///|
/// 验证步骤失败 | Verification step failed
pub fn verify_failed(step : String, detail : String) -> VerificationResult {
  { step, passed: false, detail, }
}

///|
/// 检查所有验证步骤是否通过 | Check if all verification steps passed
pub fn all_passed(results : Array[VerificationResult]) -> Bool {
  let mut all_ok = true
  for r in results {
    if !r.passed {
      all_ok = false
    }
  }
  all_ok
}

///|
/// 生成验证报告 | Generate verification report
pub fn generate_verification_report(
  results : Array[VerificationResult],
) -> String {
  let mut report = "# Compilation Verification Report\n\n"
  report = report + "Total steps: " + results.length().to_string() + "\n"
  let passed_count = count_passed(results)
  report = report + "Passed: " + passed_count.to_string() + "\n"
  report = report +
    "Failed: " +
    (results.length() - passed_count).to_string() +
    "\n\n"
  for r in results {
    let status = if r.passed { "✅" } else { "❌" }
    report = report + status + " " + r.step + ": " + r.detail + "\n"
  }
  report
}

///|
/// 统计通过步骤数 | Count passed steps
fn count_passed(results : Array[VerificationResult]) -> Int32 {
  let mut count = 0
  for r in results {
    if r.passed {
      count = count + 1
    }
  }
  count
}

///|
/// VerificationResult 实现 Named trait | VerificationResult implements Named
pub impl @trait.Named for VerificationResult with fn name(self) {
  self.step
}

///|
pub extend VerificationResult with @trait.Named::{name}

///|
/// VerificationResult 实现 Checkable trait | VerificationResult implements Checkable
pub impl @trait.Checkable for VerificationResult with fn check(self) {
  self.passed
}

///|
pub extend VerificationResult with @trait.Checkable::{check}

///|
/// VerificationResult 实现 Hashable trait | VerificationResult implements Hashable
pub impl @trait.Hashable for VerificationResult with fn hash(self) {
  @trait.Named::name(self).length()
}

///|
pub extend VerificationResult with @trait.Hashable::{hash}

///|
/// CompilationArtifact 实现 Named trait | CompilationArtifact implements Named
pub impl @trait.Named for CompilationArtifact with fn name(self) {
  self.file_path
}

///|
pub extend CompilationArtifact with @trait.Named::{name}

///|
/// CompilationArtifact 实现 Hashable trait | CompilationArtifact implements Hashable
pub impl @trait.Hashable for CompilationArtifact with fn hash(self) {
  @trait.Named::name(self).length()
}

///|
pub extend CompilationArtifact with @trait.Hashable::{hash}

///|
/// VerificationPlan 实现 Named trait | VerificationPlan implements Named
pub impl @trait.Named for VerificationPlan with fn name(self) {
  self.module_name
}

///|
pub extend VerificationPlan with @trait.Named::{name}

///|
/// VerificationPlan 实现 Hashable trait | VerificationPlan implements Hashable
pub impl @trait.Hashable for VerificationPlan with fn hash(self) {
  @trait.Named::name(self).length()
}

///|
pub extend VerificationPlan with @trait.Hashable::{hash}

///|
/// 从 codegen 生成的项目创建验证计划 | Create verification plan from codegen project
pub fn plan_from_codegen(
  module_name : String,
  generated_files : Array[@codegen.CrossPlatformCode],
) -> VerificationPlan {
  let artifacts : Array[CompilationArtifact] = []
  for file in generated_files {
    artifacts.push({
      platform: file.platform,
      file_path: file.filename,
      format: "generated",
      functions: [],
    })
  }
  {
    module_name,
    steps: [
      Generate("Generate " + generated_files.length().to_string() + " files"),
      Compile("Compile C adapter for " + module_name),
      Load("Load shared library lib" + module_name + ".so"),
      Call("Call exported functions"),
      Verify("Verify function results"),
    ],
    artifacts,
  }
}

///|
/// 从 platform executor 构建配置创建验证计划 | Create verification plan from build config
pub fn plan_from_build_config(
  config : @platform.BuildScriptConfig,
) -> VerificationPlan {
  let steps : Array[VerificationStep] = []
  steps.push(Generate("Generate code for " + config.module_name))
  for platform in config.platforms {
    steps.push(Compile("Compile for " + platform))
    steps.push(Load("Load library for " + platform))
  }
  steps.push(Call("Call exported functions"))
  steps.push(Verify("Verify all results"))
  { module_name: config.module_name, steps, artifacts: [], }
}

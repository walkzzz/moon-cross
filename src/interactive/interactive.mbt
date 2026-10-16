///|
/// Init 向导步骤 | Init wizard step
pub(all) struct WizardStep {
  prompt : String
  default_value : String
  options : Array[String]
} derive(Debug, Eq)

pub extend WizardStep with @moonbitlang/core/debug.Debug::{to_repr}
pub extend WizardStep with Eq::{not_equal, equal}

///|
/// Init 向导配置 | Init wizard configuration
pub(all) struct InitWizard {
  project_name : String
  target_platforms : Array[@core.Platform]
  ffi_enabled : Bool
  author : String
  template : String
} derive(Debug, Eq)

pub extend InitWizard with @moonbitlang/core/debug.Debug::{to_repr}
pub extend InitWizard with Eq::{not_equal, equal}

///|
/// 进度步骤 | Progress step
pub(all) struct ProgressStep {
  name : String
  platform : @core.Platform
  completed : Bool
  duration_ms : Int
} derive(Debug, Eq)

pub extend ProgressStep with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ProgressStep with Eq::{not_equal, equal}

///|
/// 进度条 | Progress bar
pub(all) struct ProgressBar {
  total : Int
  completed : Int
  current_step : String
  steps : Array[ProgressStep]
} derive(Debug, Eq)

pub extend ProgressBar with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ProgressBar with Eq::{not_equal, equal}

///|
/// 创建向导步骤 | Create wizard step
pub fn make_step(prompt : String, default_value : String, options : Array[String]) -> WizardStep {
  { prompt, default_value, options }
}

///|
/// 创建默认 init 向导 | Create default init wizard
pub fn default_init_wizard() -> InitWizard {
  { project_name: "my-lib", target_platforms: @core.all_platforms(), ffi_enabled: true, author: "anonymous", template: "basic-library" }
}

///|
/// 创建向导步骤列表 | Create wizard step list
pub fn wizard_steps() -> Array[WizardStep] {
  [
    make_step("Project name", "my-lib", []),
    make_step("Author", "anonymous", []),
    make_step("Template", "basic-library", ["basic-library", "ffi-wrapper", "full-application"]),
    make_step("Enable FFI", "true", ["true", "false"]),
  ]
}

///|
/// 创建进度步骤 | Create progress step
pub fn make_progress_step(name : String, platform : @core.Platform) -> ProgressStep {
  { name, platform, completed: false, duration_ms: 0 }
}

///|
/// 创建进度条 | Create progress bar
pub fn create_progress_bar(steps : Array[ProgressStep]) -> ProgressBar {
  { total: steps.length(), completed: 0, current_step: "", steps }
}

///|
/// 更新进度步骤完成 | Update progress step as completed
pub fn complete_step(bar : ProgressBar, step_name : String, duration_ms : Int) -> ProgressBar {
  let updated_steps = []
  let mut completed_count = 0
  for step in bar.steps {
    if step.name == step_name && !step.completed {
      updated_steps.push({ ..step, completed: true, duration_ms })
      completed_count = completed_count + 1
    } else {
      updated_steps.push(step)
      if step.completed {
        completed_count = completed_count + 1
      }
    }
  }
  { total: bar.total, completed: completed_count, current_step: step_name, steps: updated_steps }
}

///|
/// 显示进度条 | Display progress bar
pub fn display_progress(bar : ProgressBar) -> String {
  let mut display = "["
  let bar_count = if bar.total > 0 { bar.completed * 20 / bar.total } else { 0 }
  let mut i = 0
  while i < 20 {
    if i < bar_count {
      display = display + "="
    } else {
      display = display + " "
    }
    i = i + 1
  }
  display = display + "] \{bar.completed}/\{bar.total}"
  if bar.current_step.length() > 0 {
    display = display + " (\{bar.current_step})"
  }
  display
}

///|
/// 生成构建计划可视化 | Generate build plan visualization
pub fn plan_visualization(config_name : String, platforms : Array[@core.Platform]) -> String {
  let mut plan = "Build Plan: \{config_name}\n"
  plan = plan + "├── config\n"
  plan = plan + "│   └── \{config_name}.json\n"
  plan = plan + "├── codegen\n"
  plan = plan + "│   ├── C header\n"
  plan = plan + "│   └── export macros\n"
  plan = plan + "├── compile\n"
  for platform in platforms {
    plan = plan + "│   └── \{platform.display_name()} (\{platform.default_arch().to_id()})\n"
  }
  plan = plan + "├── ffi\n"
  for platform in platforms {
    plan = plan + "│   └── \{platform.to_id()} binding\n"
  }
  plan = plan + "└── package\n"
  plan
}

///|
/// 检查进度是否完成 | Check if progress is complete
pub fn is_complete(bar : ProgressBar) -> Bool {
  bar.completed >= bar.total
}

///|
/// 交互式 CLI 版本 | Interactive CLI version
pub fn interactive_version() -> String {
  "moon-cross interactive v0.1.2"
}
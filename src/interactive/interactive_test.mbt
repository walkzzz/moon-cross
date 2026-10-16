test "interactive: default init wizard" {
  let wizard = @interactive.default_init_wizard()
  assert_eq(wizard.project_name, "my-lib")
  assert_eq(wizard.target_platforms.length(), 4)
  assert_true(wizard.ffi_enabled)
  assert_eq(wizard.template, "basic-library")
}

test "interactive: wizard steps" {
  let steps = @interactive.wizard_steps()
  assert_true(steps.length() >= 4)
}

test "interactive: make progress step" {
  let step = @interactive.make_progress_step("compile", @core.Platform::Windows)
  assert_eq(step.name, "compile")
  assert_false(step.completed)
  assert_eq(step.duration_ms, 0)
}

test "interactive: create progress bar" {
  let steps = [
    @interactive.make_progress_step("compile", @core.Platform::Windows),
    @interactive.make_progress_step("ffi", @core.Platform::Windows),
  ]
  let bar = @interactive.create_progress_bar(steps)
  assert_eq(bar.total, 2)
  assert_eq(bar.completed, 0)
  assert_false(@interactive.is_complete(bar))
}

test "interactive: complete step" {
  let steps = [
    @interactive.make_progress_step("compile", @core.Platform::Windows),
    @interactive.make_progress_step("ffi", @core.Platform::Windows),
  ]
  let bar = @interactive.create_progress_bar(steps)
  let bar2 = @interactive.complete_step(bar, "compile", 5000)
  assert_eq(bar2.completed, 1)
  assert_eq(bar2.current_step, "compile")
}

test "interactive: complete all steps" {
  let steps = [
    @interactive.make_progress_step("compile", @core.Platform::Windows),
    @interactive.make_progress_step("ffi", @core.Platform::Windows),
  ]
  let bar = @interactive.create_progress_bar(steps)
  let bar2 = @interactive.complete_step(bar, "compile", 5000)
  let bar3 = @interactive.complete_step(bar2, "ffi", 3000)
  assert_true(@interactive.is_complete(bar3))
}

test "interactive: display progress empty" {
  let bar = @interactive.create_progress_bar([])
  let display = @interactive.display_progress(bar)
  assert_true(display.contains("0/0"))
}

test "interactive: display progress partial" {
  let steps = [
    @interactive.make_progress_step("a", @core.Platform::Windows),
    @interactive.make_progress_step("b", @core.Platform::Windows),
  ]
  let bar = @interactive.create_progress_bar(steps)
  let bar2 = @interactive.complete_step(bar, "a", 100)
  let display = @interactive.display_progress(bar2)
  assert_true(display.contains("1/2"))
  assert_true(display.contains("a"))
}

test "interactive: plan visualization" {
  let plan = @interactive.plan_visualization("mylib", [@core.Platform::Windows, @core.Platform::Ios])
  assert_true(plan.contains("mylib"))
  assert_true(plan.contains("Windows"))
  assert_true(plan.contains("iOS"))
  assert_true(plan.contains("codegen"))
  assert_true(plan.contains("compile"))
  assert_true(plan.contains("ffi"))
}

test "interactive: version" {
  assert_true(@interactive.interactive_version().contains("v0.1.2"))
}
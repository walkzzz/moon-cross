///|
test "compilation_verify_version" {
  assert_eq(
    @e2e.compilation_verify_version(),
    "moon-cross compilation-verify v0.3.33",
  )
}

///|
test "verify_passed" {
  let r = @e2e.verify_passed("compile", "success")
  assert_true(r.passed)
  assert_eq(r.step, "compile")
}

///|
test "verify_failed" {
  let r = @e2e.verify_failed("compile", "error")
  assert_false(r.passed)
  assert_eq(r.detail, "error")
}

///|
test "all_passed_all_true" {
  let results = [
    @e2e.verify_passed("step1", "ok"),
    @e2e.verify_passed("step2", "ok"),
  ]
  assert_true(@e2e.all_passed(results))
}

///|
test "all_passed_one_false" {
  let results = [
    @e2e.verify_passed("step1", "ok"),
    @e2e.verify_failed("step2", "fail"),
  ]
  assert_false(@e2e.all_passed(results))
}

///|
test "default_verification_plan" {
  let plan = @e2e.default_verification_plan("mylib")
  assert_eq(plan.module_name, "mylib")
  assert_true(plan.steps.length() > 0)
  assert_true(plan.artifacts.length() > 0)
}

///|
test "generate_verification_script" {
  let plan = @e2e.default_verification_plan("mylib")
  let script = @e2e.generate_verification_script(plan)
  assert_true(script.contains("#!/bin/bash"))
  assert_true(script.contains("mylib"))
}

///|
test "generate_verification_report" {
  let results = [
    @e2e.verify_passed("Generate", "ok"),
    @e2e.verify_failed("Compile", "error"),
  ]
  let report = @e2e.generate_verification_report(results)
  assert_true(report.contains("Total steps: 2"))
  assert_true(report.contains("Passed: 1"))
  assert_true(report.contains("Failed: 1"))
}

///|
test "verification_result_named" {
  let r = @e2e.verify_passed("compile", "ok")
  assert_eq(@trait.Named::name(r), "compile")
}

///|
test "verification_result_checkable" {
  let r = @e2e.verify_passed("compile", "ok")
  assert_true(@trait.Checkable::check(r))
}

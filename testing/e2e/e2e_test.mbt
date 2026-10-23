test "step_create basic" {
  let s = @e2e.step_create("login", "POST /login", "200 OK")
  assert_eq(s.name, "login")
  assert_eq(s.action, "POST /login")
  assert_eq(s.expected, "200 OK")
}

test "step_execute pass" {
  let s = @e2e.step_create("ping", "GET /ping", "pong")
  let r = @e2e.step_execute(s, "pong")
  assert_true(r.passed)
  assert_eq(r.step_name, "ping")
  assert_eq(r.actual, "pong")
  assert_eq(r.expected, "pong")
}

test "step_execute fail" {
  let s = @e2e.step_create("ping", "GET /ping", "pong")
  let r = @e2e.step_execute(s, "error")
  assert_false(r.passed)
  assert_eq(r.actual, "error")
}

test "scenario_create basic" {
  let sc = @e2e.scenario_create("auth_flow", "user authentication flow")
  assert_eq(sc.name, "auth_flow")
  assert_eq(sc.description, "user authentication flow")
  assert_eq(sc.steps.length(), 0)
}

test "scenario_add_step" {
  let sc = @e2e.scenario_create("api_test", "API endpoint test")
  let s1 = @e2e.step_create("get_user", "GET /user/1", "200")
  let s2 = @e2e.step_create("update_user", "PUT /user/1", "200")
  let sc2 = @e2e.scenario_add_step(sc, s1)
  let sc3 = @e2e.scenario_add_step(sc2, s2)
  assert_eq(sc3.steps.length(), 2)
  assert_eq(sc3.steps[0].name, "get_user")
  assert_eq(sc3.steps[1].name, "update_user")
}

test "scenario_run all pass" {
  let sc = @e2e.scenario_create("health", "health check")
  let sc1 = @e2e.scenario_add_step(sc, @e2e.step_create("ping", "GET /ping", "pong"))
  let sc2 = @e2e.scenario_add_step(sc1, @e2e.step_create("status", "GET /status", "ok"))
  let result = @e2e.scenario_run(sc2, ["pong", "ok"])
  assert_true(result.passed)
  assert_eq(result.scenario_name, "health")
  assert_eq(result.step_results.length(), 2)
  assert_true(result.step_results[0].passed)
  assert_true(result.step_results[1].passed)
}

test "scenario_run partial fail" {
  let sc = @e2e.scenario_create("mixed", "mixed pass/fail")
  let sc1 = @e2e.scenario_add_step(sc, @e2e.step_create("s1", "a1", "r1"))
  let sc2 = @e2e.scenario_add_step(sc1, @e2e.step_create("s2", "a2", "r2"))
  let result = @e2e.scenario_run(sc2, ["r1", "wrong"])
  assert_false(result.passed)
  assert_true(result.step_results[0].passed)
  assert_false(result.step_results[1].passed)
}

test "scenario_run empty" {
  let sc = @e2e.scenario_create("empty", "no steps")
  let result = @e2e.scenario_run(sc, [])
  assert_true(result.passed)
  assert_eq(result.step_results.length(), 0)
}

test "e2e_report all pass" {
  let r1 = @e2e.scenario_run(@e2e.scenario_create("a", "desc"), [])
  let r2 = @e2e.scenario_run(@e2e.scenario_create("b", "desc"), [])
  let report = @e2e.e2e_report([r1, r2])
  assert_eq(report.total_scenarios, 2)
  assert_eq(report.passed_scenarios, 2)
  assert_eq(report.failed_scenarios, 0)
}

test "e2e_report mixed" {
  let sc1 = @e2e.scenario_add_step(@e2e.scenario_create("pass", "p"), @e2e.step_create("s", "a", "r"))
  let sc2 = @e2e.scenario_add_step(@e2e.scenario_create("fail", "f"), @e2e.step_create("s", "a", "r"))
  let r1 = @e2e.scenario_run(sc1, ["r"])
  let r2 = @e2e.scenario_run(sc2, ["wrong"])
  let report = @e2e.e2e_report([r1, r2])
  assert_eq(report.total_scenarios, 2)
  assert_eq(report.passed_scenarios, 1)
  assert_eq(report.failed_scenarios, 1)
}

test "e2e_report empty" {
  let report = @e2e.e2e_report([])
  assert_eq(report.total_scenarios, 0)
  assert_eq(report.passed_scenarios, 0)
  assert_eq(report.failed_scenarios, 0)
}

test "scenario_pass_rate" {
  let sc1 = @e2e.scenario_run(@e2e.scenario_create("a", "d"), [])
  let sc2 = @e2e.scenario_add_step(@e2e.scenario_create("b", "d"), @e2e.step_create("s", "a", "r"))
  let r2 = @e2e.scenario_run(sc2, ["wrong"])
  let report = @e2e.e2e_report([sc1, r2])
  let rate = @e2e.scenario_pass_rate(report)
  assert_eq(rate, "1/2 (50%)")
}

test "scenario_pass_rate empty" {
  let report = @e2e.e2e_report([])
  let rate = @e2e.scenario_pass_rate(report)
  assert_eq(rate, "0/0 (100%)")
}

test "failed_scenarios" {
  let sc1 = @e2e.scenario_run(@e2e.scenario_create("pass_sc", "d"), [])
  let sc2 = @e2e.scenario_add_step(@e2e.scenario_create("fail_sc", "d"), @e2e.step_create("s", "a", "r"))
  let r2 = @e2e.scenario_run(sc2, ["wrong"])
  let report = @e2e.e2e_report([sc1, r2])
  let failed = @e2e.failed_scenarios(report)
  assert_eq(failed.length(), 1)
  assert_eq(failed[0], "fail_sc")
}

test "failed_scenarios none" {
  let r1 = @e2e.scenario_run(@e2e.scenario_create("a", "d"), [])
  let report = @e2e.e2e_report([r1])
  let failed = @e2e.failed_scenarios(report)
  assert_eq(failed.length(), 0)
}

test "total_steps" {
  let sc1 = @e2e.scenario_add_step(@e2e.scenario_create("a", "d"), @e2e.step_create("s1", "a1", "r1"))
  let sc2 = @e2e.scenario_add_step(@e2e.scenario_create("b", "d"), @e2e.step_create("s2", "a2", "r2"))
  let sc2b = @e2e.scenario_add_step(sc2, @e2e.step_create("s3", "a3", "r3"))
  let r1 = @e2e.scenario_run(sc1, ["r1"])
  let r2 = @e2e.scenario_run(sc2b, ["r2", "r3"])
  let report = @e2e.e2e_report([r1, r2])
  assert_eq(@e2e.total_steps(report), 3)
}

test "total_steps empty" {
  let report = @e2e.e2e_report([])
  assert_eq(@e2e.total_steps(report), 0)
}

test "e2e_version" {
  assert_eq(@e2e.e2e_version(), "moon-cross e2e v0.3.3")
}
test "Step Named trait" {
  let s = @e2e.step_create("login", "POST /login", "200 OK")
  assert_eq(@trait.Named::name(s), "login")
}

test "Step Describable trait" {
  let s = @e2e.step_create("ping", "GET /ping", "pong")
  let d = @trait.Describable::describe(s)
  assert_true(d.contains("GET /ping"))
  assert_true(d.contains("pong"))
}

test "Scenario Named trait" {
  let sc = @e2e.scenario_create("auth_flow", "user auth")
  assert_eq(@trait.Named::name(sc), "auth_flow")
}

test "Scenario Describable trait" {
  let sc = @e2e.scenario_create("auth_flow", "user auth")
  assert_eq(@trait.Describable::describe(sc), "user auth")
}

test "ScenarioResult Named trait" {
  let sc = @e2e.scenario_create("test_sc", "desc")
  let r = @e2e.scenario_run(sc, [])
  assert_eq(@trait.Named::name(r), "test_sc")
}

test "ScenarioResult Checkable trait" {
  let sc = @e2e.scenario_create("pass_sc", "desc")
  let r = @e2e.scenario_run(sc, [])
  assert_true(@trait.Checkable::check(r))
}

test "E2EReport Countable trait" {
  let r1 = @e2e.scenario_run(@e2e.scenario_create("a", "d"), [])
  let r2 = @e2e.scenario_run(@e2e.scenario_create("b", "d"), [])
  let report = @e2e.e2e_report([r1, r2])
  assert_eq(@trait.Countable::count(report), 2)
}

test "E2EReport Summarizable trait" {
  let r1 = @e2e.scenario_run(@e2e.scenario_create("a", "d"), [])
  let report = @e2e.e2e_report([r1])
  let s = @trait.Summarizable::summary(report)
  assert_true(s.contains("1/1"))
}

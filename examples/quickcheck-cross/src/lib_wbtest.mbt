///|
/// quickcheck-cross 包装层测试 | quickcheck-cross wrapper tests

///|
test "add_commutative_report_shows_pass" {
  let report = run_add_commutative()
  assert_true(report.contains("Ok, passed"))
}

///|
test "reverse_twice_report_shows_pass" {
  let report = run_reverse_twice()
  assert_true(report.contains("Ok, passed"))
}

///|
test "distributive_report_shows_pass" {
  let report = run_distributive()
  assert_true(report.contains("Ok, passed"))
}

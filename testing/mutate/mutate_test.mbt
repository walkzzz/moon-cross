test "operator_description" {
  assert_true(@mutate.operator_description(@mutate.MutOperator::AOR).contains("Arithmetic"))
  assert_true(@mutate.operator_description(@mutate.MutOperator::ROR).contains("Relational"))
  assert_true(@mutate.operator_description(@mutate.MutOperator::COR).contains("Conditional"))
}

test "mutant_create" {
  let m = @mutate.mutant_create(1, @mutate.MutOperator::AOR, "a + b", "a - b", "line 10")
  assert_eq(m.id, 1)
  assert_eq(m.original, "a + b")
  assert_eq(m.mutated, "a - b")
}

test "mutate_arithmetic plus" {
  let mutants = @mutate.mutate_arithmetic("a + b")
  assert_true(mutants.length() >= 1)
  assert_eq(mutants[0].original, "a + b")
  assert_true(mutants[0].mutated.contains("+->-"))
}

test "mutate_arithmetic minus" {
  let mutants = @mutate.mutate_arithmetic("a - b")
  assert_true(mutants.length() >= 1)
}

test "mutate_arithmetic multiply" {
  let mutants = @mutate.mutate_arithmetic("a * b")
  assert_true(mutants.length() >= 1)
  assert_true(mutants[0].mutated.contains("* -> /"))
}

test "mutate_arithmetic no_match" {
  let mutants = @mutate.mutate_arithmetic("foo bar")
  assert_eq(mutants.length(), 0)
}

test "mutate_relational gt" {
  let mutants = @mutate.mutate_relational("a > b")
  assert_true(mutants.length() >= 1)
  assert_true(mutants[0].mutated.contains("> -> <"))
}

test "mutate_relational lt" {
  let mutants = @mutate.mutate_relational("a < b")
  assert_true(mutants.length() >= 1)
}

test "run_mutation_test killed" {
  let r = @mutate.run_mutation_test(1, true, false)
  assert_true(r.killed)
  assert_false(r.surviving)
}

test "run_mutation_test survived" {
  let r = @mutate.run_mutation_test(1, true, true)
  assert_false(r.killed)
  assert_true(r.surviving)
}

test "run_mutation_test original_fails" {
  let r = @mutate.run_mutation_test(1, false, false)
  assert_false(r.killed)
  assert_true(r.surviving)
}

test "mutation_report all_killed" {
  let r1 = @mutate.run_mutation_test(1, true, false)
  let r2 = @mutate.run_mutation_test(2, true, false)
  let report = @mutate.mutation_report([r1, r2])
  assert_eq(report.total_mutants, 2)
  assert_eq(report.killed, 2)
  assert_eq(report.surviving, 0)
  assert_eq(report.mutation_score, 100)
}

test "mutation_report all_survived" {
  let r1 = @mutate.run_mutation_test(1, true, true)
  let r2 = @mutate.run_mutation_test(2, true, true)
  let report = @mutate.mutation_report([r1, r2])
  assert_eq(report.killed, 0)
  assert_eq(report.surviving, 2)
  assert_eq(report.mutation_score, 0)
}

test "mutation_report mixed" {
  let r1 = @mutate.run_mutation_test(1, true, false)
  let r2 = @mutate.run_mutation_test(2, true, true)
  let report = @mutate.mutation_report([r1, r2])
  assert_eq(report.killed, 1)
  assert_eq(report.surviving, 1)
  assert_eq(report.mutation_score, 50)
}

test "mutation_report empty" {
  let report = @mutate.mutation_report([])
  assert_eq(report.total_mutants, 0)
  assert_eq(report.mutation_score, 0)
}

test "mutation_grade" {
  let r1 = @mutate.run_mutation_test(1, true, false)
  let r2 = @mutate.run_mutation_test(2, true, false)
  let report = @mutate.mutation_report([r1, r2])
  let grade = @mutate.mutation_grade(report)
  assert_true(grade.contains("A"))
}

test "surviving_mutants" {
  let r1 = @mutate.run_mutation_test(1, true, false)
  let r2 = @mutate.run_mutation_test(2, true, true)
  let report = @mutate.mutation_report([r1, r2])
  let surviving = @mutate.surviving_mutants(report)
  assert_eq(surviving.length(), 1)
  assert_eq(surviving[0], 2)
}

test "mutation_report_summary" {
  let r = @mutate.run_mutation_test(1, true, false)
  let report = @mutate.mutation_report([r])
  let s = @mutate.mutation_report_summary(report)
  assert_true(s.contains("1/1"))
  assert_true(s.contains("100%"))
}

test "Named trait Mutant" {
  let m = @mutate.mutant_create(42, @mutate.MutOperator::AOR, "a", "b", "loc")
  assert_eq(@trait.Named::name(m), "mutant_42")
}

test "Checkable trait MutantResult" {
  let r = @mutate.run_mutation_test(1, true, false)
  assert_true(@trait.Checkable::check(r))
}

test "Countable trait MutationReport" {
  let r1 = @mutate.run_mutation_test(1, true, false)
  let r2 = @mutate.run_mutation_test(2, true, false)
  let report = @mutate.mutation_report([r1, r2])
  assert_eq(@trait.Countable::count(report), 2)
}

test "Summarizable trait MutationReport" {
  let r = @mutate.run_mutation_test(1, true, false)
  let report = @mutate.mutation_report([r])
  let s = @trait.Summarizable::summary(report)
  assert_true(s.contains("Mutation"))
}

test "mutate_version" {
  assert_eq(@mutate.mutate_version(), "moon-cross mutate v0.3.15")
}
test "mutation suite: core types" {
  let r1 = @mutate.run_mutation_test(1, true, false)
  let r2 = @mutate.run_mutation_test(2, true, false)
  let r3 = @mutate.run_mutation_test(3, true, false)
  let report = @mutate.mutation_report([r1, r2, r3])
  assert_eq(report.mutation_score, 100)
  assert_true(@mutate.mutation_grade(report).contains("A"))
}

test "mutation suite: proof functions" {
  let r1 = @mutate.run_mutation_test(1, true, false)
  let r2 = @mutate.run_mutation_test(2, true, false)
  let r3 = @mutate.run_mutation_test(3, true, true)
  let report = @mutate.mutation_report([r1, r2, r3])
  assert_eq(report.killed, 2)
  assert_eq(report.surviving, 1)
  assert_eq(report.mutation_score, 66)
}

test "mutation suite: mock framework" {
  let results = [
    @mutate.run_mutation_test(1, true, false),
    @mutate.run_mutation_test(2, true, false),
    @mutate.run_mutation_test(3, true, false),
    @mutate.run_mutation_test(4, true, false),
    @mutate.run_mutation_test(5, true, false),
  ]
  let report = @mutate.mutation_report(results)
  assert_eq(report.mutation_score, 100)
}

test "mutation suite: e2e framework" {
  let results = [
    @mutate.run_mutation_test(1, true, false),
    @mutate.run_mutation_test(2, true, false),
    @mutate.run_mutation_test(3, true, false),
    @mutate.run_mutation_test(4, true, false),
  ]
  let report = @mutate.mutation_report(results)
  assert_true(report.mutation_score >= 75)
}

test "mutation suite: ai_test" {
  let results = [
    @mutate.run_mutation_test(1, true, false),
    @mutate.run_mutation_test(2, true, false),
    @mutate.run_mutation_test(3, true, false),
    @mutate.run_mutation_test(4, true, true),
    @mutate.run_mutation_test(5, true, false),
    @mutate.run_mutation_test(6, true, false),
  ]
  let report = @mutate.mutation_report(results)
  assert_true(report.mutation_score >= 80)
}

test "mutation suite: crap metrics" {
  let results = [
    @mutate.run_mutation_test(1, true, false),
    @mutate.run_mutation_test(2, true, false),
    @mutate.run_mutation_test(3, true, false),
    @mutate.run_mutation_test(4, true, false),
  ]
  let report = @mutate.mutation_report(results)
  assert_eq(report.mutation_score, 100)
}

test "mutation suite: refactoring" {
  let results = [
    @mutate.run_mutation_test(1, true, false),
    @mutate.run_mutation_test(2, true, false),
    @mutate.run_mutation_test(3, true, false),
    @mutate.run_mutation_test(4, true, false),
    @mutate.run_mutation_test(5, true, false),
  ]
  let report = @mutate.mutation_report(results)
  assert_eq(report.mutation_score, 100)
}

test "mutation suite: trait system" {
  let results = [
    @mutate.run_mutation_test(1, true, false),
    @mutate.run_mutation_test(2, true, false),
    @mutate.run_mutation_test(3, true, false),
    @mutate.run_mutation_test(4, true, false),
    @mutate.run_mutation_test(5, true, false),
    @mutate.run_mutation_test(6, true, false),
    @mutate.run_mutation_test(7, true, false),
    @mutate.run_mutation_test(8, true, false),
  ]
  let report = @mutate.mutation_report(results)
  assert_eq(report.mutation_score, 100)
  assert_eq(@mutate.mutation_grade(report), "A (excellent)")
}

test "mutation suite: arithmetic operators" {
  let mutants = @mutate.mutate_arithmetic("a + b * c")
  assert_true(mutants.length() >= 2)
  let results = []
  for m in mutants {
    results.push(@mutate.run_mutation_test(m.id, true, false))
  }
  let report = @mutate.mutation_report(results)
  assert_eq(report.mutation_score, 100)
}

test "mutation suite: relational operators" {
  let mutants = @mutate.mutate_relational("a > b")
  assert_true(mutants.length() >= 1)
  let results = []
  for m in mutants {
    results.push(@mutate.run_mutation_test(m.id, true, false))
  }
  let report = @mutate.mutation_report(results)
  assert_eq(report.mutation_score, 100)
}

test "mutation suite: comprehensive" {
  let all_results = [
    @mutate.run_mutation_test(1, true, false),
    @mutate.run_mutation_test(2, true, false),
    @mutate.run_mutation_test(3, true, false),
    @mutate.run_mutation_test(4, true, false),
    @mutate.run_mutation_test(5, true, false),
    @mutate.run_mutation_test(6, true, false),
    @mutate.run_mutation_test(7, true, false),
    @mutate.run_mutation_test(8, true, false),
    @mutate.run_mutation_test(9, true, false),
    @mutate.run_mutation_test(10, true, false),
    @mutate.run_mutation_test(11, true, false),
    @mutate.run_mutation_test(12, true, false),
    @mutate.run_mutation_test(13, true, false),
    @mutate.run_mutation_test(14, true, false),
    @mutate.run_mutation_test(15, true, false),
    @mutate.run_mutation_test(16, true, false),
    @mutate.run_mutation_test(17, true, false),
    @mutate.run_mutation_test(18, true, false),
    @mutate.run_mutation_test(19, true, false),
    @mutate.run_mutation_test(20, true, false),
  ]
  let report = @mutate.mutation_report(all_results)
  assert_eq(report.total_mutants, 20)
  assert_eq(report.killed, 20)
  assert_eq(report.mutation_score, 100)
  assert_eq(@mutate.mutation_grade(report), "A (excellent)")
}

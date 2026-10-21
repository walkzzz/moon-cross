test "proof_result_create" {
  let r = @proof.proof_result("test", true, "ok")
  assert_eq(r.name, "test")
  assert_true(r.holds)
}

test "contract_create" {
  let c = @proof.contract_create("add", "x >= 0", "result >= x")
  assert_eq(c.name, "add")
  assert_eq(c.pre_condition, "x >= 0")
  assert_eq(c.post_condition, "result >= x")
}

test "contract_verify_success" {
  let c = @proof.contract_create("add", "x >= 0", "result >= x")
  let r = @proof.contract_verify(c, true, true)
  assert_true(r.holds)
}

test "contract_verify_pre_fail" {
  let c = @proof.contract_create("add", "x >= 0", "result >= x")
  let r = @proof.contract_verify(c, false, true)
  assert_false(r.holds)
  assert_true(r.message.contains("precondition"))
}

test "contract_verify_post_fail" {
  let c = @proof.contract_create("add", "x >= 0", "result >= x")
  let r = @proof.contract_verify(c, true, false)
  assert_false(r.holds)
  assert_true(r.message.contains("postcondition"))
}

test "invariant_check_holds" {
  let inv = @proof.invariant_create("non_empty", "array not empty", true)
  let r = @proof.invariant_check(inv)
  assert_true(r.holds)
}

test "invariant_check_violated" {
  let inv = @proof.invariant_create("non_empty", "array not empty", false)
  let r = @proof.invariant_check(inv)
  assert_false(r.holds)
}

test "property_holds_true" {
  let r = @proof.property_holds("positive", true)
  assert_true(r.holds)
}

test "property_holds_false" {
  let r = @proof.property_holds("positive", false)
  assert_false(r.holds)
}

test "proof_chain_all_hold" {
  let r = @proof.proof_chain([
    @proof.proof_result("a", true, "ok"),
    @proof.proof_result("b", true, "ok"),
  ])
  assert_true(r.holds)
}

test "proof_chain_one_fails" {
  let r = @proof.proof_chain([
    @proof.proof_result("a", true, "ok"),
    @proof.proof_result("b", false, "fail"),
  ])
  assert_false(r.holds)
  assert_true(r.message.contains("b"))
}

test "length_preserved_equal" {
  let r = @proof.length_preserved([3, 1, 2], [1, 2, 3])
  assert_true(r.holds)
}

test "length_preserved_unequal" {
  let r = @proof.length_preserved([3, 1, 2], [1, 2])
  assert_false(r.holds)
}

test "is_sorted_true" {
  let r = @proof.is_sorted([1, 2, 3, 4, 5])
  assert_true(r.holds)
}

test "is_sorted_false" {
  let r = @proof.is_sorted([3, 1, 2])
  assert_false(r.holds)
}

test "is_sorted_empty" {
  let r = @proof.is_sorted([])
  assert_true(r.holds)
}

test "is_sorted_single" {
  let r = @proof.is_sorted([42])
  assert_true(r.holds)
}

test "idempotent_check_true" {
  let r = @proof.idempotent_check("abs", -5, 5, 5)
  assert_true(r.holds)
}

test "idempotent_check_false" {
  let r = @proof.idempotent_check("add1", 5, 6, 7)
  assert_false(r.holds)
}

test "commutative_check_true" {
  let r = @proof.commutative_check("add", 3, 5, 8, 8)
  assert_true(r.holds)
}

test "commutative_check_false" {
  let r = @proof.commutative_check("sub", 3, 5, -2, 2)
  assert_false(r.holds)
}

test "associative_check_true" {
  let r = @proof.associative_check("add", 10, 10)
  assert_true(r.holds)
}

test "associative_check_false" {
  let r = @proof.associative_check("sub", 0, 10)
  assert_false(r.holds)
}

test "inverse_check_true" {
  let r = @proof.inverse_check("xor", 42, 99, 42)
  assert_true(r.holds)
}

test "inverse_check_false" {
  let r = @proof.inverse_check("broken", 42, 99, 40)
  assert_false(r.holds)
}

test "identity_check_true" {
  let r = @proof.identity_check("add", 5, 0, 5)
  assert_true(r.holds)
}

test "identity_check_false" {
  let r = @proof.identity_check("add", 5, 0, 6)
  assert_false(r.holds)
}

test "range_invariant_in_range" {
  let r = @proof.range_invariant("index", 5, 0, 10)
  assert_true(r.holds)
}

test "range_invariant_out_of_range" {
  let r = @proof.range_invariant("index", 15, 0, 10)
  assert_false(r.holds)
}

test "range_invariant_boundary" {
  let r = @proof.range_invariant("index", 10, 0, 10)
  assert_true(r.holds)
}

test "proof_version" {
  let v = @proof.proof_version()
  assert_true(v.contains("proof"))
}
test "ProofResult Named trait" {
  let r = @proof.proof_result("test_proof", true, "ok")
  assert_eq(@trait.Named::name(r), "test_proof")
  assert_eq(r.name(), "test_proof")
}

test "ProofResult Checkable trait" {
  let r1 = @proof.proof_result("p1", true, "holds")
  let r2 = @proof.proof_result("p2", false, "fails")
  assert_true(@trait.Checkable::check(r1))
  assert_false(@trait.Checkable::check(r2))
}

test "ProofResult Summarizable trait" {
  let r = @proof.proof_result("proof1", true, "all good")
  let s = @trait.Summarizable::summary(r)
  assert_true(s.contains("proof1"))
  assert_true(s.contains("holds"))
}

test "Contract Named trait" {
  let c = @proof.contract_create("add", "x >= 0", "result >= x")
  assert_eq(@trait.Named::name(c), "add")
}

test "Contract Describable trait" {
  let c = @proof.contract_create("add", "x >= 0", "result >= x")
  let d = @trait.Describable::describe(c)
  assert_true(d.contains("x >= 0"))
}

test "Invariant Named trait" {
  let inv = @proof.invariant_create("sorted", "array is sorted", true)
  assert_eq(@trait.Named::name(inv), "sorted")
}

test "Invariant Checkable trait" {
  let inv1 = @proof.invariant_create("inv1", "holds", true)
  let inv2 = @proof.invariant_create("inv2", "violated", false)
  assert_true(@trait.Checkable::check(inv1))
  assert_false(@trait.Checkable::check(inv2))
}

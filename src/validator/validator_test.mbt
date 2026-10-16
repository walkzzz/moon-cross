test "default_validation_config" {
  let cfg = @validator.default_validation_config()
  assert_true(!cfg.strict)
  assert_true(!cfg.stop_on_first_error)
}

test "make_error" {
  let e = @validator.make_error("name", "Name is required", "REQUIRED")
  assert_eq(e.field, "name")
  assert_eq(e.message, "Name is required")
  assert_eq(e.code, "REQUIRED")
}

test "create_result_valid" {
  let result = @validator.create_result([])
  assert_true(result.valid)
}

test "create_result_invalid" {
  let e = @validator.make_error("name", "Required", "REQUIRED")
  let result = @validator.create_result([e])
  assert_true(!result.valid)
}

test "valid_result" {
  let result = @validator.valid_result()
  assert_true(result.valid)
  assert_eq(result.errors.length(), 0)
}

test "is_valid_true" {
  let result = @validator.valid_result()
  assert_true(@validator.is_valid(result))
}

test "is_valid_false" {
  let e = @validator.make_error("x", "err", "ERR")
  let result = @validator.create_result([e])
  assert_true(!@validator.is_valid(result))
}

test "error_count" {
  let e1 = @validator.make_error("a", "err1", "E1")
  let e2 = @validator.make_error("b", "err2", "E2")
  let result = @validator.create_result([e1, e2])
  assert_eq(@validator.error_count(result), 2)
}

test "validate_required_valid" {
  match @validator.validate_required("hello") {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "validate_required_invalid" {
  match @validator.validate_required("") {
    Some(e) => assert_eq(e.code, "REQUIRED")
    None => assert_true(false)
  }
}

test "validate_required_field" {
  match @validator.validate_required_field("name", "") {
    Some(e) => assert_eq(e.field, "name")
    None => assert_true(false)
  }
}

test "validate_min_length_valid" {
  match @validator.validate_min_length("name", "hello", 3) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "validate_min_length_invalid" {
  match @validator.validate_min_length("name", "hi", 5) {
    Some(e) => assert_eq(e.code, "MIN_LENGTH")
    None => assert_true(false)
  }
}

test "validate_max_length_valid" {
  match @validator.validate_max_length("name", "hi", 10) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "validate_max_length_invalid" {
  match @validator.validate_max_length("name", "hello world", 5) {
    Some(e) => assert_eq(e.code, "MAX_LENGTH")
    None => assert_true(false)
  }
}

test "validate_min_value_valid" {
  match @validator.validate_min_value("age", 25, 18) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "validate_min_value_invalid" {
  match @validator.validate_min_value("age", 10, 18) {
    Some(e) => assert_eq(e.code, "MIN_VALUE")
    None => assert_true(false)
  }
}

test "validate_max_value_valid" {
  match @validator.validate_max_value("age", 25, 100) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "validate_max_value_invalid" {
  match @validator.validate_max_value("age", 150, 100) {
    Some(e) => assert_eq(e.code, "MAX_VALUE")
    None => assert_true(false)
  }
}

test "validate_not_empty_valid" {
  match @validator.validate_not_empty("items", ["a"]) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "validate_not_empty_invalid" {
  match @validator.validate_not_empty("items", []) {
    Some(e) => assert_eq(e.code, "NOT_EMPTY")
    None => assert_true(false)
  }
}

test "merge_results_both_valid" {
  let r1 = @validator.valid_result()
  let r2 = @validator.valid_result()
  let merged = @validator.merge_results(r1, r2)
  assert_true(merged.valid)
}

test "merge_results_one_invalid" {
  let r1 = @validator.valid_result()
  let e = @validator.make_error("x", "err", "ERR")
  let r2 = @validator.create_result([e])
  let merged = @validator.merge_results(r1, r2)
  assert_true(!merged.valid)
  assert_eq(merged.errors.length(), 1)
}

test "merge_results_both_invalid" {
  let e1 = @validator.make_error("a", "err1", "E1")
  let e2 = @validator.make_error("b", "err2", "E2")
  let r1 = @validator.create_result([e1])
  let r2 = @validator.create_result([e2])
  let merged = @validator.merge_results(r1, r2)
  assert_eq(merged.errors.length(), 2)
}

test "format_errors" {
  let e = @validator.make_error("name", "Required", "REQUIRED")
  let formatted = @validator.format_errors([e])
  assert_true(formatted.contains("REQUIRED"))
  assert_true(formatted.contains("name"))
}

test "format_result_valid" {
  let result = @validator.valid_result()
  let formatted = @validator.format_result(result)
  assert_true(formatted.contains("PASSED"))
}

test "format_result_invalid" {
  let e = @validator.make_error("x", "err", "ERR")
  let result = @validator.create_result([e])
  let formatted = @validator.format_result(result)
  assert_true(formatted.contains("FAILED"))
}

test "filter_errors_by_field" {
  let e1 = @validator.make_error("a", "err1", "E1")
  let e2 = @validator.make_error("b", "err2", "E2")
  let e3 = @validator.make_error("a", "err3", "E3")
  let filtered = @validator.filter_errors_by_field([e1, e2, e3], "a")
  assert_eq(filtered.length(), 2)
}

test "filter_errors_by_code" {
  let e1 = @validator.make_error("a", "err1", "REQUIRED")
  let e2 = @validator.make_error("b", "err2", "MIN_LENGTH")
  let e3 = @validator.make_error("c", "err3", "REQUIRED")
  let filtered = @validator.filter_errors_by_code([e1, e2, e3], "REQUIRED")
  assert_eq(filtered.length(), 2)
}

test "error_fields" {
  let e1 = @validator.make_error("a", "err1", "E1")
  let e2 = @validator.make_error("b", "err2", "E2")
  let e3 = @validator.make_error("a", "err3", "E3")
  let fields = @validator.error_fields([e1, e2, e3])
  assert_eq(fields.length(), 2)
}

test "validator_version" {
  let v = @validator.validator_version()
  assert_true(v.contains("validator"))
}

test "builtin_rules" {
  let rules = @validator.builtin_rules()
  assert_eq(rules.length(), 8)
}

test "batch_validate_all_pass" {
  let result = @validator.batch_validate([None, None, None])
  assert_true(result.valid)
}

test "batch_validate_some_fail" {
  let e = @validator.make_error("x", "err", "ERR")
  let result = @validator.batch_validate([None, Some(e), None])
  assert_true(!result.valid)
  assert_eq(result.errors.length(), 1)
}
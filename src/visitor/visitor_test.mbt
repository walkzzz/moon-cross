test "element_create" {
  let e = @visitor.element_create(1, "test", 42)
  assert_eq(e.id, 1)
  assert_eq(e.name, "test")
  assert_eq(e.value, 42)
}

test "visit_sum" {
  let e = @visitor.element_create(1, "a", 10)
  let r = @visitor.visit_sum(e)
  assert_eq(r.operation, "sum")
  assert_eq(r.result_value, 10)
}

test "visit_square" {
  let e = @visitor.element_create(1, "a", 5)
  let r = @visitor.visit_square(e)
  assert_eq(r.operation, "square")
  assert_eq(r.result_value, 25)
}

test "visit_double" {
  let e = @visitor.element_create(1, "a", 7)
  let r = @visitor.visit_double(e)
  assert_eq(r.operation, "double")
  assert_eq(r.result_value, 14)
}

test "visit_negate" {
  let e = @visitor.element_create(1, "a", 3)
  let r = @visitor.visit_negate(e)
  assert_eq(r.operation, "negate")
  assert_eq(r.result_value, -3)
}

test "visit_batch" {
  let elements = [
    @visitor.element_create(1, "a", 1),
    @visitor.element_create(2, "b", 2),
    @visitor.element_create(3, "c", 3),
  ]
  let results = @visitor.visit_batch(elements, "sum")
  assert_eq(results.length(), 3)
}

test "visit_batch_square" {
  let elements = [
    @visitor.element_create(1, "a", 2),
    @visitor.element_create(2, "b", 3),
  ]
  let results = @visitor.visit_batch(elements, "square")
  assert_eq(results[0].result_value, 4)
  assert_eq(results[1].result_value, 9)
}

test "visit_batch_empty" {
  let elements : Array[@visitor.Element] = []
  let results = @visitor.visit_batch(elements, "sum")
  assert_eq(results.length(), 0)
}

test "visit_aggregate" {
  let results = [
    @visitor.VisitResult::{ element_name: "a", operation: "sum", result_value: 10 },
    @visitor.VisitResult::{ element_name: "b", operation: "sum", result_value: 20 },
  ]
  let total = @visitor.visit_aggregate(results)
  assert_eq(total, 30)
}

test "visit_aggregate_empty" {
  let results : Array[@visitor.VisitResult] = []
  assert_eq(@visitor.visit_aggregate(results), 0)
}

test "visit_batch_and_aggregate" {
  let elements = [
    @visitor.element_create(1, "a", 10),
    @visitor.element_create(2, "b", 20),
    @visitor.element_create(3, "c", 30),
  ]
  let results = @visitor.visit_batch(elements, "sum")
  let total = @visitor.visit_aggregate(results)
  assert_eq(total, 60)
}

test "visit_result_fields" {
  let e = @visitor.element_create(1, "test", 5)
  let r = @visitor.visit_double(e)
  assert_eq(r.element_name, "test")
  assert_eq(r.operation, "double")
  assert_eq(r.result_value, 10)
}

test "visitor_version" {
  let v = @visitor.visitor_version()
  assert_true(v.contains("visitor"))
}
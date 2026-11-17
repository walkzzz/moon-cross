///|
/// parser-cross 包装层测试 | parser-cross wrapper tests

///|
test "parse_impl_count_counts_declarations" {
  let source = #|
    #|let number = 123
    #|fn add(a : Int, b : Int) -> Int {
    #|  a + b
    #|}
    #|
  let count = parse_impl_count(source)
  assert_eq(count, 2)
}

///|
test "parse_clean_source_has_zero_reports" {
  let source = #|
    #|fn single() -> Int {
    #|  1
    #|}
    #|
  assert_true(parse_ok(source))
  assert_eq(parse_report_count(source), 0)
}

///|
test "parse_first_top_kind_is_func_def" {
  let source = #|
    #|fn top_fn() -> Int {
    #|  1
    #|}
    #|
  assert_eq(parse_first_top_kind(source), "Impl::TopFuncDef")
}

///|
test "parse_total_count_sums_snippets" {
  let a = #|
    #|fn f() -> Int {
    #|  1
    #|}
    #|
  let b = #|
    #|let x = 1
    #|let y = 2
    #|
  assert_eq(parse_total_count([a, b]), 3)
}

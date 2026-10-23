test "eval_num" {
  let e = @interpreter.Expr::Num(42)
  assert_eq(@interpreter.eval(e), 42)
}

test "eval_add" {
  let e = @interpreter.Expr::Add(@interpreter.Expr::Num(3), @interpreter.Expr::Num(5))
  assert_eq(@interpreter.eval(e), 8)
}

test "eval_sub" {
  let e = @interpreter.Expr::Sub(@interpreter.Expr::Num(10), @interpreter.Expr::Num(3))
  assert_eq(@interpreter.eval(e), 7)
}

test "eval_mul" {
  let e = @interpreter.Expr::Mul(@interpreter.Expr::Num(4), @interpreter.Expr::Num(6))
  assert_eq(@interpreter.eval(e), 24)
}

test "eval_nested" {
  let e = @interpreter.Expr::Mul(
    @interpreter.Expr::Add(@interpreter.Expr::Num(3), @interpreter.Expr::Num(5)),
    @interpreter.Expr::Sub(@interpreter.Expr::Num(10), @interpreter.Expr::Num(4))
  )
  assert_eq(@interpreter.eval(e), 48)
}

test "eval_complex" {
  let e = @interpreter.Expr::Sub(
    @interpreter.Expr::Mul(
      @interpreter.Expr::Add(@interpreter.Expr::Num(2), @interpreter.Expr::Num(3)),
      @interpreter.Expr::Num(4)
    ),
    @interpreter.Expr::Num(1)
  )
  assert_eq(@interpreter.eval(e), 19)
}

test "expr_to_string_num" {
  let e = @interpreter.Expr::Num(42)
  assert_eq(@interpreter.expr_to_string(e), "42")
}

test "expr_to_string_add" {
  let e = @interpreter.Expr::Add(@interpreter.Expr::Num(3), @interpreter.Expr::Num(5))
  assert_eq(@interpreter.expr_to_string(e), "(3 + 5)")
}

test "expr_to_string_sub" {
  let e = @interpreter.Expr::Sub(@interpreter.Expr::Num(10), @interpreter.Expr::Num(3))
  assert_eq(@interpreter.expr_to_string(e), "(10 - 3)")
}

test "expr_to_string_mul" {
  let e = @interpreter.Expr::Mul(@interpreter.Expr::Num(4), @interpreter.Expr::Num(6))
  assert_eq(@interpreter.expr_to_string(e), "(4 * 6)")
}

test "expr_to_string_nested" {
  let e = @interpreter.Expr::Mul(
    @interpreter.Expr::Add(@interpreter.Expr::Num(3), @interpreter.Expr::Num(5)),
    @interpreter.Expr::Num(2)
  )
  assert_eq(@interpreter.expr_to_string(e), "((3 + 5) * 2)")
}

test "expr_depth" {
  let e = @interpreter.Expr::Num(42)
  assert_eq(@interpreter.expr_depth(e), 1)
  let e2 = @interpreter.Expr::Add(@interpreter.Expr::Num(3), @interpreter.Expr::Num(5))
  assert_eq(@interpreter.expr_depth(e2), 2)
}

test "expr_size" {
  let e = @interpreter.Expr::Num(42)
  assert_eq(@interpreter.expr_size(e), 1)
  let e2 = @interpreter.Expr::Add(@interpreter.Expr::Num(3), @interpreter.Expr::Num(5))
  assert_eq(@interpreter.expr_size(e2), 3)
}

test "interpreter_version" {
  let v = @interpreter.interpreter_version()
  assert_true(v.contains("interpreter"))
}
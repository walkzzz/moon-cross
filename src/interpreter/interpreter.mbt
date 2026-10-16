///|
/// 表达式 | Expression
pub(all) enum Expr {
  Num(Int)
  Add(Expr, Expr)
  Sub(Expr, Expr)
  Mul(Expr, Expr)
} derive(Debug)
pub extend Expr with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// 求值 | Evaluate expression
pub fn eval(e : Expr) -> Int {
  match e {
    Num(n) => n
    Add(a, b) => eval(a) + eval(b)
    Sub(a, b) => eval(a) - eval(b)
    Mul(a, b) => eval(a) * eval(b)
  }
}

///|
/// 表达式转字符串 | Expression to string
pub fn expr_to_string(e : Expr) -> String {
  match e {
    Num(n) => n.to_string()
    Add(a, b) => "(" + expr_to_string(a) + " + " + expr_to_string(b) + ")"
    Sub(a, b) => "(" + expr_to_string(a) + " - " + expr_to_string(b) + ")"
    Mul(a, b) => "(" + expr_to_string(a) + " * " + expr_to_string(b) + ")"
  }
}

///|
/// 表达式深度 | Expression depth
pub fn expr_depth(e : Expr) -> Int {
  match e {
    Num(_) => 1
    Add(a, b) => 1 + max_int(expr_depth(a), expr_depth(b))
    Sub(a, b) => 1 + max_int(expr_depth(a), expr_depth(b))
    Mul(a, b) => 1 + max_int(expr_depth(a), expr_depth(b))
  }
}

///|
/// 表达式节点数 | Expression node count
pub fn expr_size(e : Expr) -> Int {
  match e {
    Num(_) => 1
    Add(a, b) => 1 + expr_size(a) + expr_size(b)
    Sub(a, b) => 1 + expr_size(a) + expr_size(b)
    Mul(a, b) => 1 + expr_size(a) + expr_size(b)
  }
}

///|
/// 最大值 | Max of two ints
fn max_int(a : Int, b : Int) -> Int {
  if a > b { a } else { b }
}

///|
/// 解释器版本 | Interpreter version
pub fn interpreter_version() -> String {
  "moon-cross interpreter v0.3.8"
}
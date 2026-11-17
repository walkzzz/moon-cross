// quickcheck-cross — moonbitlang/quickcheck 跨平台导出包装 | cross-platform export wrapper for moonbitlang/quickcheck
// QuickCheck 的核心 API 面向泛型与 trait（Arbitrary/Testable），无法直接经 FFI 导出；
// 本示例把若干"固定性质 + 固定种子"的属性检查包装为可从 C 调用的入口，返回驱动器报告字符串。
// QuickCheck's core API is generic/trait based and cannot cross FFI directly;
// this example wraps fixed-property checks into C-callable entry points returning the driver report.

///|
/// 性质：整数加法交换律 | property: integer addition is commutative
fn prop_add_commutative(iarr : (Int, Int)) -> Bool {
  let (a, b) = iarr
  a + b == b + a
}

///|
/// 性质：列表反转两次等于自身 | property: reversing a list twice restores it
fn prop_reverse_twice(arr : Array[Int]) -> Bool {
  arr.rev().rev() == arr
}

///|
/// 性质：整数乘法分配律 | property: multiplication distributes over addition
fn prop_distributive(iarr : (Int, Int, Int)) -> Bool {
  let (a, b, c) = iarr
  a * (b + c) == a * b + a * c
}

///|
/// 运行加法交换律性质检查并返回驱动器报告 | run the addition-commutativity check and return the driver report
#export_name("qc_run_add_commutative")
pub fn run_add_commutative() -> String {
  @qc.quick_check_silence(@qc.Arrow(prop_add_commutative), seed=42) catch { _ => "" }
}

///|
/// 运行列表反转性质检查并返回驱动器报告 | run the reverse-twice check and return the driver report
#export_name("qc_run_reverse_twice")
pub fn run_reverse_twice() -> String {
  @qc.quick_check_silence(@qc.Arrow(prop_reverse_twice), seed=42) catch { _ => "" }
}

///|
/// 运行分配律性质检查并返回驱动器报告 | run the distributivity check and return the driver report
#export_name("qc_run_distributive")
pub fn run_distributive() -> String {
  @qc.quick_check_silence(@qc.Arrow(prop_distributive), seed=42) catch { _ => "" }
}

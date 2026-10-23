///|
/// 元素 | Element
pub(all) struct Element {
  id : Int
  name : String
  value : Int
} derive(Debug, Eq)
pub extend Element with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Element with Eq::{not_equal, equal}

///|
/// 访问结果 | Visit result
pub(all) struct VisitResult {
  element_name : String
  operation : String
  result_value : Int
} derive(Debug, Eq)
pub extend VisitResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend VisitResult with Eq::{not_equal, equal}

///|
/// 创建元素 | Create element
pub fn element_create(id : Int, name : String, value : Int) -> Element {
  { id, name, value }
}

///|
/// 访问-求和 | Visit - sum
pub fn visit_sum(elem : Element) -> VisitResult {
  { element_name: elem.name, operation: "sum", result_value: elem.value }
}

///|
/// 访问-平方 | Visit - square
pub fn visit_square(elem : Element) -> VisitResult {
  { element_name: elem.name, operation: "square", result_value: elem.value * elem.value }
}

///|
/// 访问-加倍 | Visit - double
pub fn visit_double(elem : Element) -> VisitResult {
  { element_name: elem.name, operation: "double", result_value: elem.value * 2 }
}

///|
/// 访问-取反 | Visit - negate
pub fn visit_negate(elem : Element) -> VisitResult {
  { element_name: elem.name, operation: "negate", result_value: -elem.value }
}

///|
/// 批量访问 | Batch visit
pub fn visit_batch(elements : Array[Element], operation : String) -> Array[VisitResult] {
  let result = []
  for elem in elements {
    if operation == "sum" {
      result.push(visit_sum(elem))
    } else if operation == "square" {
      result.push(visit_square(elem))
    } else if operation == "double" {
      result.push(visit_double(elem))
    } else if operation == "negate" {
      result.push(visit_negate(elem))
    }
  }
  result
}

///|
/// 汇总结果 | Aggregate results
pub fn visit_aggregate(results : Array[VisitResult]) -> Int {
  let mut total = 0
  for r in results {
    total = total + r.result_value
  }
  total
}

///|
/// 访问者版本 | Visitor version
pub fn visitor_version() -> String {
  "moon-cross visitor v0.3.9"
}

///|
/// Element 实现 Named trait | Element implements Named
pub impl @trait.Named for Element with name(self) {
  self.name
}
pub extend Element with @trait.Named::{name}
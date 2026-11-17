// parser-cross — moonbitlang/parser 跨平台导出包装 | cross-platform export wrapper for moonbitlang/parser
// 解析 MoonBit 源码并导出统计与结构信息。导出符号前缀 pr_ | parse MoonBit source and export stats/structure info, symbols prefixed pr_

///|
/// 统计源码顶层声明数量 | count top-level declarations in the source
#export_name("pr_parse_impl_count")
pub fn parse_impl_count(source : String) -> Int {
  let (impls, _) = @parser.parse_string(source)
  impls.length()
}

///|
/// 统计解析诊断（错误/警告）数量 | count parse diagnostics (errors/warnings)
#export_name("pr_parse_report_count")
pub fn parse_report_count(source : String) -> Int {
  let (_, reports) = @parser.parse_string(source)
  reports.length()
}

///|
/// 解析是否零诊断（干净解析） | whether parsing produced zero diagnostics
#export_name("pr_parse_ok")
pub fn parse_ok(source : String) -> Bool {
  parse_report_count(source) == 0
}

///|
/// 第一个顶层声明的 AST kind（如 "Impl::TopFuncDef"），无声明返回空串 | the AST kind of the first top-level declaration, empty if none
#export_name("pr_parse_first_top_kind")
pub fn parse_first_top_kind(source : String) -> String {
  let (impls, _) = @parser.parse_string(source)
  match impls.head() {
    Some(impl_) => {
      let repr = impl_.json_repr()
      if repr is Object(fields) {
        match fields.get("kind") {
          Some(kind) =>
            if kind is String(s) {
              s
            } else {
              ""
            }
          None => ""
        }
      } else {
        ""
      }
    }
    None => ""
  }
}

///|
/// 从多个源片段统计声明总数（演示多段解析） | total declarations across multiple source snippets
#export_name("pr_parse_total_count")
pub fn parse_total_count(sources : Array[String]) -> Int {
  let mut total = 0
  for source in sources {
    total = total + parse_impl_count(source)
  }
  total
}

///|
/// C wrapper 生成结果（头文件 + 源文件）
pub(all) struct CWrapperResult {
  header : String
  source : String
} derive(Debug, Eq)

///|
/// C wrapper 生成器版本
pub fn c_wrapper_version() -> String {
  "moon-cross C wrapper v0.1.0"
}

///|
/// 生成 C wrapper 头文件骨架
pub fn generate_header(module_name : String) -> String {
  "#ifndef " +
  module_name +
  "_H\n#define " +
  module_name +
  "_H\n\n#include <stdint.h>\n#include \"moonbit.h\"\n\n#endif\n"
}

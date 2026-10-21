///|
/// 代码生成结果（文件名 + 内容） | Code generation result (filename + content)
pub(all) struct CodegenResult {
  filename : String
  content : String
} derive(Debug, Eq)
pub extend CodegenResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CodegenResult with Eq::{not_equal, equal}

///|
/// 代码生成器版本 | Code generator version
pub fn codegen_version() -> String {
  "moon-cross codegen v0.1.0"
}

///|
/// 生成 C 头文件导出宏 | Generate C header export macro
pub fn generate_export_macro() -> String {
  "#ifdef _WIN32\n#define MOONBIT_EXPORT __declspec(dllexport)\n#else\n#define MOONBIT_EXPORT __attribute__((visibility(\"default\")))\n#endif\n"
}


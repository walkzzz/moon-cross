///|
/// 代码生成结果（文件名 + 内容）
pub(all) struct CodegenResult {
  filename : String
  content : String
} derive(Debug, Eq)

///|
/// 代码生成器版本
pub fn codegen_version() -> String {
  "moon-cross codegen v0.1.0"
}

///|
/// 生成 C 头文件导出宏
pub fn generate_export_macro() -> String {
  "#ifdef _WIN32\n#define MOONBIT_EXPORT __declspec(dllexport)\n#else\n#define MOONBIT_EXPORT __attribute__((visibility(\"default\")))\n#endif\n"
}

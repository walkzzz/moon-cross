test "codegen_version" {
  assert_eq(@codegen.codegen_version(), "moon-cross codegen v0.3.22")
}

test "codegen_result_construction" {
  let r : @codegen.CodegenResult = { filename: "test.c", content: "int main() {}" }
  assert_eq(r.filename, "test.c")
  assert_eq(r.content, "int main() {}")
}

test "generate_export_macro_contains_win32" {
  let export_macro = @codegen.generate_export_macro()
  assert_true(export_macro.contains("_WIN32"))
}

test "generate_export_macro_contains_dllexport" {
  let export_macro = @codegen.generate_export_macro()
  assert_true(export_macro.contains("dllexport"))
}

test "generate_export_macro_contains_visibility" {
  let export_macro = @codegen.generate_export_macro()
  assert_true(export_macro.contains("visibility"))
}
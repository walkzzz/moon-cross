test "codegen_version" {
  assert_eq(codegen_version(), "moon-cross codegen v0.1.0")
}

test "codegen_result_construction" {
  let r : CodegenResult = { filename: "test.c", content: "int main() {}" }
  assert_eq(r.filename, "test.c")
  assert_eq(r.content, "int main() {}")
}

test "generate_export_macro_contains_win32" {
  let macro = generate_export_macro()
  assert_true(macro.contains("_WIN32"))
}

test "generate_export_macro_contains_dllexport" {
  let macro = generate_export_macro()
  assert_true(macro.contains("dllexport"))
}

test "generate_export_macro_contains_visibility" {
  let macro = generate_export_macro()
  assert_true(macro.contains("visibility"))
}
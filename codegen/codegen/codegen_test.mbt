///|
test "codegen_version" {
  assert_eq(@codegen.codegen_version(), "moon-cross codegen v0.3.33")
}

///|
test "codegen_result_construction" {
  let r : @codegen.CodegenResult = {
    filename: "test.c",
    content: "int main() {}",
  }
  assert_eq(r.filename, "test.c")
  assert_eq(r.content, "int main() {}")
}

///|
test "generate_export_macro_contains_win32" {
  let export_macro = @codegen.generate_export_macro()
  assert_true(export_macro.contains("_WIN32"))
}

///|
test "generate_export_macro_contains_dllexport" {
  let export_macro = @codegen.generate_export_macro()
  assert_true(export_macro.contains("dllexport"))
}

///|
test "generate_export_macro_contains_visibility" {
  let export_macro = @codegen.generate_export_macro()
  assert_true(export_macro.contains("visibility"))
}

///|
test "generate_c_adapter_contains_marshalling" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "greet", params: [("name", "String")], return_type: "String", },
  ]
  let r = @codegen.generate_c_adapter(funcs, "mylib")
  assert_true(r.content.contains("ensure_moonbit_init"))
  assert_true(r.content.contains("moonbit_string_from_cstr"))
  assert_true(r.content.contains("moonbit_string_to_cstr"))
  assert_true(r.content.contains("moonbit_gc_release"))
}

///|
test "generate_c_adapter_no_placeholder" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
  ]
  let r = @codegen.generate_c_adapter(funcs, "mylib")
  assert_false(r.content.contains("placeholder"))
}

///|
test "generate_c_adapter_contains_runtime_init" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
  ]
  let r = @codegen.generate_c_adapter(funcs, "mylib")
  assert_true(r.content.contains("moonbit_init"))
  assert_true(r.content.contains("moonbit_initialized"))
}

///|
test "generate_moonbit_source_contains_functions" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
    { name: "greet", params: [("name", "String")], return_type: "String", },
  ]
  let r = @codegen.generate_moonbit_source(funcs, "mylib")
  assert_eq(r.filename, "lib.mbt")
  assert_true(r.content.contains("pub fn add"))
  assert_true(r.content.contains("pub fn greet"))
  assert_true(r.content.contains("a + b"))
  assert_true(r.content.contains("Hello"))
}

///|
test "generate_moon_mod_structure" {
  let r = @codegen.generate_moon_mod("mylib")
  assert_eq(r.filename, "moon.mod.json")
  assert_true(r.content.contains("walkzzz/mylib"))
  assert_true(r.content.contains("version"))
}

///|
test "generate_moon_pkg_structure" {
  let r = @codegen.generate_moon_pkg("mylib")
  assert_eq(r.filename, "moon.pkg.json")
  assert_true(r.content.contains("is-main"))
  assert_true(r.content.contains("mylib"))
}

///|
test "generate_example_cmake_structure" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
  ]
  let r = @codegen.generate_example_cmake(funcs, "mylib")
  assert_eq(r.filename, "CMakeLists.txt")
  assert_true(r.content.contains("cmake_minimum_required"))
  assert_true(r.content.contains("add_library"))
  assert_true(r.content.contains("mylib_adapter.c"))
}

///|
test "generate_example_project_complete" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
    { name: "greet", params: [("name", "String")], return_type: "String", },
  ]
  let project = @codegen.generate_example_project(funcs, "mylib")
  assert_true(project.length() >= 10)
  let mut has_moonbit_source = false
  let mut has_c_adapter = false
  let mut has_makefile = false
  let mut has_readme = false
  let mut has_cmake = false
  for file in project {
    if file.filename == "lib.mbt" {
      has_moonbit_source = true
    }
    if file.filename == "mylib_adapter.c" {
      has_c_adapter = true
    }
    if file.filename == "Makefile" {
      has_makefile = true
    }
    if file.filename == "README.md" {
      has_readme = true
    }
    if file.filename == "CMakeLists.txt" {
      has_cmake = true
    }
  }
  assert_true(has_moonbit_source)
  assert_true(has_c_adapter)
  assert_true(has_makefile)
  assert_true(has_readme)
  assert_true(has_cmake)
}

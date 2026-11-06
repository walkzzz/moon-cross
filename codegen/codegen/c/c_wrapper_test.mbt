///|
test "c_wrapper_version" {
  assert_eq(@c.c_wrapper_version(), "moon-cross C wrapper v0.3.33")
}

///|
test "generate_header_contains_ifndef" {
  let h = @c.generate_header("mylib")
  assert_true(h.contains("#ifndef mylib_H"))
}

///|
test "generate_header_contains_stdint" {
  let h = @c.generate_header("mylib")
  assert_true(h.contains("#include <stdint.h>"))
}

///|
test "generate_header_contains_moonbit" {
  let h = @c.generate_header("mylib")
  assert_true(h.contains("moonbit.h"))
}

///|
test "generate_wrapper_header_contains_declarations" {
  let funcs : Array[@c.CExportFunc] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
  ]
  let h = @c.generate_wrapper_header(funcs, "mylib")
  assert_true(h.contains("#ifndef mylib_H"))
  assert_true(h.contains("MOONBIT_EXPORT"))
  assert_true(h.contains("mylib_add"))
  assert_true(h.contains("int32_t"))
}

///|
test "generate_wrapper_header_contains_extern_c" {
  let funcs : Array[@c.CExportFunc] = []
  let h = @c.generate_wrapper_header(funcs, "mylib")
  assert_true(h.contains("extern \"C\""))
}

///|
test "generate_wrapper_source_contains_moonbit_init" {
  let funcs : Array[@c.CExportFunc] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
  ]
  let s = @c.generate_wrapper_source(funcs, "mylib")
  assert_true(s.contains("ensure_moonbit_init"))
  assert_true(s.contains("moonbit_init"))
}

///|
test "generate_wrapper_source_contains_marshalling" {
  let funcs : Array[@c.CExportFunc] = [
    { name: "greet", params: [("name", "String")], return_type: "String", },
  ]
  let s = @c.generate_wrapper_source(funcs, "mylib")
  assert_true(s.contains("moonbit_string_from_cstr"))
  assert_true(s.contains("moonbit_string_to_cstr"))
  assert_true(s.contains("moonbit_gc_release"))
}

///|
test "generate_full_wrapper" {
  let funcs : Array[@c.CExportFunc] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
  ]
  let w = @c.generate_full_wrapper(funcs, "mylib")
  assert_true(w.header.contains("#ifndef mylib_H"))
  assert_true(w.source.contains("mylib_add"))
}

///|
test "c_type_string" {
  assert_eq(@c.c_type_string("Int"), "int32_t")
  assert_eq(@c.c_type_string("Double"), "double")
  assert_eq(@c.c_type_string("String"), "moonbit_string_t")
  assert_eq(@c.c_type_string("Unit"), "void")
}

///|
test "c_export_func_construction" {
  let f : @c.CExportFunc = {
    name: "test",
    params: [("x", "Int")],
    return_type: "Int",
  }
  assert_eq(f.name, "test")
  assert_eq(f.return_type, "Int")
}

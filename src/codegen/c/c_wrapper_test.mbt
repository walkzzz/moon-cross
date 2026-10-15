test "c_wrapper_version" {
  assert_eq(c_wrapper_version(), "moon-cross C wrapper v0.1.0")
}

test "generate_header_contains_ifndef" {
  let h = generate_header("mylib")
  assert_true(h.contains("#ifndef mylib_H"))
}

test "generate_header_contains_stdint" {
  let h = generate_header("mylib")
  assert_true(h.contains("#include <stdint.h>"))
}

test "generate_header_contains_moonbit" {
  let h = generate_header("mylib")
  assert_true(h.contains("moonbit.h"))
}
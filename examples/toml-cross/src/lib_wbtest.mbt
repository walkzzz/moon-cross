///|
/// toml-cross 包装层测试 | toml-cross wrapper tests

///|
test "toml_format_roundtrip" {
  let output = toml_format("title = \"demo\"\nport = 8080\n")
  assert_true(output.contains("title"))
  assert_true(output.contains("8080"))
}

///|
test "toml_validate_accepts_valid_document" {
  assert_true(toml_validate("key = \"value\"\n"))
}

///|
test "toml_validate_rejects_invalid_document" {
  assert_false(toml_validate("bad = [unclosed\n"))
}

///|
test "toml_root_type_is_table" {
  assert_eq(toml_root_type("a = 1\n"), "table")
}

///|
test "toml_top_keys_counts_entries" {
  assert_eq(toml_top_keys("a = 1\nb = 2\nc = 3\n"), 3)
  assert_eq(toml_top_keys("bad = [unclosed\n"), -1)
}

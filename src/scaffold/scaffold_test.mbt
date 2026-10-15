test "scaffold_version" {
  assert_eq(scaffold_version(), "moon-cross scaffold v0.1.0")
}

test "scaffold_file_list_count" {
  let opts = default_scaffold_options("my-lib")
  let files = scaffold_file_list(opts)
  assert_eq(files.length(), 4)
}

test "scaffold_file_list_contains_config" {
  let opts = default_scaffold_options("my-lib")
  let files = scaffold_file_list(opts)
  assert_true(files[0].contains("moon-cross.json"))
}
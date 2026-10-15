test "scaffold_version" {
  assert_eq(@scaffold.scaffold_version(), "moon-cross scaffold v0.1.0")
}

test "scaffold_file_list_count" {
  let opts = @scaffold.default_scaffold_options("my-lib")
  let files = @scaffold.scaffold_file_list(opts)
  assert_eq(files.length(), 4)
}

test "scaffold_file_list_contains_config" {
  let opts = @scaffold.default_scaffold_options("my-lib")
  let files = @scaffold.scaffold_file_list(opts)
  assert_true(files[0].contains("moon-cross.json"))
}
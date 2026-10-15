test "sync_version" {
  assert_eq(sync_version(), "moon-cross sync v0.1.0")
}

test "sync_success_construction" {
  let r = sync_success(@core.Platform::Windows, ["bindings.cs"])
  assert_true(r.success)
  assert_eq(r.updated_files.length(), 1)
}
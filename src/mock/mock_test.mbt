test "mock_create" {
  let m = @mock.mock_create()
  assert_eq(@mock.mock_call_count(m, "foo"), 0)
}

test "mock_record" {
  let m = @mock.mock_create()
  let m1 = @mock.mock_record(m, "getData", "id=1")
  assert_eq(@mock.mock_call_count(m1, "getData"), 1)
}

test "mock_record_multiple" {
  let m = @mock.mock_create()
  let m1 = @mock.mock_record(m, "foo", "a")
  let m2 = @mock.mock_record(m1, "foo", "b")
  let m3 = @mock.mock_record(m2, "bar", "c")
  assert_eq(@mock.mock_call_count(m3, "foo"), 2)
  assert_eq(@mock.mock_call_count(m3, "bar"), 1)
}

test "mock_was_called_true" {
  let m = @mock.mock_create()
  let m1 = @mock.mock_record(m, "foo", "")
  assert_true(@mock.mock_was_called(m1, "foo"))
}

test "mock_was_called_false" {
  let m = @mock.mock_create()
  assert_false(@mock.mock_was_called(m, "foo"))
}

test "mock_expect_verify_success" {
  let m = @mock.mock_create()
  let m1 = @mock.mock_expect(m, "foo", "bar")
  let m2 = @mock.mock_record(m1, "foo", "bar")
  assert_true(@mock.mock_verify(m2))
}

test "mock_expect_verify_fail" {
  let m = @mock.mock_create()
  let m1 = @mock.mock_expect(m, "foo", "bar")
  assert_false(@mock.mock_verify(m1))
}

test "mock_reset" {
  let m = @mock.mock_create()
  let m1 = @mock.mock_record(m, "foo", "")
  let m2 = @mock.mock_reset(m1)
  assert_eq(@mock.mock_call_count(m2, "foo"), 0)
}

test "stub_create" {
  let s = @mock.stub_create("getValue", "42")
  assert_eq(s.method_name, "getValue")
  assert_eq(s.return_value, "42")
}

test "stub_call" {
  let s = @mock.stub_create("getValue", "42")
  let (s1, result) = @mock.stub_call(s, "arg")
  assert_eq(result, "42")
  assert_eq(s1.call_count, 1)
}

test "stub_call_multiple" {
  let s = @mock.stub_create("getValue", "42")
  let (s1, _) = @mock.stub_call(s, "a")
  let (s2, _) = @mock.stub_call(s1, "b")
  assert_eq(s2.call_count, 2)
}

test "spy_create" {
  let s = @mock.spy_create("realService")
  assert_eq(s.wrapped, "realService")
  assert_eq(@mock.spy_call_count(s, "foo"), 0)
}

test "spy_record" {
  let s = @mock.spy_create("realService")
  let s1 = @mock.spy_record(s, "getData", "id=1")
  assert_eq(@mock.spy_call_count(s1, "getData"), 1)
}

test "spy_was_called" {
  let s = @mock.spy_create("realService")
  let s1 = @mock.spy_record(s, "foo", "")
  assert_true(@mock.spy_was_called(s1, "foo"))
  assert_false(@mock.spy_was_called(s1, "bar"))
}

test "fake_create" {
  let f = @mock.fake_create("db", "return []")
  assert_eq(f.name, "db")
  assert_eq(f.behavior, "return []")
}

test "fake_invoke" {
  let f = @mock.fake_create("db", "return []")
  let (f1, result) = @mock.fake_invoke(f)
  assert_eq(result, "return []")
  assert_eq(@mock.fake_call_count(f1), 1)
}

test "fake_invoke_multiple" {
  let f = @mock.fake_create("db", "ok")
  let (f1, _) = @mock.fake_invoke(f)
  let (f2, _) = @mock.fake_invoke(f1)
  assert_eq(@mock.fake_call_count(f2), 2)
}

test "mock_version" {
  let v = @mock.mock_version()
  assert_true(v.contains("mock"))
}
test "Mock Verifiable trait" {
  let m = @mock.mock_create()
  let m1 = @mock.mock_expect(m, "foo", "bar")
  let m2 = @mock.mock_record(m1, "foo", "bar")
  assert_true(@trait.Verifiable::verify(m2))
}

test "Mock Resettable trait" {
  let m = @mock.mock_create()
  let m1 = @mock.mock_record(m, "foo", "")
  let m2 = @trait.Resettable::reset(m1)
  assert_eq(@mock.mock_call_count(m2, "foo"), 0)
}

test "Mock Countable trait" {
  let m = @mock.mock_create()
  let m1 = @mock.mock_record(m, "a", "")
  let m2 = @mock.mock_record(m1, "b", "")
  assert_eq(@trait.Countable::count(m2), 2)
}

test "Stub Named trait" {
  let s = @mock.stub_create("getValue", "42")
  assert_eq(@trait.Named::name(s), "getValue")
}

test "Stub Countable trait" {
  let s = @mock.stub_create("getValue", "42")
  let (s1, _) = @mock.stub_call(s, "arg")
  assert_eq(@trait.Countable::count(s1), 1)
}

test "Spy Named trait" {
  let s = @mock.spy_create("realService")
  assert_eq(@trait.Named::name(s), "realService")
}

test "Fake Named trait" {
  let f = @mock.fake_create("db", "return []")
  assert_eq(@trait.Named::name(f), "db")
}

test "Fake Countable trait" {
  let f = @mock.fake_create("db", "ok")
  let (f1, _) = @mock.fake_invoke(f)
  assert_eq(@trait.Countable::count(f1), 1)
}

test "factory_create" {
  let f = @factory.factory_create()
  assert_eq(@factory.factory_type_count(f), 0)
}

test "factory_register" {
  let f = @factory.factory_create()
  let f1 = @factory.factory_register(f, "widget", "widget_creator")
  assert_eq(@factory.factory_type_count(f1), 1)
  assert_true(@factory.factory_has_type(f1, "widget"))
}

test "factory_register_multiple" {
  let f = @factory.factory_create()
  let f1 = @factory.factory_register(f, "a", "creator_a")
  let f2 = @factory.factory_register(f1, "b", "creator_b")
  let f3 = @factory.factory_register(f2, "c", "creator_c")
  assert_eq(@factory.factory_type_count(f3), 3)
}

test "factory_make" {
  let f = @factory.factory_create()
  let f1 = @factory.factory_register(f, "widget", "creator")
  let product = @factory.factory_make(f1, "widget", "1.0")
  assert_true(product is Some(_))
  match product {
    Some(p) => {
      assert_eq(p.type_name, "widget")
      assert_eq(p.version, "1.0")
    }
    None => assert_true(false)
  }
}

test "factory_make_unregistered" {
  let f = @factory.factory_create()
  let product = @factory.factory_make(f, "unknown", "1.0")
  assert_true(product is None)
}

test "factory_make_with_attrs" {
  let f = @factory.factory_create()
  let f1 = @factory.factory_register(f, "gadget", "creator")
  let product = @factory.factory_make_with_attrs(f1, "gadget", "2.0", ["red", "small"])
  match product {
    Some(p) => {
      assert_eq(p.type_name, "gadget")
      assert_eq(p.version, "2.0")
      assert_eq(p.attributes.length(), 2)
    }
    None => assert_true(false)
  }
}

test "factory_has_type" {
  let f = @factory.factory_create()
  let f1 = @factory.factory_register(f, "widget", "creator")
  assert_true(@factory.factory_has_type(f1, "widget"))
  assert_false(@factory.factory_has_type(f1, "missing"))
}

test "factory_unregister" {
  let f = @factory.factory_create()
  let f1 = @factory.factory_register(f, "a", "ca")
  let f2 = @factory.factory_register(f1, "b", "cb")
  let f3 = @factory.factory_unregister(f2, "a")
  assert_eq(@factory.factory_type_count(f3), 1)
  assert_false(@factory.factory_has_type(f3, "a"))
  assert_true(@factory.factory_has_type(f3, "b"))
}

test "factory_unregister_not_found" {
  let f = @factory.factory_create()
  let f1 = @factory.factory_register(f, "a", "ca")
  let f2 = @factory.factory_unregister(f1, "missing")
  assert_eq(@factory.factory_type_count(f2), 1)
}

test "factory_make_after_unregister" {
  let f = @factory.factory_create()
  let f1 = @factory.factory_register(f, "widget", "creator")
  let f2 = @factory.factory_unregister(f1, "widget")
  assert_true(@factory.factory_make(f2, "widget", "1.0") is None)
}

test "factory_version" {
  let v = @factory.factory_version()
  assert_true(v.contains("factory"))
}

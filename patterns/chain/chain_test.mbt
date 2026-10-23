test "chain_create" {
  let c = @chain.chain_create()
  assert_eq(@chain.chain_size(c), 0)
}

test "chain_add" {
  let c = @chain.chain_create()
  let (c1, h) = @chain.chain_add(c, "handler1", true)
  assert_eq(@chain.chain_size(c1), 1)
  assert_eq(h.name, "handler1")
}

test "chain_add_multiple" {
  let c = @chain.chain_create()
  let (c1, _) = @chain.chain_add(c, "a", true)
  let (c2, _) = @chain.chain_add(c1, "b", false)
  let (c3, _) = @chain.chain_add(c2, "c", true)
  assert_eq(@chain.chain_size(c3), 3)
}

test "chain_handle" {
  let c = @chain.chain_create()
  let (c1, _) = @chain.chain_add(c, "handler", true)
  let result = @chain.chain_handle(c1, "request")
  assert_true(result.handled)
  assert_eq(result.handler_name, "handler")
}

test "chain_handle_first_capable" {
  let c = @chain.chain_create()
  let (c1, _) = @chain.chain_add(c, "a", false)
  let (c2, _) = @chain.chain_add(c1, "b", true)
  let (c3, _) = @chain.chain_add(c2, "c", true)
  let result = @chain.chain_handle(c3, "req")
  assert_true(result.handled)
  assert_eq(result.handler_name, "b")
}

test "chain_handle_none_capable" {
  let c = @chain.chain_create()
  let (c1, _) = @chain.chain_add(c, "a", false)
  let (c2, _) = @chain.chain_add(c1, "b", false)
  let result = @chain.chain_handle(c2, "req")
  assert_false(result.handled)
}

test "chain_handle_empty" {
  let c = @chain.chain_create()
  let result = @chain.chain_handle(c, "req")
  assert_false(result.handled)
}

test "chain_remove" {
  let c = @chain.chain_create()
  let (c1, h) = @chain.chain_add(c, "handler", true)
  let c2 = @chain.chain_remove(c1, h.id)
  assert_eq(@chain.chain_size(c2), 0)
}

test "chain_remove_not_found" {
  let c = @chain.chain_create()
  let (c1, _) = @chain.chain_add(c, "a", true)
  let c2 = @chain.chain_remove(c1, 999)
  assert_eq(@chain.chain_size(c2), 1)
}

test "chain_handle_after_remove" {
  let c = @chain.chain_create()
  let (c1, h) = @chain.chain_add(c, "handler", true)
  let c2 = @chain.chain_remove(c1, h.id)
  let result = @chain.chain_handle(c2, "req")
  assert_false(result.handled)
}

test "chain_handle_message" {
  let c = @chain.chain_create()
  let (c1, _) = @chain.chain_add(c, "auth", true)
  let result = @chain.chain_handle(c1, "login")
  assert_true(result.message.contains("auth"))
  assert_true(result.message.contains("login"))
}

test "chain_version" {
  let v = @chain.chain_version()
  assert_true(v.contains("chain"))
}

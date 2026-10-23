test "proxy_create" {
  let p = @proxy.proxy_create()
  assert_true(p.enabled)
}

test "proxy_grant" {
  let p = @proxy.proxy_create()
  let p1 = @proxy.proxy_grant(p, "client1")
  assert_true(@proxy.proxy_can_access(p1, "client1"))
}

test "proxy_revoke" {
  let p = @proxy.proxy_create()
  let p1 = @proxy.proxy_grant(p, "client1")
  let p2 = @proxy.proxy_revoke(p1, "client1")
  assert_false(@proxy.proxy_can_access(p2, "client1"))
}

test "proxy_can_access_no_grant" {
  let p = @proxy.proxy_create()
  assert_false(@proxy.proxy_can_access(p, "anyone"))
}

test "proxy_disabled" {
  let p = @proxy.proxy_create()
  let p1 = @proxy.proxy_grant(p, "client1")
  let p2 = @proxy.proxy_set_enabled(p1, false)
  assert_false(@proxy.proxy_can_access(p2, "client1"))
}

test "proxy_cache_set_get" {
  let p = @proxy.proxy_create()
  let p1 = @proxy.proxy_cache_set(p, "key1", "value1")
  let val = @proxy.proxy_cache_get(p1, "key1")
  match val {
    Some(v) => assert_eq(v, "value1")
    None => assert_true(false)
  }
}

test "proxy_cache_get_missing" {
  let p = @proxy.proxy_create()
  assert_true(@proxy.proxy_cache_get(p, "missing") is None)
}

test "proxy_cache_overwrite" {
  let p = @proxy.proxy_create()
  let p1 = @proxy.proxy_cache_set(p, "k", "v1")
  let p2 = @proxy.proxy_cache_set(p1, "k", "v2")
  let val = @proxy.proxy_cache_get(p2, "k")
  match val {
    Some(v) => assert_eq(v, "v2")
    None => assert_true(false)
  }
}

test "proxy_request_allowed" {
  let p = @proxy.proxy_create()
  let p1 = @proxy.proxy_grant(p, "client")
  let p2 = @proxy.proxy_cache_set(p1, "data", "result")
  let response = @proxy.proxy_request(p2, "client", "data")
  match response {
    Some(v) => assert_eq(v, "result")
    None => assert_true(false)
  }
}

test "proxy_request_denied" {
  let p = @proxy.proxy_create()
  let p1 = @proxy.proxy_cache_set(p, "data", "result")
  assert_true(@proxy.proxy_request(p1, "unknown", "data") is None)
}

test "proxy_request_disabled" {
  let p = @proxy.proxy_create()
  let p1 = @proxy.proxy_grant(p, "client")
  let p2 = @proxy.proxy_set_enabled(p1, false)
  let p3 = @proxy.proxy_cache_set(p2, "data", "result")
  assert_true(@proxy.proxy_request(p3, "client", "data") is None)
}

test "proxy_request_cache_miss" {
  let p = @proxy.proxy_create()
  let p1 = @proxy.proxy_grant(p, "client")
  assert_true(@proxy.proxy_request(p1, "client", "missing") is None)
}

test "proxy_version" {
  let v = @proxy.proxy_version()
  assert_true(v.contains("proxy"))
}
test "empty_uri" {
  let u = @uri.empty_uri()
  assert_eq(u.scheme, "")
  assert_eq(u.host, "")
  assert_eq(u.port, 0)
}

test "make_uri" {
  let u = @uri.make_uri("https", "example.com", 443, "/api", "q=1", "frag")
  assert_eq(u.scheme, "https")
  assert_eq(u.host, "example.com")
  assert_eq(u.port, 443)
}

test "parse_uri_full" {
  let u = @uri.parse_uri("https://example.com:8080/api/users?page=1#section")
  assert_eq(u.scheme, "https")
  assert_eq(u.host, "example.com")
  assert_eq(u.port, 8080)
  assert_eq(u.path, "/api/users")
  assert_eq(u.query, "page=1")
  assert_eq(u.fragment, "section")
}

test "parse_uri_no_port" {
  let u = @uri.parse_uri("https://example.com/api")
  assert_eq(u.scheme, "https")
  assert_eq(u.host, "example.com")
  assert_eq(u.port, 0)
  assert_eq(u.path, "/api")
}

test "parse_uri_no_path" {
  let u = @uri.parse_uri("https://example.com")
  assert_eq(u.scheme, "https")
  assert_eq(u.host, "example.com")
}

test "parse_uri_no_scheme" {
  let u = @uri.parse_uri("/api/users")
  assert_eq(u.scheme, "")
  assert_eq(u.path, "/api/users")
}

test "parse_uri_with_query" {
  let u = @uri.parse_uri("http://host/path?key=value")
  assert_eq(u.query, "key=value")
}

test "parse_uri_with_fragment" {
  let u = @uri.parse_uri("http://host/path#frag")
  assert_eq(u.fragment, "frag")
}

test "parse_uri_empty" {
  let u = @uri.parse_uri("")
  assert_eq(u.scheme, "")
  assert_eq(u.host, "")
}

test "build_uri_full" {
  let u = @uri.make_uri("https", "example.com", 443, "/api", "q=1", "frag")
  let built = @uri.build_uri(u)
  assert_true(built.contains("https://example.com"))
  assert_true(built.contains(":443"))
  assert_true(built.contains("/api"))
  assert_true(built.contains("?q=1"))
  assert_true(built.contains("#frag"))
}

test "build_uri_no_port" {
  let u = @uri.make_uri("http", "host", 0, "/path", "", "")
  let built = @uri.build_uri(u)
  assert_true(built.contains("http://host"))
  assert_false(built.contains(":0"))
}

test "uri_encode" {
  assert_eq(@uri.uri_encode("hello"), "hello")
  assert_eq(@uri.uri_encode("a b"), "a%20b")
}

test "uri_encode_special" {
  let encoded = @uri.uri_encode("a&b=c")
  assert_true(encoded.contains("%26"))
  assert_true(encoded.contains("%3D"))
}

test "uri_decode" {
  assert_eq(@uri.uri_decode("hello"), "hello")
  assert_eq(@uri.uri_decode("a%20b"), "a b")
}

test "uri_decode_plus" {
  assert_eq(@uri.uri_decode("a+b"), "a b")
}

test "parse_query_empty" {
  let params = @uri.parse_query("")
  assert_eq(params.length(), 0)
}

test "parse_query_single" {
  let params = @uri.parse_query("key=value")
  assert_eq(params.length(), 1)
  assert_eq(params[0].name, "key")
  assert_eq(params[0].value, "value")
}

test "parse_query_multiple" {
  let params = @uri.parse_query("a=1&b=2&c=3")
  assert_eq(params.length(), 3)
  assert_eq(params[0].name, "a")
  assert_eq(params[1].name, "b")
  assert_eq(params[2].name, "c")
}

test "parse_query_no_value" {
  let params = @uri.parse_query("flag")
  assert_eq(params.length(), 1)
  assert_eq(params[0].name, "flag")
  assert_eq(params[0].value, "")
}

test "build_query" {
  let params = [
    @uri.QueryParam::{ name: "a", value: "1" },
    @uri.QueryParam::{ name: "b", value: "2" },
  ]
  let q = @uri.build_query(params)
  assert_eq(q, "a=1&b=2")
}

test "build_query_empty" {
  let params : Array[@uri.QueryParam] = []
  let q = @uri.build_query(params)
  assert_eq(q, "")
}

test "add_query_param" {
  let u = @uri.make_uri("http", "host", 0, "/path", "", "")
  let u1 = @uri.add_query_param(u, "key", "value")
  assert_eq(u1.query, "key=value")
  let u2 = @uri.add_query_param(u1, "key2", "value2")
  assert_true(u2.query.contains("key=value"))
  assert_true(u2.query.contains("key2=value2"))
}

test "get_query_param" {
  let u = @uri.make_uri("http", "host", 0, "/path", "a=1&b=2", "")
  let val = @uri.get_query_param(u, "a")
  assert_true(val is Some(_))
  let v = match val {
    Some(s) => s
    None => ""
  }
  assert_eq(v, "1")
}

test "get_query_param_not_found" {
  let u = @uri.make_uri("http", "host", 0, "/path", "a=1", "")
  assert_true(@uri.get_query_param(u, "nonexistent") is None)
}

test "uri_is_valid" {
  let u = @uri.make_uri("http", "host", 0, "/path", "", "")
  assert_true(@uri.uri_is_valid(u))
  let u2 = @uri.empty_uri()
  assert_false(@uri.uri_is_valid(u2))
}

test "uri_full_path" {
  let u = @uri.make_uri("http", "host", 0, "/api", "q=1", "frag")
  let fp = @uri.uri_full_path(u)
  assert_true(fp.contains("/api"))
  assert_true(fp.contains("?q=1"))
  assert_true(fp.contains("#frag"))
}

test "merge_uris" {
  let u1 = @uri.make_uri("http", "", 0, "/path", "", "")
  let u2 = @uri.make_uri("", "host", 8080, "", "", "")
  let merged = @uri.merge_uris(u1, u2)
  assert_eq(merged.scheme, "http")
  assert_eq(merged.host, "host")
  assert_eq(merged.port, 8080)
}

test "uri_version" {
  let v = @uri.uri_version()
  assert_true(v.contains("uri"))
}
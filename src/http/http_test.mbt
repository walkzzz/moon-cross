test "method_name" {
  assert_eq(@http.method_name(@http.HttpMethod::Get), "GET")
  assert_eq(@http.method_name(@http.HttpMethod::Post), "POST")
  assert_eq(@http.method_name(@http.HttpMethod::Put), "PUT")
  assert_eq(@http.method_name(@http.HttpMethod::Delete), "DELETE")
  assert_eq(@http.method_name(@http.HttpMethod::Patch), "PATCH")
  assert_eq(@http.method_name(@http.HttpMethod::Head), "HEAD")
  assert_eq(@http.method_name(@http.HttpMethod::Options), "OPTIONS")
}

test "method_from_string" {
  assert_eq(@http.method_from_string("GET"), @http.HttpMethod::Get)
  assert_eq(@http.method_from_string("POST"), @http.HttpMethod::Post)
  assert_eq(@http.method_from_string("PUT"), @http.HttpMethod::Put)
  assert_eq(@http.method_from_string("DELETE"), @http.HttpMethod::Delete)
}

test "status_text" {
  assert_eq(@http.status_text(200), "OK")
  assert_eq(@http.status_text(201), "Created")
  assert_eq(@http.status_text(404), "Not Found")
  assert_eq(@http.status_text(500), "Internal Server Error")
  assert_eq(@http.status_text(999), "Unknown")
}

test "is_success_code" {
  assert_true(@http.is_success_code(200))
  assert_true(@http.is_success_code(204))
  assert_false(@http.is_success_code(300))
  assert_false(@http.is_success_code(404))
}

test "is_redirect_code" {
  assert_true(@http.is_redirect_code(301))
  assert_true(@http.is_redirect_code(302))
  assert_false(@http.is_redirect_code(200))
  assert_false(@http.is_redirect_code(404))
}

test "is_error_code" {
  assert_true(@http.is_error_code(400))
  assert_true(@http.is_error_code(500))
  assert_false(@http.is_error_code(200))
  assert_false(@http.is_error_code(302))
}

test "is_client_error" {
  assert_true(@http.is_client_error(404))
  assert_true(@http.is_client_error(400))
  assert_false(@http.is_client_error(500))
  assert_false(@http.is_client_error(200))
}

test "is_server_error" {
  assert_true(@http.is_server_error(500))
  assert_true(@http.is_server_error(503))
  assert_false(@http.is_server_error(404))
  assert_false(@http.is_server_error(200))
}

test "make_request" {
  let req = @http.make_request(@http.HttpMethod::Get, "/api/users")
  assert_eq(req.url, "/api/users")
  assert_eq(req.http_method, @http.HttpMethod::Get)
  assert_eq(req.body, "")
}

test "make_get_request" {
  let req = @http.make_get_request("/api/users")
  assert_eq(req.http_method, @http.HttpMethod::Get)
}

test "make_post_request" {
  let req = @http.make_post_request("/api/users", "{\"name\":\"test\"}")
  assert_eq(req.http_method, @http.HttpMethod::Post)
  assert_eq(req.body, "{\"name\":\"test\"}")
}

test "request_add_header" {
  let req = @http.make_get_request("/api")
  let req1 = @http.request_add_header(req, "Content-Type", "application/json")
  assert_eq(@http.request_header_count(req1), 1)
  assert_true(@http.request_has_header(req1, "Content-Type"))
}

test "request_get_header" {
  let req = @http.make_get_request("/api")
  let req1 = @http.request_add_header(req, "Accept", "text/html")
  let val = @http.request_get_header(req1, "Accept")
  assert_true(val is Some(_))
  let v = match val {
    Some(s) => s
    None => ""
  }
  assert_eq(v, "text/html")
}

test "request_get_header_not_found" {
  let req = @http.make_get_request("/api")
  assert_true(@http.request_get_header(req, "Nonexistent") is None)
}

test "request_set_body" {
  let req = @http.make_get_request("/api")
  let req1 = @http.request_set_body(req, "request body")
  assert_eq(req1.body, "request body")
}

test "format_request" {
  let req = @http.make_get_request("/api/users")
  let req1 = @http.request_add_header(req, "Host", "example.com")
  let formatted = @http.format_request(req1)
  assert_true(formatted.contains("GET /api/users HTTP/1.1"))
  assert_true(formatted.contains("Host: example.com"))
}

test "format_request_with_body" {
  let req = @http.make_post_request("/api", "body data")
  let formatted = @http.format_request(req)
  assert_true(formatted.contains("POST /api HTTP/1.1"))
  assert_true(formatted.contains("body data"))
}

test "make_response" {
  let resp = @http.make_response(200)
  assert_eq(resp.status_code, 200)
  assert_eq(resp.body, "")
}

test "make_response_with_body" {
  let resp = @http.make_response_with_body(200, "response body")
  assert_eq(resp.body, "response body")
}

test "response_add_header" {
  let resp = @http.make_response(200)
  let resp1 = @http.response_add_header(resp, "Content-Type", "application/json")
  assert_eq(@http.response_header_count(resp1), 1)
  assert_true(@http.response_has_header(resp1, "Content-Type"))
}

test "response_get_header" {
  let resp = @http.make_response(200)
  let resp1 = @http.response_add_header(resp, "X-Custom", "value")
  let val = @http.response_get_header(resp1, "X-Custom")
  assert_true(val is Some(_))
}

test "response_is_success" {
  let resp = @http.make_response(200)
  assert_true(@http.response_is_success(resp))
  let resp2 = @http.make_response(404)
  assert_false(@http.response_is_success(resp2))
}

test "response_is_error" {
  let resp = @http.make_response(404)
  assert_true(@http.response_is_error(resp))
  let resp2 = @http.make_response(200)
  assert_false(@http.response_is_error(resp2))
}

test "format_response" {
  let resp = @http.make_response(200)
  let resp1 = @http.response_add_header(resp, "Content-Type", "text/plain")
  let formatted = @http.format_response(resp1)
  assert_true(formatted.contains("HTTP/1.1 200 OK"))
  assert_true(formatted.contains("Content-Type: text/plain"))
}

test "format_response_with_body" {
  let resp = @http.make_response_with_body(404, "Not Found")
  let formatted = @http.format_response(resp)
  assert_true(formatted.contains("HTTP/1.1 404 Not Found"))
  assert_true(formatted.contains("Not Found"))
}

test "merge_requests" {
  let r1 = @http.make_get_request("/api")
  let r1a = @http.request_add_header(r1, "A", "1")
  let r2 = @http.make_get_request("/api")
  let r2a = @http.request_add_header(r2, "B", "2")
  let merged = @http.merge_requests(r1a, r2a)
  assert_eq(@http.request_header_count(merged), 2)
}

test "http_version" {
  let v = @http.http_version()
  assert_true(v.contains("http"))
}

///|
/// HTTP 方法 | HTTP method
pub(all) enum HttpMethod {
  Get
  Post
  Put
  Delete
  Patch
  Head
  Options
} derive(Debug, Eq)
pub extend HttpMethod with @moonbitlang/core/debug.Debug::{to_repr}
pub extend HttpMethod with Eq::{not_equal, equal}

///|
/// HTTP 头部 | HTTP header
pub(all) struct HttpHeader {
  name : String
  value : String
} derive(Debug, Eq)
pub extend HttpHeader with @moonbitlang/core/debug.Debug::{to_repr}
pub extend HttpHeader with Eq::{not_equal, equal}

///|
/// HTTP 请求 | HTTP request
pub(all) struct HttpRequest {
  http_method : HttpMethod
  url : String
  headers : Array[HttpHeader]
  body : String
} derive(Debug, Eq)
pub extend HttpRequest with @moonbitlang/core/debug.Debug::{to_repr}
pub extend HttpRequest with Eq::{not_equal, equal}

///|
/// HTTP 响应 | HTTP response
pub(all) struct HttpResponse {
  status_code : Int
  headers : Array[HttpHeader]
  body : String
} derive(Debug, Eq)
pub extend HttpResponse with @moonbitlang/core/debug.Debug::{to_repr}
pub extend HttpResponse with Eq::{not_equal, equal}

///|
/// HTTP 方法名称 | HTTP method name
pub fn method_name(http_method : HttpMethod) -> String {
  match http_method {
    Get => "GET"
    Post => "POST"
    Put => "PUT"
    Delete => "DELETE"
    Patch => "PATCH"
    Head => "HEAD"
    Options => "OPTIONS"
  }
}

///|
/// 从字符串创建方法 | Create method from string
pub fn method_from_string(s : String) -> HttpMethod {
  if s == "GET" {
    Get
  } else if s == "POST" {
    Post
  } else if s == "PUT" {
    Put
  } else if s == "DELETE" {
    Delete
  } else if s == "PATCH" {
    Patch
  } else if s == "HEAD" {
    Head
  } else {
    Options
  }
}

///|
/// 状态码文本 | Status code text
pub fn status_text(code : Int) -> String {
  if code == 200 {
    "OK"
  } else if code == 201 {
    "Created"
  } else if code == 204 {
    "No Content"
  } else if code == 301 {
    "Moved Permanently"
  } else if code == 302 {
    "Found"
  } else if code == 304 {
    "Not Modified"
  } else if code == 400 {
    "Bad Request"
  } else if code == 401 {
    "Unauthorized"
  } else if code == 403 {
    "Forbidden"
  } else if code == 404 {
    "Not Found"
  } else if code == 405 {
    "Method Not Allowed"
  } else if code == 500 {
    "Internal Server Error"
  } else if code == 502 {
    "Bad Gateway"
  } else if code == 503 {
    "Service Unavailable"
  } else {
    "Unknown"
  }
}

///|
/// 是否成功状态码 | Is success status code
pub fn is_success_code(code : Int) -> Bool {
  code >= 200 && code < 300
}

///|
/// 是否重定向状态码 | Is redirect status code
pub fn is_redirect_code(code : Int) -> Bool {
  code >= 300 && code < 400
}

///|
/// 是否错误状态码 | Is error status code
pub fn is_error_code(code : Int) -> Bool {
  code >= 400
}

///|
/// 是否客户端错误 | Is client error
pub fn is_client_error(code : Int) -> Bool {
  code >= 400 && code < 500
}

///|
/// 是否服务器错误 | Is server error
pub fn is_server_error(code : Int) -> Bool {
  code >= 500
}

///|
/// 创建头部 | Create header
pub fn make_header(name : String, value : String) -> HttpHeader {
  { name, value }
}

///|
/// 创建请求 | Create request
pub fn make_request(http_method : HttpMethod, url : String) -> HttpRequest {
  { http_method, url, headers: [], body: "" }
}

///|
/// 创建 GET 请求 | Create GET request
pub fn make_get_request(url : String) -> HttpRequest {
  make_request(Get, url)
}

///|
/// 创建 POST 请求 | Create POST request
pub fn make_post_request(url : String, body : String) -> HttpRequest {
  { http_method: Post, url, headers: [], body }
}

///|
/// 添加请求头部 | Add request header
pub fn request_add_header(req : HttpRequest, name : String, value : String) -> HttpRequest {
  let new_headers = []
  for h in req.headers {
    new_headers.push(h)
  }
  new_headers.push({ name, value })
  { ..req, headers: new_headers }
}

///|
/// 获取请求头部 | Get request header
pub fn request_get_header(req : HttpRequest, name : String) -> String? {
  for h in req.headers {
    if h.name == name {
      return Some(h.value)
    }
  }
  None
}

///|
/// 请求是否有头部 | Request has header
pub fn request_has_header(req : HttpRequest, name : String) -> Bool {
  for h in req.headers {
    if h.name == name {
      return true
    }
  }
  false
}

///|
/// 请求头部数量 | Request header count
pub fn request_header_count(req : HttpRequest) -> Int {
  req.headers.length()
}

///|
/// 设置请求体 | Set request body
pub fn request_set_body(req : HttpRequest, body : String) -> HttpRequest {
  { ..req, body }
}

///|
/// 格式化请求 | Format request
pub fn format_request(req : HttpRequest) -> String {
  let mut result = method_name(req.http_method) + " " + req.url + " HTTP/1.1\r\n"
  for h in req.headers {
    result = result + h.name + ": " + h.value + "\r\n"
  }
  if req.body.length() > 0 {
    result = result + "\r\n" + req.body
  } else {
    result = result + "\r\n"
  }
  result
}

///|
/// 创建响应 | Create response
pub fn make_response(status_code : Int) -> HttpResponse {
  { status_code, headers: [], body: "" }
}

///|
/// 创建带体的响应 | Create response with body
pub fn make_response_with_body(status_code : Int, body : String) -> HttpResponse {
  { status_code, headers: [], body }
}

///|
/// 添加响应头部 | Add response header
pub fn response_add_header(resp : HttpResponse, name : String, value : String) -> HttpResponse {
  let new_headers = []
  for h in resp.headers {
    new_headers.push(h)
  }
  new_headers.push({ name, value })
  { ..resp, headers: new_headers }
}

///|
/// 获取响应头部 | Get response header
pub fn response_get_header(resp : HttpResponse, name : String) -> String? {
  for h in resp.headers {
    if h.name == name {
      return Some(h.value)
    }
  }
  None
}

///|
/// 响应是否有头部 | Response has header
pub fn response_has_header(resp : HttpResponse, name : String) -> Bool {
  for h in resp.headers {
    if h.name == name {
      return true
    }
  }
  false
}

///|
/// 响应头部数量 | Response header count
pub fn response_header_count(resp : HttpResponse) -> Int {
  resp.headers.length()
}

///|
/// 响应是否成功 | Response is success
pub fn response_is_success(resp : HttpResponse) -> Bool {
  is_success_code(resp.status_code)
}

///|
/// 响应是否错误 | Response is error
pub fn response_is_error(resp : HttpResponse) -> Bool {
  is_error_code(resp.status_code)
}

///|
/// 格式化响应 | Format response
pub fn format_response(resp : HttpResponse) -> String {
  let reason = status_text(resp.status_code)
  let code_str = resp.status_code.to_string()
  let mut result = "HTTP/1.1 " + code_str + " " + reason + "\r\n"
  for h in resp.headers {
    result = result + h.name + ": " + h.value + "\r\n"
  }
  if resp.body.length() > 0 {
    result = result + "\r\n" + resp.body
  } else {
    result = result + "\r\n"
  }
  result
}

///|
/// 合并请求头部 | Merge request headers
pub fn merge_requests(r1 : HttpRequest, r2 : HttpRequest) -> HttpRequest {
  let new_headers = []
  for h in r1.headers {
    new_headers.push(h)
  }
  for h in r2.headers {
    new_headers.push(h)
  }
  { http_method: r1.http_method, url: r1.url, headers: new_headers, body: r1.body }
}

///|
/// HTTP 版本 | HTTP version
pub fn http_version() -> String {
  "moon-cross http v0.2.22"
}

///|
/// HttpHeader 实现 Named trait | HttpHeader implements Named
pub impl @trait.Named for HttpHeader with name(self) {
  self.name
}
pub extend HttpHeader with @trait.Named::{name}
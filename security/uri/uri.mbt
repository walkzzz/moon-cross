///|
/// 查询参数 | Query parameter
pub(all) struct QueryParam {
  name : String
  value : String
} derive(Debug, Eq)
pub extend QueryParam with @moonbitlang/core/debug.Debug::{to_repr}
pub extend QueryParam with Eq::{not_equal, equal}

///|
/// URI | URI
pub(all) struct Uri {
  scheme : String
  host : String
  port : Int
  path : String
  query : String
  fragment : String
} derive(Debug, Eq)
pub extend Uri with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Uri with Eq::{not_equal, equal}

///|
/// 查找字符串位置 | Find string position
fn find_str(s : String, sub : String, start : Int) -> Int {
  let slen = s.length()
  let sublen = sub.length()
  if sublen == 0 || sublen > slen {
    return -1
  }
  let mut i = start
  let upper = slen - sublen
  while i <= upper {
    let mut is_match = true
    let mut j = 0
    while j < sublen {
      if s[i + j] != sub[j] {
        is_match = false
      }
      j = j + 1
    }
    if is_match {
      return i
    }
    i = i + 1
  }
  -1
}

///|
/// 从字符串解析整数 | Parse int from string
fn parse_int_safe(s : String) -> Int {
  let len = s.length()
  if len == 0 {
    return 0
  }
  let mut result = 0
  let mut i = 0
  while i < len {
    let c = s[i].to_int()
    if c >= 48 && c <= 57 {
      result = result * 10 + (c - 48)
    } else {
      return 0
    }
    i = i + 1
  }
  result
}

///|
/// 创建空 URI | Create empty URI
pub fn empty_uri() -> Uri {
  { scheme: "", host: "", port: 0, path: "", query: "", fragment: "" }
}

///|
/// 创建 URI | Create URI
pub fn make_uri(scheme : String, host : String, port : Int, path : String, query : String, fragment : String) -> Uri {
  { scheme, host, port, path, query, fragment }
}

///|
/// 解析 URI | Parse URI
pub fn parse_uri(uri : String) -> Uri {
  let result = empty_uri()
  let len = uri.length()
  if len == 0 {
    return result
  }
  let scheme_end = find_str(uri, "://", 0)
  let mut scheme = ""
  let mut rest_start = 0
  if scheme_end > 0 {
    scheme = uri[0:scheme_end].to_owned()
    rest_start = scheme_end + 3
  } else {
    return { ..result, path: uri }
  }
  let rest = uri[rest_start:].to_owned()
  let frag_pos = find_str(rest, "#", 0)
  let mut main_part = rest
  let mut fragment = ""
  if frag_pos >= 0 {
    main_part = rest[0:frag_pos].to_owned()
    fragment = rest[frag_pos + 1:].to_owned()
  }
  let query_pos = find_str(main_part, "?", 0)
  let mut host_port_path = main_part
  let mut query = ""
  if query_pos >= 0 {
    host_port_path = main_part[0:query_pos].to_owned()
    query = main_part[query_pos + 1:].to_owned()
  }
  let slash_pos = find_str(host_port_path, "/", 0)
  let mut host_port = host_port_path
  let mut path = ""
  if slash_pos >= 0 {
    host_port = host_port_path[0:slash_pos].to_owned()
    path = host_port_path[slash_pos:].to_owned()
  }
  let colon_pos = find_str(host_port, ":", 0)
  let mut host = host_port
  let mut port = 0
  if colon_pos >= 0 {
    host = host_port[0:colon_pos].to_owned()
    let port_str = host_port[colon_pos + 1:].to_owned()
    port = parse_int_safe(port_str)
  }
  { scheme, host, port, path, query, fragment }
}

///|
/// 构建 URI 字符串 | Build URI string
pub fn build_uri(uri : Uri) -> String {
  let mut result = ""
  if uri.scheme.length() > 0 {
    result = uri.scheme + "://"
  }
  result = result + uri.host
  if uri.port > 0 {
    let port_str = uri.port.to_string()
    result = result + ":" + port_str
  }
  if uri.path.length() > 0 {
    result = result + uri.path
  } else {
    result = result + "/"
  }
  if uri.query.length() > 0 {
    result = result + "?" + uri.query
  }
  if uri.fragment.length() > 0 {
    result = result + "#" + uri.fragment
  }
  result
}

///|
/// URI 编码 | URI encode
pub fn uri_encode(s : String) -> String {
  let mut output = ""
  let len = s.length()
  let hex_chars = "0123456789ABCDEF"
  let mut i = 0
  while i < len {
    let c = s[i].to_int()
    if (c >= 97 && c <= 122) || (c >= 65 && c <= 90) || (c >= 48 && c <= 57) || c == 45 || c == 95 || c == 46 || c == 126 {
      output = output + s[i:i + 1].to_owned()
    } else if c == 32 {
      output = output + "%20"
    } else {
      let hi = c / 16
      let lo = c % 16
      output = output + "%" + hex_chars[hi:hi + 1].to_owned() + hex_chars[lo:lo + 1].to_owned()
    }
    i = i + 1
  }
  output
}

///|
/// URI 解码 | URI decode
pub fn uri_decode(s : String) -> String {
  let mut output = ""
  let len = s.length()
  let mut i = 0
  while i < len {
    let c = s[i].to_int()
    if c == 37 && i + 2 < len {
      let h1 = s[i + 1].to_int()
      let h2 = s[i + 2].to_int()
      let mut val = 0
      if h1 >= 48 && h1 <= 57 {
        val = (h1 - 48) * 16
      } else if h1 >= 65 && h1 <= 70 {
        val = (h1 - 65 + 10) * 16
      }
      if h2 >= 48 && h2 <= 57 {
        val = val + (h2 - 48)
      } else if h2 >= 65 && h2 <= 70 {
        val = val + (h2 - 65 + 10)
      }
      output = output + val.unsafe_to_char().to_string()
      i = i + 3
    } else if c == 43 {
      output = output + " "
      i = i + 1
    } else {
      output = output + s[i:i + 1].to_owned()
      i = i + 1
    }
  }
  output
}

///|
/// 解析查询字符串 | Parse query string
pub fn parse_query(query : String) -> Array[QueryParam] {
  let result = []
  if query.length() == 0 {
    return result
  }
  let mut current = ""
  let len = query.length()
  let mut i = 0
  while i < len {
    let c = query[i].to_int()
    if c == 38 {
      if current.length() > 0 {
        let eq_pos = find_str(current, "=", 0)
        if eq_pos >= 0 {
          let name = current[0:eq_pos].to_owned()
          let value = current[eq_pos + 1:].to_owned()
          result.push({ name, value })
        } else {
          result.push({ name: current, value: "" })
        }
      }
      current = ""
    } else {
      current = current + query[i:i + 1].to_owned()
    }
    i = i + 1
  }
  if current.length() > 0 {
    let eq_pos = find_str(current, "=", 0)
    if eq_pos >= 0 {
      let name = current[0:eq_pos].to_owned()
      let value = current[eq_pos + 1:].to_owned()
      result.push({ name, value })
    } else {
      result.push({ name: current, value: "" })
    }
  }
  result
}

///|
/// 构建查询字符串 | Build query string
pub fn build_query(params : Array[QueryParam]) -> String {
  let mut result = ""
  let mut first = true
  for p in params {
    if !first {
      result = result + "&"
    }
    first = false
    result = result + p.name + "=" + p.value
  }
  result
}

///|
/// 添加查询参数 | Add query parameter
pub fn add_query_param(uri : Uri, name : String, value : String) -> Uri {
  let param = name + "=" + value
  let new_query = if uri.query.length() > 0 { uri.query + "&" + param } else { param }
  { ..uri, query: new_query }
}

///|
/// 获取查询参数 | Get query parameter
pub fn get_query_param(uri : Uri, name : String) -> String? {
  let params = parse_query(uri.query)
  for p in params {
    if p.name == name {
      return Some(p.value)
    }
  }
  None
}

///|
/// URI 是否有效 | URI is valid
pub fn uri_is_valid(uri : Uri) -> Bool {
  uri.scheme.length() > 0 && uri.host.length() > 0
}

///|
/// 获取完整路径 | Get full path
pub fn uri_full_path(uri : Uri) -> String {
  let mut result = uri.path
  if uri.query.length() > 0 {
    result = result + "?" + uri.query
  }
  if uri.fragment.length() > 0 {
    result = result + "#" + uri.fragment
  }
  result
}

///|
/// 合并 URI | Merge URIs
pub fn merge_uris(u1 : Uri, u2 : Uri) -> Uri {
  {
    scheme: if u1.scheme.length() > 0 { u1.scheme } else { u2.scheme },
    host: if u1.host.length() > 0 { u1.host } else { u2.host },
    port: if u1.port > 0 { u1.port } else { u2.port },
    path: if u1.path.length() > 0 { u1.path } else { u2.path },
    query: if u1.query.length() > 0 { u1.query } else { u2.query },
    fragment: if u1.fragment.length() > 0 { u1.fragment } else { u2.fragment },
  }
}

///|
/// URI 版本 | URI version
pub fn uri_version() -> String {
  "moon-cross uri v0.2.23"
}

///|
/// QueryParam 实现 Named trait | QueryParam implements Named
pub impl @trait.Named for QueryParam with name(self) {
  self.name
}
pub extend QueryParam with @trait.Named::{name}
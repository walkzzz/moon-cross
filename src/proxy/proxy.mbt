///|
/// 代理配置 | Proxy config
pub(all) struct ProxyConfig {
  enabled : Bool
  access_list : Array[String]
  cache : Array[(String, String)]
} derive(Debug, Eq)
pub extend ProxyConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ProxyConfig with Eq::{not_equal, equal}

///|
/// 创建代理 | Create proxy
pub fn proxy_create() -> ProxyConfig {
  { enabled: true, access_list: [], cache: [] }
}

///|
/// 授权访问 | Grant access
pub fn proxy_grant(p : ProxyConfig, name : String) -> ProxyConfig {
  let new_list = []
  for n in p.access_list {
    new_list.push(n)
  }
  new_list.push(name)
  { enabled: p.enabled, access_list: new_list, cache: p.cache }
}

///|
/// 撤销访问 | Revoke access
pub fn proxy_revoke(p : ProxyConfig, name : String) -> ProxyConfig {
  let new_list = []
  for n in p.access_list {
    if n != name {
      new_list.push(n)
    }
  }
  { enabled: p.enabled, access_list: new_list, cache: p.cache }
}

///|
/// 检查访问 | Check access
pub fn proxy_can_access(p : ProxyConfig, name : String) -> Bool {
  if !p.enabled {
    return false
  }
  for n in p.access_list {
    if n == name {
      return true
    }
  }
  false
}

///|
/// 缓存操作 | Cache operation
pub fn proxy_cache_get(p : ProxyConfig, key : String) -> String? {
  for c in p.cache {
    if c.0 == key {
      return Some(c.1)
    }
  }
  None
}

///|
/// 缓存设置 | Cache set
pub fn proxy_cache_set(p : ProxyConfig, key : String, value : String) -> ProxyConfig {
  let new_cache = []
  let mut found = false
  for c in p.cache {
    if c.0 == key {
      new_cache.push((key, value))
      found = true
    } else {
      new_cache.push(c)
    }
  }
  if !found {
    new_cache.push((key, value))
  }
  { enabled: p.enabled, access_list: p.access_list, cache: new_cache }
}

///|
/// 启用/禁用 | Enable/disable
pub fn proxy_set_enabled(p : ProxyConfig, enabled : Bool) -> ProxyConfig {
  { enabled, access_list: p.access_list, cache: p.cache }
}

///|
/// 代理请求 | Proxy request
pub fn proxy_request(p : ProxyConfig, client : String, key : String) -> String? {
  if !proxy_can_access(p, client) {
    return None
  }
  proxy_cache_get(p, key)
}

///|
/// 代理版本 | Proxy version
pub fn proxy_version() -> String {
  "moon-cross proxy v0.3.6"
}
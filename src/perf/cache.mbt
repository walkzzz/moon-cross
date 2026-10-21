///|
/// 缓存条目 | Cache entry
pub(all) struct CacheEntry {
  key : String
  hash : String
  timestamp : Int
  size_bytes : Int
} derive(Debug, Eq)

pub extend CacheEntry with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CacheEntry with Eq::{not_equal, equal}

///|
/// 缓存配置 | Cache configuration
pub(all) struct CacheConfig {
  enabled : Bool
  max_size_mb : Int
  ttl_seconds : Int
} derive(Debug, Eq)

pub extend CacheConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CacheConfig with Eq::{not_equal, equal}

///|
/// 缓存统计 | Cache statistics
pub(all) struct CacheStats {
  hits : Int
  misses : Int
  total_size_bytes : Int
} derive(Debug, Eq)

pub extend CacheStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CacheStats with Eq::{not_equal, equal}

///|
/// 默认缓存配置 | Default cache configuration
pub fn default_cache_config() -> CacheConfig {
  { enabled: true, max_size_mb: 256, ttl_seconds: 86400 }
}

///|
/// 禁用缓存配置 | Disabled cache configuration
pub fn disabled_cache_config() -> CacheConfig {
  { enabled: false, max_size_mb: 0, ttl_seconds: 0 }
}

///|
/// 生成缓存键 | Generate cache key
pub fn cache_key(platform : @core.Platform, source_hash : String) -> String {
  platform.to_id() + ":" + source_hash
}

///|
/// 创建缓存条目 | Create cache entry
pub fn make_cache_entry(key : String, hash : String, timestamp : Int, size_bytes : Int) -> CacheEntry {
  { key, hash, timestamp, size_bytes }
}

///|
/// 检查缓存是否命中 | Check if cache hit
pub fn check_cache(config : CacheConfig, entry : CacheEntry?, current_time : Int) -> Bool {
  if !config.enabled {
    return false
  }
  match entry {
    Some(e) => {
      let age = current_time - e.timestamp
      age >= 0 && age <= config.ttl_seconds
    }
    None => false
  }
}

///|
/// 创建空缓存统计 | Create empty cache stats
pub fn empty_cache_stats() -> CacheStats {
  { hits: 0, misses: 0, total_size_bytes: 0 }
}

///|
/// 记算缓存命中率 | Calculate cache hit rate
pub fn hit_rate(stats : CacheStats) -> Double {
  let total = stats.hits + stats.misses
  if total == 0 {
    0.0
  } else {
    stats.hits.to_double() / total.to_double()
  }
}

///|
/// 检查缓存是否超容 | Check if cache exceeds max size
pub fn cache_exceeds_size(config : CacheConfig, current_size_bytes : Int) -> Bool {
  let max_bytes = config.max_size_mb * 1024 * 1024
  current_size_bytes > max_bytes
}

///|
/// 计算需要清理的空间 | Calculate space to reclaim
pub fn space_to_reclaim(config : CacheConfig, current_size_bytes : Int) -> Int {
  let max_bytes = config.max_size_mb * 1024 * 1024
  if current_size_bytes > max_bytes {
    current_size_bytes - max_bytes
  } else {
    0
  }
}

///|
/// 缓存版本 | Cache version
pub fn cache_version() -> String {
  "moon-cross perf/cache v0.1.0"
}

///|
/// CacheConfig 实现 Checkable trait | CacheConfig implements Checkable
pub impl @trait.Checkable for CacheConfig with check(self) {
  self.enabled
}
pub extend CacheConfig with @trait.Checkable::{check}
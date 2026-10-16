///|
/// 淘汰策略 | Eviction policy
pub(all) enum EvictionPolicy {
  Lru
  Fifo
  Ttl
} derive(Debug, Eq)
pub extend EvictionPolicy with @moonbitlang/core/debug.Debug::{to_repr}
pub extend EvictionPolicy with Eq::{not_equal, equal}

///|
/// 缓存条目 | Cache entry
pub(all) struct CacheEntry {
  key : String
  value : String
  timestamp : Int
  access_count : Int
  last_access : Int
} derive(Debug, Eq)
pub extend CacheEntry with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CacheEntry with Eq::{not_equal, equal}

///|
/// 缓存配置 | Cache configuration
pub(all) struct CacheConfig {
  max_size : Int
  ttl_ms : Int
  eviction_policy : EvictionPolicy
} derive(Debug, Eq)
pub extend CacheConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CacheConfig with Eq::{not_equal, equal}

///|
/// 缓存统计 | Cache statistics
pub(all) struct CacheStats {
  hits : Int
  misses : Int
  evictions : Int
  size : Int
} derive(Debug, Eq)
pub extend CacheStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CacheStats with Eq::{not_equal, equal}

///|
/// 缓存 | Cache
pub(all) struct Cache {
  entries : Array[CacheEntry]
  config : CacheConfig
  stats : CacheStats
} derive(Debug, Eq)
pub extend Cache with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Cache with Eq::{not_equal, equal}

///|
/// 默认缓存配置 | Default cache configuration
pub fn default_cache_config() -> CacheConfig {
  { max_size: 100, ttl_ms: 60000, eviction_policy: Lru }
}

///|
/// 创建缓存条目 | Create cache entry
pub fn make_entry(key : String, value : String) -> CacheEntry {
  { key, value, timestamp: 0, access_count: 1, last_access: 0 }
}

///|
/// 创建带时间戳的缓存条目 | Create cache entry with timestamp
pub fn make_entry_at(
  key : String,
  value : String,
  timestamp : Int,
) -> CacheEntry {
  { key, value, timestamp, access_count: 1, last_access: timestamp }
}

///|
/// 创建缓存 | Create cache
pub fn create_cache(config : CacheConfig) -> Cache {
  { entries: [], config, stats: { hits: 0, misses: 0, evictions: 0, size: 0 } }
}

///|
/// 缓存大小 | Cache size
pub fn cache_size(cache : Cache) -> Int {
  cache.entries.length()
}

///|
/// 缓存是否包含键 | Check if cache contains key
pub fn cache_contains(cache : Cache, key : String) -> Bool {
  for entry in cache.entries {
    if entry.key == key {
      return true
    }
  }
  false
}

///|
/// 缓存获取 | Cache get
pub fn cache_get(cache : Cache, key : String) -> String? {
  for entry in cache.entries {
    if entry.key == key {
      return Some(entry.value)
    }
  }
  None
}

///|
/// 缓存放入 | Cache put
pub fn cache_put(
  cache : Cache,
  key : String,
  value : String,
) -> Cache {
  let entries = []
  let mut found = false
  for entry in cache.entries {
    if entry.key == key {
      entries.push({ ..entry, value, access_count: entry.access_count + 1 })
      found = true
    } else {
      entries.push(entry)
    }
  }
  if !found {
    entries.push({ key, value, timestamp: 0, access_count: 1, last_access: 0 })
  }
  let result_entries = entries
  let mut evictions = cache.stats.evictions
  while result_entries.length() > cache.config.max_size {
    let mut min_idx = 0
    let mut min_access = result_entries[0].last_access
    for i in 1..<result_entries.length() {
      if result_entries[i].last_access < min_access {
        min_access = result_entries[i].last_access
        min_idx = i
      }
    }
    let _ = result_entries.remove(min_idx)
    evictions = evictions + 1
  }
  { entries: result_entries, config: cache.config, stats: { hits: cache.stats.hits, misses: cache.stats.misses, evictions, size: result_entries.length() } }
}

///|
/// 缓存移除 | Cache remove
pub fn cache_remove(cache : Cache, key : String) -> Cache {
  let entries = []
  for entry in cache.entries {
    if entry.key != key {
      entries.push(entry)
    }
  }
  { entries, config: cache.config, stats: { ..cache.stats, size: entries.length() } }
}

///|
/// 缓存清空 | Cache clear
pub fn cache_clear(cache : Cache) -> Cache {
  { entries: [], config: cache.config, stats: { hits: cache.stats.hits, misses: cache.stats.misses, evictions: cache.stats.evictions, size: 0 } }
}

///|
/// 缓存键列表 | Cache keys
pub fn cache_keys(cache : Cache) -> Array[String] {
  let result = []
  for entry in cache.entries {
    result.push(entry.key)
  }
  result
}

///|
/// 缓存值列表 | Cache values
pub fn cache_values(cache : Cache) -> Array[String] {
  let result = []
  for entry in cache.entries {
    result.push(entry.value)
  }
  result
}

///|
/// 缓存统计 | Cache statistics
pub fn cache_stats(cache : Cache) -> CacheStats {
  cache.stats
}

///|
/// 缓存命中率 | Cache hit ratio
pub fn cache_hit_ratio(cache : Cache) -> Double {
  let total = cache.stats.hits + cache.stats.misses
  if total == 0 {
    return 0.0
  }
  cache.stats.hits.to_double() / total.to_double()
}

///|
/// 记录命中 | Record hit
pub fn record_hit(cache : Cache) -> Cache {
  { ..cache, stats: { ..cache.stats, hits: cache.stats.hits + 1 } }
}

///|
/// 记录未命中 | Record miss
pub fn record_miss(cache : Cache) -> Cache {
  { ..cache, stats: { ..cache.stats, misses: cache.stats.misses + 1 } }
}

///|
/// 是否过期 | Check if expired
pub fn is_expired(
  entry : CacheEntry,
  current_time : Int,
  ttl_ms : Int,
) -> Bool {
  current_time - entry.timestamp > ttl_ms
}

///|
/// 清理过期条目 | Evict expired entries
pub fn evict_expired(
  cache : Cache,
  current_time : Int,
) -> Cache {
  let entries = []
  let mut evictions = cache.stats.evictions
  for entry in cache.entries {
    if is_expired(entry, current_time, cache.config.ttl_ms) {
      evictions = evictions + 1
    } else {
      entries.push(entry)
    }
  }
  { entries, config: cache.config, stats: { ..cache.stats, evictions, size: entries.length() } }
}

///|
/// 缓存版本 | Cache version
pub fn cache_version() -> String {
  "moon-cross cache v0.2.11"
}

///|
/// 淘汰策略名称 | Eviction policy name
pub fn eviction_policy_name(policy : EvictionPolicy) -> String {
  match policy {
    Lru => "LRU"
    Fifo => "FIFO"
    Ttl => "TTL"
  }
}

///|
/// 合并缓存 | Merge caches
pub fn merge_caches(c1 : Cache, c2 : Cache) -> Cache {
  let entries = []
  for e in c1.entries {
    entries.push(e)
  }
  for e in c2.entries {
    let mut found = false
    for existing in entries {
      if existing.key == e.key {
        found = true
        break
      }
    }
    if !found {
      entries.push(e)
    }
  }
  { entries, config: c1.config, stats: { hits: c1.stats.hits + c2.stats.hits, misses: c1.stats.misses + c2.stats.misses, evictions: c1.stats.evictions + c2.stats.evictions, size: entries.length() } }
}
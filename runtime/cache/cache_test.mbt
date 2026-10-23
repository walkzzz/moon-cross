test "default_cache_config" {
  let cfg = @cache.default_cache_config()
  assert_eq(cfg.max_size, 100)
  assert_eq(cfg.ttl_ms, 60000)
  assert_eq(cfg.eviction_policy, @cache.EvictionPolicy::Lru)
}

test "make_entry" {
  let e = @cache.make_entry("key", "value")
  assert_eq(e.key, "key")
  assert_eq(e.value, "value")
  assert_eq(e.access_count, 1)
}

test "make_entry_at" {
  let e = @cache.make_entry_at("k", "v", 1000)
  assert_eq(e.timestamp, 1000)
  assert_eq(e.last_access, 1000)
}

test "create_cache" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  assert_eq(@cache.cache_size(c), 0)
}

test "cache_size_empty" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  assert_eq(@cache.cache_size(c), 0)
}

test "cache_contains_false" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  assert_true(!@cache.cache_contains(c, "x"))
}

test "cache_put_and_get" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let c1 = @cache.cache_put(c, "key", "value")
  match @cache.cache_get(c1, "key") {
    Some(v) => assert_eq(v, "value")
    None => assert_true(false)
  }
}

test "cache_get_missing" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  match @cache.cache_get(c, "x") {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "cache_put_update" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let c1 = @cache.cache_put(c, "k", "v1")
  let c2 = @cache.cache_put(c1, "k", "v2")
  match @cache.cache_get(c2, "k") {
    Some(v) => assert_eq(v, "v2")
    None => assert_true(false)
  }
  assert_eq(@cache.cache_size(c2), 1)
}

test "cache_remove" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let c1 = @cache.cache_put(c, "k", "v")
  let c2 = @cache.cache_remove(c1, "k")
  assert_true(!@cache.cache_contains(c2, "k"))
}

test "cache_clear" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let c1 = @cache.cache_put(c, "a", "1")
  let c2 = @cache.cache_put(c1, "b", "2")
  let c3 = @cache.cache_clear(c2)
  assert_eq(@cache.cache_size(c3), 0)
}

test "cache_keys" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let c1 = @cache.cache_put(c, "a", "1")
  let c2 = @cache.cache_put(c1, "b", "2")
  let keys = @cache.cache_keys(c2)
  assert_eq(keys.length(), 2)
}

test "cache_values" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let c1 = @cache.cache_put(c, "a", "1")
  let c2 = @cache.cache_put(c1, "b", "2")
  let vals = @cache.cache_values(c2)
  assert_eq(vals.length(), 2)
}

test "cache_stats" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let stats = @cache.cache_stats(c)
  assert_eq(stats.hits, 0)
  assert_eq(stats.misses, 0)
}

test "cache_hit_ratio_no_data" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  assert_eq(@cache.cache_hit_ratio(c), 0.0)
}

test "cache_hit_ratio_with_data" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let c1 = @cache.record_hit(c)
  let c2 = @cache.record_hit(c1)
  let c3 = @cache.record_miss(c2)
  assert_eq(@cache.cache_hit_ratio(c3), 2.0 / 3.0)
}

test "record_hit" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let c1 = @cache.record_hit(c)
  assert_eq(c1.stats.hits, 1)
}

test "record_miss" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let c1 = @cache.record_miss(c)
  assert_eq(c1.stats.misses, 1)
}

test "is_expired_false" {
  let e = @cache.make_entry_at("k", "v", 1000)
  assert_true(!@cache.is_expired(e, 1500, 60000))
}

test "is_expired_true" {
  let e = @cache.make_entry_at("k", "v", 1000)
  assert_true(@cache.is_expired(e, 70000, 60000))
}

test "evict_expired" {
  let cfg = @cache.CacheConfig::{ max_size: 100, ttl_ms: 100, eviction_policy: @cache.EvictionPolicy::Ttl }
  let c = @cache.create_cache(cfg)
  let c1 = @cache.cache_put(c, "k", "v")
  let c2 = @cache.evict_expired(c1, 200)
  assert_eq(@cache.cache_size(c2), 0)
}

test "cache_version" {
  let v = @cache.cache_version()
  assert_true(v.contains("cache"))
}

test "eviction_policy_name" {
  assert_eq(@cache.eviction_policy_name(@cache.EvictionPolicy::Lru), "LRU")
  assert_eq(@cache.eviction_policy_name(@cache.EvictionPolicy::Fifo), "FIFO")
  assert_eq(@cache.eviction_policy_name(@cache.EvictionPolicy::Ttl), "TTL")
}

test "cache_put_eviction" {
  let cfg = @cache.CacheConfig::{ max_size: 2, ttl_ms: 60000, eviction_policy: @cache.EvictionPolicy::Lru }
  let c = @cache.create_cache(cfg)
  let c1 = @cache.cache_put(c, "a", "1")
  let c2 = @cache.cache_put(c1, "b", "2")
  let c3 = @cache.cache_put(c2, "c", "3")
  assert_eq(@cache.cache_size(c3), 2)
}

test "merge_caches" {
  let cfg = @cache.default_cache_config()
  let c1 = @cache.create_cache(cfg)
  let c2 = @cache.create_cache(cfg)
  let c1a = @cache.cache_put(c1, "a", "1")
  let c2a = @cache.cache_put(c2, "b", "2")
  let merged = @cache.merge_caches(c1a, c2a)
  assert_eq(@cache.cache_size(merged), 2)
}

test "cache_contains_after_put" {
  let cfg = @cache.default_cache_config()
  let c = @cache.create_cache(cfg)
  let c1 = @cache.cache_put(c, "k", "v")
  assert_true(@cache.cache_contains(c1, "k"))
}
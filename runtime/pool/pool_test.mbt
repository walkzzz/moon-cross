test "default_pool_config" {
  let cfg = @pool.default_pool_config()
  assert_eq(cfg.max_size, 10)
  assert_eq(cfg.min_size, 0)
  assert_true(cfg.auto_shrink)
}

test "make_pool_entry" {
  let e = @pool.make_pool_entry("v", 1000)
  assert_eq(e.value, "v")
  assert_eq(e.created_at, 1000)
  assert_eq(e.use_count, 0)
}

test "create_pool" {
  let cfg = @pool.default_pool_config()
  let p = @pool.create_pool(cfg)
  assert_eq(@pool.pool_size(p), 0)
  assert_true(@pool.pool_is_empty(p))
  assert_false(@pool.pool_is_full(p))
}

test "pool_size_empty" {
  let p = @pool.create_pool(@pool.default_pool_config())
  assert_eq(@pool.pool_size(p), 0)
}

test "pool_idle_count" {
  let p = @pool.create_pool(@pool.default_pool_config())
  assert_eq(@pool.pool_idle_count(p), 0)
}

test "pool_active_count" {
  let p = @pool.create_pool(@pool.default_pool_config())
  assert_eq(@pool.pool_active_count(p), 0)
}

test "pool_acquire_from_empty" {
  let p = @pool.create_pool(@pool.default_pool_config())
  let (p1, val) = @pool.pool_acquire(p, 1000)
  assert_true(val is Some(_))
  assert_eq(@pool.pool_active_count(p1), 1)
  assert_eq(@pool.pool_size(p1), 1)
}

test "pool_acquire_creates_new" {
  let p = @pool.create_pool(@pool.default_pool_config())
  let (p1, _) = @pool.pool_acquire(p, 1000)
  let (p2, _) = @pool.pool_acquire(p1, 2000)
  assert_eq(@pool.pool_active_count(p2), 2)
}

test "pool_acquire_full_returns_none" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 1, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let (p1, v1) = @pool.pool_acquire(p, 1000)
  assert_true(v1 is Some(_))
  let (_, v2) = @pool.pool_acquire(p1, 2000)
  assert_true(v2 is None)
}

test "pool_release" {
  let p = @pool.create_pool(@pool.default_pool_config())
  let (p1, v) = @pool.pool_acquire(p, 1000)
  let val = match v {
    Some(s) => s
    None => ""
  }
  let p2 = @pool.pool_release(p1, val, 2000)
  assert_eq(@pool.pool_active_count(p2), 0)
  assert_eq(@pool.pool_idle_count(p2), 1)
}

test "pool_acquire_release_reuse" {
  let p = @pool.create_pool(@pool.default_pool_config())
  let (p1, _) = @pool.pool_acquire(p, 1000)
  let p2 = @pool.pool_release(p1, "reused", 2000)
  let (p3, v) = @pool.pool_acquire(p2, 3000)
  assert_true(v is Some(_))
  let val = match v {
    Some(s) => s
    None => ""
  }
  assert_eq(val, "reused")
  assert_eq(@pool.pool_active_count(p3), 1)
  assert_eq(@pool.pool_idle_count(p3), 0)
}

test "pool_preallocate" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 10, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let p1 = @pool.pool_preallocate(p, 5, 1000)
  assert_eq(@pool.pool_idle_count(p1), 5)
  assert_eq(@pool.pool_size(p1), 5)
}

test "pool_preallocate_respects_max" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 3, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let p1 = @pool.pool_preallocate(p, 10, 1000)
  assert_eq(@pool.pool_idle_count(p1), 3)
}

test "pool_clear" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 10, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let p1 = @pool.pool_preallocate(p, 5, 1000)
  let p2 = @pool.pool_clear(p1)
  assert_eq(@pool.pool_idle_count(p2), 0)
}

test "pool_shrink" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 10, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let p1 = @pool.pool_preallocate(p, 5, 1000)
  let p2 = @pool.pool_shrink(p1, 2)
  assert_eq(@pool.pool_idle_count(p2), 2)
}

test "pool_shrink_no_op" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 10, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let p1 = @pool.pool_preallocate(p, 3, 1000)
  let p2 = @pool.pool_shrink(p1, 5)
  assert_eq(@pool.pool_idle_count(p2), 3)
}

test "is_idle_expired" {
  let e = @pool.make_pool_entry("v", 1000)
  assert_true(@pool.is_idle_expired(e, 70000, 60000))
  assert_false(@pool.is_idle_expired(e, 30000, 60000))
}

test "pool_evict_expired" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 10, idle_timeout_ms: 100, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let p1 = @pool.pool_preallocate(p, 3, 1000)
  let p2 = @pool.pool_evict_expired(p1, 2000)
  assert_eq(@pool.pool_idle_count(p2), 0)
}

test "pool_evict_expired_keeps_recent" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 10, idle_timeout_ms: 100000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let p1 = @pool.pool_preallocate(p, 3, 1000)
  let p2 = @pool.pool_evict_expired(p1, 2000)
  assert_eq(@pool.pool_idle_count(p2), 3)
}

test "pool_stats" {
  let p = @pool.create_pool(@pool.default_pool_config())
  let s = @pool.pool_stats(p)
  assert_eq(s.active, 0)
  assert_eq(s.idle, 0)
}

test "pool_utilization" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 10, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let (p1, _) = @pool.pool_acquire(p, 1000)
  let util = @pool.pool_utilization(p1)
  assert_true(util > 0.0)
}

test "pool_utilization_zero_max" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 0, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  assert_eq(@pool.pool_utilization(p), 0.0)
}

test "pool_contains" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 10, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let p1 = @pool.pool_release(p, "test_val", 1000)
  assert_true(@pool.pool_contains(p1, "test_val"))
  assert_false(@pool.pool_contains(p1, "nonexistent"))
}

test "pool_idle_values" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 10, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let p1 = @pool.pool_release(p, "a", 1000)
  let p2 = @pool.pool_release(p1, "b", 2000)
  let vals = @pool.pool_idle_values(p2)
  assert_eq(vals.length(), 2)
}

test "merge_pools" {
  let cfg = @pool.default_pool_config()
  let p1 = @pool.create_pool(cfg)
  let p2 = @pool.create_pool(cfg)
  let p1a = @pool.pool_preallocate(p1, 3, 1000)
  let p2a = @pool.pool_preallocate(p2, 2, 1000)
  let merged = @pool.merge_pools(p1a, p2a)
  assert_eq(@pool.pool_idle_count(merged), 5)
}

test "pool_is_full" {
  let cfg = @pool.PoolConfig::{ min_size: 0, max_size: 2, idle_timeout_ms: 60000, auto_shrink: true }
  let p = @pool.create_pool(cfg)
  let p1 = @pool.pool_preallocate(p, 2, 1000)
  assert_true(@pool.pool_is_full(p1))
}

test "pool_version" {
  let v = @pool.pool_version()
  assert_true(v.contains("pool"))
}